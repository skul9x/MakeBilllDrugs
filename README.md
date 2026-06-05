# Drugs Maker — Trình quản lý Hóa đơn thuốc Cao cấp (Flutter Desktop)

Chào mừng bạn đến với **Drugs Maker**, ứng dụng desktop đa nền tảng (hỗ trợ Linux và Windows) được phát triển bằng Dart và Flutter. Đây là bản viết lại nâng cấp từ ứng dụng `Make-Bill` chạy trên Wails, mang lại giao diện Glassmorphism thời thượng, hiệu năng vượt trội và quy trình phân tích dữ liệu hiệu quả.

---

## 🌟 Tính năng chính

- **Trích xuất thông tin thuốc tự động (Smart Scraping):**
  - Tự động cào thông tin thuốc từ URL trực tuyến (ví dụ: các trang nhà thuốc như Trung Tâm Thuốc, Nhà Thuốc Ngọc Anh,...) hoặc phân tích các bản sao HTML lưu trữ cục bộ.
  - Phân tích cú pháp DOM thông minh để trích xuất: **Tên thuốc** (Name), **Quy cách đóng gói** (Packaging Specification), và **Thương hiệu** (Brand).
  - Cơ chế dự phòng thông minh (regex fallback) khi cấu trúc DOM thay đổi.
- **Giao diện Glassmorphism cao cấp:** Giao diện tối hiện đại, sử dụng hiệu ứng Backdrop Filter tạo độ mờ gương sang trọng, kết hợp phông chữ *Outfit* và *Inter* tinh tế.
- **Bảng dữ liệu tương tác thời gian thực (Reactive Live Table):**
  - Quản lý danh sách thuốc trực quan. Tự động tính toán lại chỉ số STT và tổng hợp số liệu (Tổng số dòng, Tổng số lượng sản phẩm).
  - Tích hợp phím tắt: Sử dụng phím mũi tên `ArrowUp` / `ArrowDown` để điều hướng nhanh giữa các dòng.
  - Bộ điều chỉnh số lượng ([QuantitySelector](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/widgets/quantity_selector.dart)) tích hợp trực tiếp trên bảng.
  - Hệ thống thông báo toast overlay sinh động cho mọi trạng thái (Thành công, Cảnh báo, Lỗi).
- **Xuất nhập Excel chuẩn doanh nghiệp:**
  - Xuất dữ liệu ra file `.xlsx` với tiêu đề màu Slate-gray (`#E2E8F0`), font chữ Inter 11pt Bold, kẻ viền (borders) rõ ràng và căn chỉnh cột tối ưu.
  - Tự động căn chỉnh độ rộng cột dựa trên độ dài nội dung (tối ưu hóa ký tự Unicode/Tiếng Việt).
  - Hỗ trợ nhập (Import) từ file Excel cũ để khôi phục trạng thái làm việc (tương thích mẫu 5 cột tiêu chuẩn hoặc 4 cột cũ).
- **Kiểm thử E2E & Đóng gói:**
  - Bộ kiểm thử tích hợp (Integration Tests) bằng Dart và kịch bản kiểm tra chất lượng Excel bằng Python (`openpyxl`).
  - Kịch bản tự động đóng gói Linux Debian (`.deb`).

---

## 📁 Cấu trúc Thư mục Dự án

Hệ thống mã nguồn được tổ chức khoa học theo mô hình kiến trúc Flutter sạch sẽ:

