import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_item.dart';
import 'package:drugs_maker/services/excel_service.dart';

void main() {
  test('Manual Input Excel Generation and Import Cycle Test', () async {
    // 1. Create a list of manually entered drug items
    final manualItems = [
      DrugItem(
        stt: 1,
        name: 'Manual Drug A',
        brand: 'Brand X',
        quyCach: 'Hộp 30 viên',
        quantity: 5,
      ),
      DrugItem(
        stt: 2,
        name: 'Manual Drug B',
        brand: 'N/A',
        quyCach: 'Chai 100ml',
        quantity: 2,
      ),
    ];

    final excelService = ExcelService();
    final outputPath = 'manual_test_output.xlsx';

    // Delete existing output if any
    final outputFile = File(outputPath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    // 2. Export the manual items to Excel
    await excelService.generateExcel(manualItems, outputPath);

    // Assert that the file is created successfully
    expect(await outputFile.exists(), isTrue);

    // 3. Import the generated Excel file back
    final importedItems = await excelService.importExcel(outputPath);

    // 4. Verify that the imported items match the manual items exactly (lossless cycle)
    expect(importedItems.length, equals(manualItems.length));
    for (int i = 0; i < manualItems.length; i++) {
      expect(importedItems[i].stt, equals(manualItems[i].stt));
      expect(importedItems[i].name, equals(manualItems[i].name));
      expect(importedItems[i].brand, equals(manualItems[i].brand));
      expect(importedItems[i].quyCach, equals(manualItems[i].quyCach));
      expect(importedItems[i].quantity, equals(manualItems[i].quantity));
    }
  });
}
