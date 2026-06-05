import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/services/dialog_service.dart';
import 'package:drugs_maker/services/dialog_service_impl.dart';
import 'package:drugs_maker/services/mock_dialog_service.dart';

void main() {
  group('DialogService Interface & Implementation tests', () {
    test('DialogServiceImpl can be instantiated and implements DialogService', () {
      final DialogService service = DialogServiceImpl();
      expect(service, isNotNull);
    });
  });

  group('MockDialogService tests', () {
    test('returns configured import path', () async {
      final mockService = MockDialogService(mockImportPath: '/path/to/import.xlsx');
      final path = await mockService.selectImportPath();
      expect(path, equals('/path/to/import.xlsx'));
    });

    test('returns null when import path is not configured (cancellation)', () async {
      final mockService = MockDialogService();
      final path = await mockService.selectImportPath();
      expect(path, isNull);
    });

    test('returns configured save path', () async {
      final mockService = MockDialogService(mockSavePath: '/path/to/save.xlsx');
      final path = await mockService.selectSavePath();
      expect(path, equals('/path/to/save.xlsx'));
    });

    test('returns null when save path is not configured (cancellation)', () async {
      final mockService = MockDialogService();
      final path = await mockService.selectSavePath();
      expect(path, isNull);
    });
  });
}