- 📂 **[lib/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib)**: Mã nguồn Dart chính của ứng dụng.
  - 📂 **[core/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/core)**: Chứa cấu hình chủ đề giao diện ứng dụng.
    - [theme.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/core/theme.dart): Định nghĩa bảng màu Glassmorphism ([GlassTheme](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/core/theme.dart)), font chữ Google Fonts và hiệu ứng Blur.
  - 📂 **[models/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/models)**: Chứa định nghĩa các thực thể dữ liệu.
    - [drug_info.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/models/drug_info.dart): Đại diện thông tin thuốc thô cào được ([DrugInfo](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/models/drug_info.dart)).
    - [drug_item.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/models/drug_item.dart): Thực thể quản lý dòng trong hóa đơn thuốc gồm STT và Số lượng ([DrugItem](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/models/drug_item.dart)).
  - 📂 **[services/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/services)**: Chức năng xử lý logic nghiệp vụ.
    - [drug_parser.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/services/drug_parser.dart): Thực hiện tải trang HTTP, phân tích DOM để trích xuất Tên, Quy cách, Thương hiệu của thuốc.
    - [excel_service.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/services/excel_service.dart): Xử lý xuất Excel định dạng cao cấp và nhập Excel phục hồi dữ liệu.
    - [dialog_service.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/services/dialog_service.dart): Giao diện gọi hộp thoại chọn file hệ thống.
    - [dialog_service_impl.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/services/dialog_service_impl.dart): Triển khai thực tế giao diện hộp thoại với `file_picker`.
    - [mock_dialog_service.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/services/mock_dialog_service.dart): Phiên bản mock hỗ trợ chạy kiểm thử tự động.
  - 📂 **[views/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views)**: Giao diện người dùng.
    - [dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/dashboard_page.dart): Màn hình điều khiển chính với bố cục Grid, bảng hiển thị dữ liệu và vùng nhập liệu.
    - 📂 **[widgets/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/widgets)**: Các thành phần giao diện nhỏ tái sử dụng.
      - [glass_card.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/widgets/glass_card.dart): Khung hiển thị hiệu ứng gương mờ.
      - [quantity_selector.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/widgets/quantity_selector.dart): Bộ tăng giảm số lượng sản phẩm.
      - [toast_overlay.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/widgets/toast_overlay.dart): Hiển thị thông báo trạng thái dạng overlay nổi.
  - [main.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/main.dart): Điểm chạy chính của ứng dụng.
- 📂 **[test/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test)**: Thư mục kiểm thử của Flutter (Dart).
  - [core_logic_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/core_logic_test.dart): Kiểm thử parser phân tích HTML cục bộ.
  - [dialog_service_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/dialog_service_test.dart): Kiểm thử các hành vi hộp thoại file.
  - [ui_widget_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/ui_widget_test.dart): Kiểm thử giao diện và hành động bấm nút.
  - [e2e_excel_generation_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/e2e_excel_generation_test.dart): Sinh file Excel thử nghiệm (`test_output.xlsx`) phục vụ kiểm tra E2E.
- 📂 **[tests/](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests)**: Các kịch bản kiểm thử tự động bằng Python.
  - [verify_app.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/verify_app.py): Sử dụng `openpyxl` để xác minh trực tiếp cấu trúc dòng, cột, font chữ và màu sắc của file Excel được xuất ra.
  - Kịch bản kiểm chứng theo giai đoạn: [test-phase-01.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/test-phase-01.py) đến [test-phase-05.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/test-phase-05.py).
- ⚙️ **[pubspec.yaml](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/pubspec.yaml)**: File cấu hình các thư viện phụ thuộc của Flutter.
- 📄 **[build-deb.sh](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/build-deb.sh)**: Script bash hỗ trợ biên dịch và đóng gói ứng dụng thành file cài đặt `.deb` chạy trên Linux.

---

## 🛠️ Công nghệ Sử dụng

Các thư viện chính cấu thành nên dự án (được khai báo tại [pubspec.yaml](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/pubspec.yaml)):

