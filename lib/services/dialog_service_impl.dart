import 'package:file_picker/file_picker.dart';
import 'dialog_service.dart';

class DialogServiceImpl implements DialogService {
  @override
  Future<String?> selectImportPath() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      return result?.files.single.path;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> selectSavePath() async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Drug List',
        fileName: 'Danh_sach_thuoc.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      return result;
    } catch (e) {
      return null;
    }
  }
}
