import 'dart:io';
import 'package:excel/excel.dart';
import '../models/drug_item.dart';

class ExcelService {
  String _getCellString(Data? cell) {
    if (cell == null || cell.value == null) return '';
    final val = cell.value;
    if (val is TextCellValue) {
      return val.value.text ?? '';
    }
    if (val is IntCellValue) {
      return val.value.toString();
    }
    if (val is DoubleCellValue) {
      return val.value.toString();
    }
    if (val is BoolCellValue) {
      return val.value.toString();
    }
    try {
      return (val as dynamic).value.toString();
    } catch (_) {
      return val.toString();
    }
  }

  Future<void> generateExcel(List<DrugItem> items, String outputPath) async {
    final sortedItems = DrugItem.sortAndReindex(items);
    final excel = Excel.createExcel();
    const sheetName = 'Sheet1';
    final sheet = excel[sheetName];

    // Slate-gray header background (#E2E8F0), Times New Roman font, cell borders, correct alignments
    final headerStyle = CellStyle(
      bold: true,
      fontSize: 12,
      fontFamily: 'Times New Roman',
      fontColorHex: ExcelColor.fromHexString('#FF1A202C'),
      backgroundColorHex: ExcelColor.fromHexString('#FFE2E8F0'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFCBD5E1')),
      rightBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFCBD5E1')),
      topBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFCBD5E1')),
      bottomBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFCBD5E1')),
    );

    final dataLeftStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Times New Roman',
      horizontalAlign: HorizontalAlign.Left,
      verticalAlign: VerticalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
      rightBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
      topBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
      bottomBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
    );

    final dataCenterStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Times New Roman',
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      leftBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
      rightBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
      topBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
      bottomBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: ExcelColor.fromHexString('#FFE2E8F0')),
    );

    final headers = ['STT', 'Tên thuốc', 'Thương hiệu', 'Quy cách', 'Số lượng'];

    // 1. Write Headers
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }
    sheet.setRowHeight(0, 28.0);

    // 2. Write Data Rows
    for (int i = 0; i < sortedItems.length; i++) {
      final item = sortedItems[i];
      final rowIdx = i + 1;

      final cellSTT = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx));
      cellSTT.value = IntCellValue(item.stt);
      cellSTT.cellStyle = dataCenterStyle;

      final cellName = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx));
      cellName.value = TextCellValue(item.name);
      cellName.cellStyle = dataLeftStyle;

      final cellBrand = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIdx));
      cellBrand.value = TextCellValue(item.brand);
      cellBrand.cellStyle = dataLeftStyle;

      final cellQuyCach = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIdx));
      cellQuyCach.value = TextCellValue(item.quyCach);
      cellQuyCach.cellStyle = dataLeftStyle;

      final cellQty = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIdx));
      cellQty.value = IntCellValue(item.quantity);
      cellQty.cellStyle = dataCenterStyle;

      sheet.setRowHeight(rowIdx, 24.0);
    }

    // 3. Auto-fit column widths with UTF-8 character length optimization
    for (int colIdx = 0; colIdx < headers.length; colIdx++) {
      double maxLen = 0;
      for (int rowIdx = 0; rowIdx <= sortedItems.length; rowIdx++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: rowIdx));
        if (cell.value != null) {
          String valStr = '';
          final val = cell.value!;
          if (val is TextCellValue) {
            valStr = val.value.text ?? '';
          } else if (val is IntCellValue) {
            valStr = val.value.toString();
          } else {
            valStr = val.toString();
          }
          double effectiveLen = valStr.runes.length.toDouble();
          if (valStr.length > valStr.runes.length || valStr.runes.any((r) => r > 127)) {
            effectiveLen = effectiveLen * 1.25;
          }
          if (effectiveLen > maxLen) {
            maxLen = effectiveLen;
          }
        }
      }
      double width = maxLen + 5.0;
      if (width < 12.0) {
        width = 12.0;
      }
      sheet.setColumnWidth(colIdx, width);
    }

    final bytes = excel.save();
    if (bytes != null) {
      final file = File(outputPath);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
    } else {
      throw Exception('failed to encode excel file');
    }
  }

  Future<List<DrugItem>> importExcel(String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    if (excel.tables.isEmpty) {
      throw Exception('no sheets found in excel file');
    }

    String sheetName = 'Sheet1';
    if (!excel.tables.containsKey(sheetName)) {
      sheetName = excel.tables.keys.first;
    }

    final sheet = excel.tables[sheetName]!;
    final rows = sheet.rows;
    if (rows.isEmpty) {
      throw Exception('Excel file does not match the standard template');
    }

    final header = rows[0];
    bool isLegacy = false;

    if (header.length == 4) {
      final col0 = _getCellString(header[0]).trim();
      final col1 = _getCellString(header[1]).trim();
      final col2 = _getCellString(header[2]).trim();
      final col3 = _getCellString(header[3]).trim();
      if (col0 == 'STT' && col1 == 'Tên thuốc' && col2 == 'Quy cách' && col3 == 'Số lượng') {
        isLegacy = true;
      } else {
        throw Exception('Excel file does not match the standard template');
      }
    } else if (header.length >= 5) {
      final col0 = _getCellString(header[0]).trim();
      final col1 = _getCellString(header[1]).trim();
      final col2 = _getCellString(header[2]).trim();
      final col3 = _getCellString(header[3]).trim();
      final col4 = _getCellString(header[4]).trim();
      if (col0 != 'STT' || col1 != 'Tên thuốc' || col2 != 'Thương hiệu' || col3 != 'Quy cách' || col4 != 'Số lượng') {
        throw Exception('Excel file does not match the standard template');
      }
    } else {
      throw Exception('Excel file does not match the standard template');
    }

    final List<DrugItem> items = [];
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      // Check if row is empty
      bool isEmpty = true;
      for (final cell in row) {
        if (_getCellString(cell).trim().isNotEmpty) {
          isEmpty = false;
          break;
        }
      }
      if (isEmpty) {
        continue;
      }

      String sttVal = '';
      String nameVal = '';
      String brandVal = '';
      String quyCachVal = '';
      String qtyVal = '';

      if (isLegacy) {
        if (row.isNotEmpty) sttVal = _getCellString(row[0]).trim();
        if (row.length > 1) nameVal = _getCellString(row[1]).trim();
        if (row.length > 2) quyCachVal = _getCellString(row[2]).trim();
        if (row.length > 3) qtyVal = _getCellString(row[3]).trim();
      } else {
        if (row.isNotEmpty) sttVal = _getCellString(row[0]).trim();
        if (row.length > 1) nameVal = _getCellString(row[1]).trim();
        if (row.length > 2) brandVal = _getCellString(row[2]).trim();
        if (row.length > 3) quyCachVal = _getCellString(row[3]).trim();
        if (row.length > 4) qtyVal = _getCellString(row[4]).trim();
      }

      final int? stt = int.tryParse(sttVal);
      if (stt == null) {
        throw Exception('invalid STT format: $sttVal');
      }

      final int? qty = int.tryParse(qtyVal);
      if (qty == null || qty < 1) {
        throw Exception('invalid quantity format: $qtyVal');
      }

      if (brandVal == 'Dược phẩm An Thiên (A.T PHARMA CORP)') {
        brandVal = 'An Thiên';
      }

      items.add(DrugItem(
        stt: stt,
        name: nameVal,
        brand: brandVal,
        quyCach: quyCachVal,
        quantity: qty,
      ));
    }

    return items;
  }
}