- **[http](https://pub.dev/packages/http):** Gửi yêu cầu HTTP kèm User-Agent giả lập trình duyệt để cào dữ liệu HTML.
- **[html](https://pub.dev/packages/html):** Hỗ trợ duyệt qua cây DOM thông qua bộ chọn CSS selectors.
- **[excel](https://pub.dev/packages/excel):** Tạo lập, định dạng nâng cao và đọc nội dung file bảng tính Excel `.xlsx`.
- **[file_picker](https://pub.dev/packages/file_picker):** Kích hoạt hộp thoại mở/lưu file nguyên bản của hệ điều hành.
- **[google_fonts](https://pub.dev/packages/google_fonts):** Tải và áp dụng phông chữ cao cấp (Outfit & Inter).
- **[flutter_spinkit](https://pub.dev/packages/flutter_spinkit):** Cung cấp các biểu tượng loading sinh động đẹp mắt.

---

## 🚀 Hướng dẫn Cài đặt & Khởi chạy

### 1. Chuẩn bị Môi trường
* Máy tính đã cài đặt **Flutter SDK** (khuyên dùng phiên bản có Dart 3.x).
* Phục vụ kiểm thử E2E: Cài đặt **Python 3** và thư viện `openpyxl` để xác minh Excel:
  ```bash
  pip install openpyxl
  ```

### 2. Tải phụ thuộc Flutter
Di chuyển vào thư mục dự án và chạy lệnh:
```bash
flutter pub get
```

### 3. Chạy ứng dụng ở chế độ Phát triển (Development)
Đảm bảo bạn đã kích hoạt hỗ trợ desktop trên hệ điều hành tương ứng:
- **Linux:**
  ```bash
  flutter run -d linux
  ```
- **Windows:**
  ```bash
  flutter run -d windows
  ```

---

## 🧪 Kiểm thử và Xác minh Chất lượng

Dự án đi kèm bộ script tự động hóa toàn diện giúp xác minh chất lượng sản phẩm qua từng giai đoạn phát triển:

### Chạy các bài kiểm thử Unit / Widget (Dart):
```bash
flutter test
```

### Chạy kiểm thử End-to-End toàn diện (Python):
Bộ kiểm thử sẽ biên dịch bản Release, chạy đóng gói `.deb` và xác thực cấu trúc & giao diện của file Excel đầu ra:
```bash
python3 tests/test-phase-05.py
```
Nếu tất cả kiểm tra hợp lệ, bạn sẽ nhận được thông báo:
`[SUCCESS] ALL PHASE 05 E2E VERIFICATION AND PACKAGING CHECKS PASSED!`

---

## 📦 Biên dịch và Đóng gói Release

### Trên Linux (Đóng gói `.deb`)
Chúng tôi cung cấp script tự động biên dịch và gom gói file cài đặt Debian chỉ bằng một lệnh:
```bash
chmod +x build-deb.sh
./build-deb.sh
```
Kết quả đầu ra sẽ tạo ra file **`drugs-maker-flutter_1.0.0_amd64.deb`** ngay tại thư mục gốc của dự án. File này chứa:
- Binary đã tối ưu hóa biên dịch đặt tại `/opt/drugs-maker-flutter/`.
- File shortcut menu ứng dụng (`.desktop`) cài đặt tại `/usr/share/applications/`.
- Lệnh chạy tiện lợi từ terminal qua `drugs-maker-flutter`.

### Trên Windows
Chạy lệnh biên dịch mặc định của Flutter:
```bash
flutter build windows --release
```
Sản phẩm biên dịch nằm tại thư mục `build/windows/x64/release/bundle/`. Hãy đóng gói toàn bộ thư mục này dưới dạng file `.zip` để chia sẻ di động.

---

## 👨‍💻 Hướng dẫn Sử dụng Ứng dụng

1. **Nhập nguồn thuốc:** Nhập đường dẫn link URL trực tiếp của thuốc hoặc nhập đường dẫn file HTML cục bộ trong ô *Add Drug Source*.
2. **Chọn số lượng:** Sử dụng bộ chọn số lượng bên dưới và bấm nút **Fetch & Add**.
3. **Quản lý danh sách:** 
   - Danh sách thuốc sẽ xuất hiện trên bảng bên phải.
   - Bạn có thể chỉnh sửa trực tiếp số lượng bằng cách bấm nút tăng/giảm ở cột *Số lượng*.
   - Nhấn nút `X` (đỏ) ở cuối dòng để xóa thuốc.
   - Sử dụng phím **Mũi tên Lên / Xuống** trên bàn phím để chọn dòng.
4. **Xuất Excel:** Bấm nút **Export Excel**, chọn vị trí lưu file `.xlsx`. Mở file để xem bảng dữ liệu đã được định dạng chuẩn doanh nghiệp.
5. **Nhập dữ liệu cũ:** Bấm nút **Import Excel**, chọn file Excel đã xuất trước đó để khôi phục nhanh trạng thái danh sách trên bảng điều khiển.

---
*Phát triển bởi đội ngũ và cộng đồng Drugs Maker.*
