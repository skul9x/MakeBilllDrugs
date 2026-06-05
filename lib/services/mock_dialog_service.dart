import 'dialog_service.dart';

class MockDialogService implements DialogService {
  String? mockImportPath;
  String? mockSavePath;

  MockDialogService({this.mockImportPath, this.mockSavePath});

  @override
  Future<String?> selectImportPath() async {
    return mockImportPath;
  }

  @override
  Future<String?> selectSavePath() async {
    return mockSavePath;
  }
}
