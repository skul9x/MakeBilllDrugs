import 'dart:io';
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import '../models/drug_info.dart';

class DrugParser {
  static String cleanHTMLAndWhitespace(String input) {
    String cleaned = input.replaceAll('&nbsp;', ' ').replaceAll('&NBSP;', ' ');
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');
    cleaned = cleaned.trim();
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    return cleaned;
  }

  Future<DrugInfo> extractDrugInfo(String htmlContent) async {
    var document = parse(htmlContent);

    bool isLongChau = htmlContent.contains('nhathuoclongchau.com.vn') ||
                      htmlContent.contains('Nhà thuốc Long Châu');

    // 1. Drug Name
    var nameNode = document.querySelector('h1');
    if (nameNode == null) {
      nameNode = document.querySelector('.product-name, .entry-title, .title-detail');
    }
    if (nameNode == null) {
      throw Exception("could not find drug name in DOM structure");
    }
    String name = cleanHTMLAndWhitespace(nameNode.text);

    // 2. Quy Cách
    String quyCach = '';
    if (isLongChau) {
      var allElements = document.querySelectorAll('*');
      for (var element in allElements) {
        var txt = element.text.trim().toLowerCase();
        if ((txt == 'quy cách' || txt == 'quy cách:') && element.children.isEmpty) {
          var parent = element.parent;
          if (parent != null) {
            var sibling = parent.nextElementSibling;
            if (sibling != null) {
              quyCach = sibling.text.trim();
              break;
            }
          }
        }
      }

      if (quyCach.isEmpty) {
        var nextDataNode = document.querySelector('script#__NEXT_DATA__');
        if (nextDataNode != null) {
          try {
            final data = json.decode(nextDataNode.text);
            final spec = data['props']?['pageProps']?['product']?['specification'];
            if (spec != null && spec.toString().trim().isNotEmpty) {
              quyCach = spec.toString().trim();
            }
          } catch (_) {}
        }
      }
    }

    if (quyCach.isEmpty) {
      var trs = document.querySelectorAll('tr');
      for (var tr in trs) {
        if (quyCach.isNotEmpty) break;
        var cells = tr.querySelectorAll('td');
        if (cells.length >= 2) {
          var firstCellText = cells[0].text.trim().toLowerCase();
          if (firstCellText.contains('quy cách đóng gói') || firstCellText == 'đóng gói') {
            quyCach = cells[1].text;
          }
        }
      }
    }

    if (quyCach.isEmpty) {
      var candidates = document.querySelectorAll('li, p, div, span');
      for (var element in candidates) {
        if (quyCach.isNotEmpty) break;
        if (element.querySelector('p, li') != null) {
          continue;
        }
        var txt = element.text;
        var lowerTxt = txt.toLowerCase();
        if (lowerTxt.contains('quy cách đóng gói') || 
            (lowerTxt.contains('đóng gói') && lowerTxt.contains(':'))) {
          var parts = txt.split(':');
          if (parts.length >= 2) {
            quyCach = parts.sublist(1).join(':');
          }
        }
      }
    }

    if (quyCach.isEmpty) {
      var plainText = document.body?.text ?? document.text ?? '';
      var regex = RegExp(r'(?:Quy cách đóng gói|Đóng gói)\s*:\s*([^.\n\r]+)', caseSensitive: false);
      var match = regex.firstMatch(plainText);
      if (match != null && match.groupCount >= 1) {
        quyCach = match.group(1) ?? '';
      }
    }

    if (quyCach.isEmpty) {
      throw Exception("could not find packing details (Quy cách đóng gói)");
    }
    quyCach = cleanHTMLAndWhitespace(quyCach);

    // 3. Brand (Thương hiệu)
    String brand = '';
    if (isLongChau) {
      var nextDataNode = document.querySelector('script#__NEXT_DATA__');
      if (nextDataNode != null) {
        try {
          final data = json.decode(nextDataNode.text);
          final producer = data['props']?['pageProps']?['product']?['producer'];
          if (producer != null && producer.toString().trim().isNotEmpty) {
            brand = producer.toString().trim();
          }
        } catch (_) {}
      }

      if (brand.isEmpty) {
        var allElements = document.querySelectorAll('*');
        for (var element in allElements) {
          var txt = element.text.trim().toLowerCase();
          if (txt == 'nhà sản xuất' || txt == 'nhà sản xuất:') {
            var parent = element.parent;
            if (parent != null) {
              var sibling = parent.nextElementSibling;
              if (sibling != null) {
                brand = sibling.text.trim();
                break;
              }
            }
          } else if (txt.startsWith('nhà sản xuất:')) {
            var parts = element.text.split(':');
            brand = parts.sublist(1).join(':').trim();
            break;
          }
        }
      }
    } else {
      var brandNode = document.querySelector('#cs-thuong-hieu');
      if (brandNode != null) {
        var cells = brandNode.querySelectorAll('td');
        if (cells.length >= 2) {
          brand = cells[1].text;
        } else {
          brand = brandNode.text;
        }
      } else {
        var trs = document.querySelectorAll('tr');
        for (var tr in trs) {
          if (brand.isNotEmpty) break;
          var cells = tr.querySelectorAll('td');
          if (cells.length >= 2) {
            var firstCellText = cells[0].text.trim().toLowerCase();
            if (firstCellText.contains('thương hiệu') || firstCellText == 'brand') {
              brand = cells[1].text;
            }
          }
        }
      }
    }

    if (brand.isNotEmpty) {
      var parts = brand.split(',');
      brand = parts[0].trim();
      brand = cleanHTMLAndWhitespace(brand);
      if (brand == 'Dược phẩm An Thiên (A.T PHARMA CORP)') {
        brand = 'An Thiên';
      }
    } else {
      brand = 'N/A';
    }

    return DrugInfo(
      name: name,
      brand: brand,
      quyCach: quyCach,
    );
  }

  Future<DrugInfo> fetchAndParse(String source) async {
    String htmlContent = '';
    if (source.startsWith('http://') || source.startsWith('https://')) {
      final response = await http.get(
        Uri.parse(source),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('failed to fetch URL, HTTP status: ${response.statusCode}');
      }
      htmlContent = response.body;
    } else {
      String filePath = source;
      if (filePath.startsWith('file://')) {
        filePath = Uri.parse(filePath).toFilePath();
      }
      htmlContent = await File(filePath).readAsString();
    }

    return extractDrugInfo(htmlContent);
  }
}
