import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_info.dart';
import 'package:drugs_maker/models/drug_item.dart';
import 'package:drugs_maker/services/drug_parser.dart';
import 'package:drugs_maker/services/excel_service.dart';

void main() {
  group('Long Chau Integration Tests', () {
    final parser = DrugParser();
    final excelService = ExcelService();
    final outputPath = 'test/long_chau_test_out.xlsx';

    setUp(() {
      // Clean up previous output if any
      final file = File(outputPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('Parses Long Chau mock files, aggregates with deduplication, and exports to Excel', () async {
      final items = <DrugItem>[];

      // Helper to simulate UI adding behavior with deduplication
      void addOrUpdateItem(DrugInfo info, int quantity) {
        final existingIdx = DrugItem.findDuplicateIndex(
          items,
          name: info.name,
          brand: info.brand,
          quyCach: info.quyCach,
        );

        if (existingIdx != -1) {
          final existing = items[existingIdx];
          items[existingIdx] = DrugItem(
            stt: existing.stt,
            name: existing.name,
            brand: existing.brand,
            quyCach: existing.quyCach,
            quantity: existing.quantity + quantity,
          );
        } else {
          items.add(
            DrugItem(
              stt: items.length + 1,
              name: info.name,
              brand: info.brand,
              quyCach: info.quyCach,
              quantity: quantity,
            ),
          );
        }
      }

      // 1. Fetch & Parse mock file 1 (123.html)
      final info1 = await parser.fetchAndParse('LongChau/123.html');
      addOrUpdateItem(info1, 2);

      // 2. Fetch & Parse mock file 2 (456-aug.html)
      final info2 = await parser.fetchAndParse('LongChau/456-aug.html');
      addOrUpdateItem(info2, 1);

      // 3. Fetch & Parse mock file 3 (Hapacol 150)
      final info3 = await parser.fetchAndParse('LongChau/Bột sủi Hapacol 150 vị cam hạ sốt, giảm đau cho trẻ (24 gói).html');
      addOrUpdateItem(info3, 3);

      // Verify initial collection size is 3
      expect(items.length, equals(3));
      expect(items[0].stt, equals(1));
      expect(items[0].name, contains('Paracetamol Stada'));
      expect(items[0].quantity, equals(2));

      expect(items[1].stt, equals(2));
      expect(items[1].name, contains('Augmentin 1g'));
      expect(items[1].quantity, equals(1));

      expect(items[2].stt, equals(3));
      expect(items[2].name, contains('Bột Hapacol 150'));
      expect(items[2].quantity, equals(3));

      // 4. Add duplicate of item 1 (123.html) to test deduplication
      final dupInfo = await parser.fetchAndParse('LongChau/123.html');
      addOrUpdateItem(dupInfo, 5);

      // Verify length is still 3 (deduplicated)
      expect(items.length, equals(3));
      expect(items[0].stt, equals(1));
      expect(items[0].quantity, equals(7)); // 2 + 5

      // 5. Generate Excel
      await excelService.generateExcel(items, outputPath);
      expect(File(outputPath).existsSync(), isTrue);

      // 6. Import back to verify E2E roundtrip (sorted A-Z)
      final imported = await excelService.importExcel(outputPath);
      expect(imported.length, equals(3));

      // Items sorted A-Z:
      // 1. Bột Hapacol 150 ...
      // 2. Thuốc Augmentin 1g ...
      // 3. Viên nén Paracetamol Stada ...
      expect(imported[0].stt, equals(1));
      expect(imported[0].name, contains('Bột Hapacol 150'));
      expect(imported[0].brand, equals(items[2].brand));
      expect(imported[0].quyCach, equals(items[2].quyCach));
      expect(imported[0].quantity, equals(3));

      expect(imported[1].stt, equals(2));
      expect(imported[1].name, contains('Augmentin 1g'));
      expect(imported[1].brand, equals(items[1].brand));
      expect(imported[1].quyCach, equals(items[1].quyCach));
      expect(imported[1].quantity, equals(1));

      expect(imported[2].stt, equals(3));
      expect(imported[2].name, contains('Paracetamol Stada'));
      expect(imported[2].brand, equals(items[0].brand));
      expect(imported[2].quyCach, equals(items[0].quyCach));
      expect(imported[2].quantity, equals(7));
    });
  });
}
