import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_item.dart';
import 'package:drugs_maker/services/excel_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DrugItem Sorting & Vietnamese Collation Tests', () {
    test('compareByName orders drugs alphabetically with Vietnamese diacritics', () {
      final items = [
        DrugItem(stt: 1, name: 'Decolgen', brand: 'United Pharma', quyCach: 'Vỉ', quantity: 1),
        DrugItem(stt: 2, name: 'Amoxicillin', brand: 'Imexpharm', quyCach: 'Lọ', quantity: 1),
        DrugItem(stt: 3, name: 'Đông Trùng Hạ Thảo', brand: 'Dược Kim Cương', quyCach: 'Hộp', quantity: 1),
        DrugItem(stt: 4, name: 'Áo Giáp', brand: 'Pharma', quyCach: 'Gói', quantity: 1),
        DrugItem(stt: 5, name: 'Bổ Phế', brand: 'Nam Hà', quyCach: 'Chai', quantity: 1),
        DrugItem(stt: 6, name: 'Cephalexin', brand: 'Hậu Giang', quyCach: 'Hộp', quantity: 1),
      ];

      final sorted = DrugItem.sortAndReindex(items);

      expect(sorted.length, 6);
      expect(sorted[0].name, 'Amoxicillin');
      expect(sorted[0].stt, 1);

      expect(sorted[1].name, 'Áo Giáp');
      expect(sorted[1].stt, 2);

      expect(sorted[2].name, 'Bổ Phế');
      expect(sorted[2].stt, 3);

      expect(sorted[3].name, 'Cephalexin');
      expect(sorted[3].stt, 4);

      expect(sorted[4].name, 'Decolgen');
      expect(sorted[4].stt, 5);

      expect(sorted[5].name, 'Đông Trùng Hạ Thảo');
      expect(sorted[5].stt, 6);
    });

    test('compareByName resolves ties using brand and quy cách', () {
      final items = [
        DrugItem(stt: 1, name: 'Paracetamol', brand: 'Pharmedic', quyCach: 'Hộp 500 viên', quantity: 1),
        DrugItem(stt: 2, name: 'Paracetamol', brand: 'DHG Pharma', quyCach: 'Hộp 100 viên', quantity: 1),
        DrugItem(stt: 3, name: 'Paracetamol', brand: 'DHG Pharma', quyCach: 'Hộp 50 viên', quantity: 1),
      ];

      final sorted = DrugItem.sortAndReindex(items);

      expect(sorted[0].brand, 'DHG Pharma');
      expect(sorted[0].quyCach, 'Hộp 100 viên');
      expect(sorted[0].stt, 1);

      expect(sorted[1].brand, 'DHG Pharma');
      expect(sorted[1].quyCach, 'Hộp 50 viên');
      expect(sorted[1].stt, 2);

      expect(sorted[2].brand, 'Pharmedic');
      expect(sorted[2].stt, 3);
    });

    test('ExcelService.generateExcel sorts items before writing to disk', () async {
      final excelService = ExcelService();
      final tempPath = '${Directory.systemTemp.path}/test_sorting_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      final unsortedItems = [
        DrugItem(stt: 99, name: 'Zinc 15mg', brand: 'Brave', quyCach: 'Hộp', quantity: 10),
        DrugItem(stt: 88, name: 'Alpha Choay', brand: 'Sanofi', quyCach: 'Hộp', quantity: 2),
        DrugItem(stt: 77, name: 'Bổ Gan', brand: 'Boganic', quyCach: 'Chai', quantity: 5),
      ];

      await excelService.generateExcel(unsortedItems, tempPath);

      final imported = await excelService.importExcel(tempPath);
      expect(imported.length, 3);

      expect(imported[0].name, 'Alpha Choay');
      expect(imported[0].stt, 1);

      expect(imported[1].name, 'Bổ Gan');
      expect(imported[1].stt, 2);

      expect(imported[2].name, 'Zinc 15mg');
      expect(imported[2].stt, 3);

      final file = File(tempPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}
