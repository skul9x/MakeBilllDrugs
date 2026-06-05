import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_item.dart';
import 'package:drugs_maker/services/drug_parser.dart';
import 'package:drugs_maker/services/excel_service.dart';

void main() {
  test('E2E Excel Generation integration test', () async {
    // 1. Create a local mock HTML file
    final mockHtmlContent = '''
<html>
  <body>
    <h1>Izac Syrup</h1>
    <div id="cs-thuong-hieu">
      <table>
        <tr>
          <td>Thương hiệu</td>
          <td>Dược phẩm An Thiên (A.T PHARMA CORP)</td>
        </tr>
      </table>
    </div>
    <p>Quy cách đóng gói: Chai 60ml</p>
  </body>
</html>
''';

    final mockFile = File('test/mock_drug.html');
    await mockFile.writeAsString(mockHtmlContent);

    // 2. Parse the local mock HTML file using DrugParser
    final parser = DrugParser();
    final info = await parser.fetchAndParse('file://${mockFile.absolute.path}');

    // 3. Create a DrugItem using parsed info
    final item = DrugItem(
      stt: 1,
      name: info.name,
      brand: info.brand,
      quyCach: info.quyCach,
      quantity: 3,
    );

    // 4. Generate the Excel file at the project root
    final excelService = ExcelService();
    final outputPath = 'test_output.xlsx';

    // Delete existing output if any
    final outputFile = File(outputPath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    await excelService.generateExcel([item], outputPath);

    // 5. Assert that the file is created successfully
    expect(await outputFile.exists(), isTrue);

    // Clean up mock HTML file
    if (await mockFile.exists()) {
      await mockFile.delete();
    }
  });
}
