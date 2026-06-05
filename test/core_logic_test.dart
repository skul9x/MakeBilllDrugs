import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_info.dart';
import 'package:drugs_maker/models/drug_item.dart';
import 'package:drugs_maker/services/drug_parser.dart';
import 'package:drugs_maker/services/excel_service.dart';

void main() {
  group('DrugParser Tests', () {
    final parser = DrugParser();

    test('Parser extracts from table row correctly', () async {
      final html = '''
        <html>
          <body>
            <h1>Paracetamol 500mg</h1>
            <table>
              <tr>
                <td>Thương hiệu</td>
                <td>Dược phẩm An Thiên (A.T PHARMA CORP), HCMC</td>
              </tr>
              <tr>
                <td>Quy cách đóng gói</td>
                <td>Hộp 10 vỉ x 10 viên</td>
              </tr>
            </table>
          </body>
        </html>
      ''';
      final info = await parser.extractDrugInfo(html);
      expect(info.name, equals('Paracetamol 500mg'));
      expect(info.brand, equals('An Thiên'));
      expect(info.quyCach, equals('Hộp 10 vỉ x 10 viên'));
    });

    test('Parser extracts brand and packaging from fallbacks and regex', () async {
      final html = '''
        <html>
          <body>
            <span class="product-name">Ibuprofen 400mg</span>
            <div id="cs-thuong-hieu">
              <table>
                <tr>
                  <td>Some label</td>
                  <td>Mekophar, Vietnam</td>
                </tr>
              </table>
            </div>
            <p>Đóng gói: Chai 100 viên</p>
          </body>
        </html>
      ''';
      final info = await parser.extractDrugInfo(html);
      expect(info.name, equals('Ibuprofen 400mg'));
      expect(info.brand, equals('Mekophar'));
      expect(info.quyCach, equals('Chai 100 viên'));
    });

    test('Parser extracts from free text regex fallback', () async {
      final html = '''
        <html>
          <body>
            <div class="entry-title">Amoxicillin 500mg</div>
            <div>Some random description. Đóng gói: Hộp 10 vỉ x 10 viên nang. Brand: Abbott</div>
          </body>
        </html>
      ''';
      final info = await parser.extractDrugInfo(html);
      expect(info.name, equals('Amoxicillin 500mg'));
      expect(info.brand, equals('N/A'));
      expect(info.quyCach, equals('Hộp 10 vỉ x 10 viên nang. Brand: Abbott'));
    });
  });

  group('ExcelService Tests', () {
    final excelService = ExcelService();

    test('Excel roundtrip generation and import works', () async {
      final items = [
        DrugItem(stt: 1, name: 'Paracetamol', brand: 'An Thiên', quyCach: 'Hộp 10 vỉ x 10 viên', quantity: 5),
        DrugItem(stt: 2, name: 'Ibuprofen', brand: 'Mekophar', quyCach: 'Chai 100 viên', quantity: 10),
      ];

      final outputPath = 'test/test_out.xlsx';
      
      // Ensure test directory exists
      Directory('test').createSync(recursive: true);

      // Delete old test output if exists
      final outFile = File(outputPath);
      if (outFile.existsSync()) {
        outFile.deleteSync();
      }

      await excelService.generateExcel(items, outputPath);
      expect(outFile.existsSync(), isTrue);

      final importedItems = await excelService.importExcel(outputPath);
      expect(importedItems.length, equals(2));

      expect(importedItems[0].stt, equals(1));
      expect(importedItems[0].name, equals('Paracetamol'));
      expect(importedItems[0].brand, equals('An Thiên'));
      expect(importedItems[0].quyCach, equals('Hộp 10 vỉ x 10 viên'));
      expect(importedItems[0].quantity, equals(5));

      expect(importedItems[1].stt, equals(2));
      expect(importedItems[1].name, equals('Ibuprofen'));
      expect(importedItems[1].brand, equals('Mekophar'));
      expect(importedItems[1].quyCach, equals('Chai 100 viên'));
      expect(importedItems[1].quantity, equals(10));
    });
  });
}
