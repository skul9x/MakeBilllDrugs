import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:excel/excel.dart';
import 'package:drugs_maker/models/drug_item.dart';
import 'package:drugs_maker/services/excel_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExcelService Formatting Tests', () {
    late ExcelService excelService;
    late String tempPath;

    setUp(() {
      excelService = ExcelService();
      tempPath = '${Directory.systemTemp.path}/test_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    });

    tearDown(() {
      final file = File(tempPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('generateExcel creates file with Times New Roman 12pt and correct row/column sizing', () async {
      final testItems = [
        DrugItem(
          stt: 1,
          name: 'Paracetamol 500mg Dược Hậu Giang',
          brand: 'DHG Pharma',
          quyCach: 'Hộp 10 vỉ x 10 viên',
          quantity: 20,
        ),
        DrugItem(
          stt: 2,
          name: 'Amoxicillin 500mg Kháng Sinh',
          brand: 'Imexpharm',
          quyCach: 'Lọ 100 viên',
          quantity: 5,
        ),
      ];

      await excelService.generateExcel(testItems, tempPath);

      final file = File(tempPath);
      expect(file.existsSync(), isTrue);

      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      expect(excel.tables.containsKey('Sheet1'), isTrue);

      final sheet = excel.tables['Sheet1']!;

      // Verify row count (header + 2 items)
      expect(sheet.maxRows, 3);
      expect(sheet.maxColumns, 5);

      // Verify headers
      final headers = ['STT', 'Tên thuốc', 'Thương hiệu', 'Quy cách', 'Số lượng'];
      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        expect((cell.value as TextCellValue).value.text, equals(headers[i]));
      }

      // Verify STT and Quantity values (sorted A-Z: Amoxicillin comes before Paracetamol)
      final cellSTT1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1));
      expect((cellSTT1.value as IntCellValue).value, equals(1));

      final cellName1 = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1));
      expect((cellName1.value as TextCellValue).value.text, equals('Amoxicillin 500mg Kháng Sinh'));

      // Test importing back
      final importedItems = await excelService.importExcel(tempPath);
      expect(importedItems.length, 2);
      expect(importedItems[0].name, 'Amoxicillin 500mg Kháng Sinh');
      expect(importedItems[0].brand, 'Imexpharm');
      expect(importedItems[0].quantity, 5);
      expect(importedItems[1].name, 'Paracetamol 500mg Dược Hậu Giang');
      expect(importedItems[1].brand, 'DHG Pharma');
      expect(importedItems[1].quantity, 20);
    });
  });
}
