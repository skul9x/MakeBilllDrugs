# Drugs Maker — Trình quản lý Hóa đơn thuốc Cao cấp (Flutter Desktop)

Chào mừng bạn đến với **Drugs Maker**, ứng dụng desktop đa nền tảng (hỗ trợ Linux và Windows) được phát triển bằng Dart và Flutter. Đây là bản viết lại nâng cấp từ ứng dụng `Make-Bill` chạy trên Wails, mang lại giao diện Glassmorphism thời thượng, hiệu năng vượt trội và quy trình phân tích dữ liệu hiệu quả.

---

## 🌟 Tính năng chính

- **Trích xuất thông tin thuốc tự động (Smart Scraping):**
  - Tự động cào thông tin thuốc từ URL trực tuyến (ví dụ: các trang nhà thuốc như Trung Tâm Thuốc, Nhà Thuốc Ngọc Anh,...) hoặc phân tích các bản sao HTML lưu trữ cục bộ.
  - Phân tích cú pháp DOM thông minh để trích xuất: **Tên thuốc** (Name), **Quy cách đóng gói** (Packaging Specification), và **Thương hiệu** (Brand).
  - Cơ chế dự phòng thông minh (regex fallback) khi cấu trúc DOM thay đổi.
- **Nhập thuốc thủ công (Manual Input):**
  - Nhập trực tiếp các thông tin thuốc gồm **Tên thuốc**, **Thương hiệu** và **Quy cách** ngay trên giao diện mà không cần thông qua liên kết URL.
  - Hệ thống kiểm tra và loại bỏ trùng lặp (deduplication) thông minh: Nếu thuốc đã tồn tại trong danh sách (so sánh không phân biệt hoa thường đối với cả 3 trường thông tin), số lượng thuốc sẽ tự động được cộng dồn thay vì tạo dòng mới.
- **Giao diện Glassmorphism cao cấp:** Giao diện tối hiện đại, sử dụng hiệu ứng Backdrop Filter tạo độ mờ gương sang trọng, kết hợp phông chữ *Outfit* và *Inter* tinh tế.
- **Bảng dữ liệu tương tác thời gian thực (Reactive Live Table):**
  - Quản lý danh sách thuốc trực quan. Tự động tính toán lại chỉ số STT và tổng hợp số liệu (Tổng số dòng, Tổng số lượng sản phẩm).
  - Tích hợp phím tắt: Sử dụng phím mũi tên `ArrowUp` / `ArrowDown` để điều hướng nhanh giữa các dòng.
  - Bộ điều chỉnh số lượng ([quantity_selector.dart](lib/views/widgets/quantity_selector.dart)) tích hợp trực tiếp trên bảng.
  - Hệ thống thông báo toast overlay sinh động cho mọi trạng thái (Thành công, Cảnh báo, Lỗi).
- **Xuất nhập Excel chuẩn doanh nghiệp:**
  - Xuất dữ liệu ra file `.xlsx` với tiêu đề màu Slate-gray (`#E2E8F0`), font chữ Inter 11pt Bold, kẻ viền (borders) rõ ràng và căn chỉnh cột tối ưu.
  - Tự động căn chỉnh độ rộng cột dựa trên độ dài nội dung (tối ưu hóa ký tự Unicode/Tiếng Việt).
  - Hỗ trợ nhập (Import) từ file Excel để khôi phục trạng thái làm việc (tương thích mẫu 5 cột tiêu chuẩn hoặc 4 cột cũ).
- **Kiểm thử E2E & Đóng gói:**
  - Bộ kiểm thử tích hợp (Integration Tests) bằng Dart và kịch bản kiểm tra chất lượng Excel bằng Python (`openpyxl`).
  - Kịch bản tự động đóng gói Linux Debian (`.deb`) và Windows Installer (`.exe`).

---

## 📁 Cấu trúc Thư mục Dự án

Hệ thống mã nguồn được tổ chức khoa học theo mô hình kiến trúc Flutter sạch sẽ:

- 📂 **[lib/](lib)**: Mã nguồn Dart chính của ứng dụng.
  - 📂 **[core/](lib/core)**: Chứa cấu hình chủ đề giao diện ứng dụng.
    - [theme.dart](lib/core/theme.dart): Định nghĩa bảng màu Glassmorphism (`GlassTheme`), font chữ Google Fonts và hiệu ứng Blur.
  - 📂 **[models/](lib/models)**: Chứa định nghĩa các thực thể dữ liệu.
    - [drug_info.dart](lib/models/drug_info.dart): Đại diện thông tin thuốc thô cào được (`DrugInfo`).
    - [drug_item.dart](lib/models/drug_item.dart): Thực thể quản lý dòng trong hóa đơn thuốc gồm STT và Số lượng (`DrugItem`).
  - 📂 **[services/](lib/services)**: Chức năng xử lý logic nghiệp vụ.
    - [drug_parser.dart](lib/services/drug_parser.dart): Thực hiện tải trang HTTP, phân tích DOM để trích xuất Tên, Quy cách, Thương hiệu của thuốc.
    - [excel_service.dart](lib/services/excel_service.dart): Xử lý xuất Excel định dạng cao cấp và nhập Excel phục hồi dữ liệu.
    - [dialog_service.dart](lib/services/dialog_service.dart): Giao diện gọi hộp thoại chọn file hệ thống.
    - [dialog_service_impl.dart](lib/services/dialog_service_impl.dart): Triển khai thực tế giao diện hộp thoại với `file_picker`.
    - [mock_dialog_service.dart](lib/services/mock_dialog_service.dart): Phiên bản mock hỗ trợ chạy kiểm thử tự động.
  - 📂 **[views/](lib/views)**: Giao diện người dùng.
    - [dashboard_page.dart](lib/views/dashboard_page.dart): Màn hình điều khiển chính hỗ trợ chuyển đổi linh hoạt hai chế độ nhập: Smart Import & Manual Input.
    - 📂 **[widgets/](lib/views/widgets)**: Các thành phần giao diện nhỏ tái sử dụng.
      - [glass_card.dart](lib/views/widgets/glass_card.dart): Khung hiển thị hiệu ứng gương mờ.
      - [quantity_selector.dart](lib/views/widgets/quantity_selector.dart): Bộ tăng giảm số lượng sản phẩm.
      - [toast_overlay.dart](lib/views/widgets/toast_overlay.dart): Hiển thị thông báo trạng thái dạng overlay nổi.
  - [main.dart](lib/main.dart): Điểm chạy chính của ứng dụng.
- 📂 **[test/](test)**: Thư mục kiểm thử của Flutter (Dart).
  - [core_logic_test.dart](test/core_logic_test.dart): Kiểm thử parser phân tích HTML cục bộ.
  - [dialog_service_test.dart](test/dialog_service_test.dart): Kiểm thử các hành vi hộp thoại file.
  - [ui_widget_test.dart](test/ui_widget_test.dart): Kiểm thử giao diện và hành động bấm nút.
  - [e2e_excel_generation_test.dart](test/e2e_excel_generation_test.dart): Sinh file Excel thử nghiệm (`test_output.xlsx`) phục vụ kiểm tra E2E.
  - [manual_input_unit_test.dart](test/manual_input_unit_test.dart): Unit tests xác minh logic ràng buộc dữ liệu thủ công.
  - [manual_input_ui_test.dart](test/manual_input_ui_test.dart): Widget tests kiểm tra chuyển đổi thẻ và thêm thủ công trên Dashboard.
  - [manual_input_excel_test.dart](test/manual_input_excel_test.dart): Integration tests xuất nhập Excel cho các mục thêm thủ công.
- 📂 **[tests/](tests)**: Các kịch bản kiểm thử tự động bằng Python.
  - [verify_app.py](tests/verify_app.py): Sử dụng `openpyxl` để xác minh cấu trúc dòng, cột, font chữ và màu sắc của file Excel được xuất ra.
  - Kịch bản kiểm chứng theo giai đoạn: `test-phase-01.py` đến `test-phase-05.py`.
  - Kịch bản kiểm chứng nhập thủ công: `test-manual-input-phase-01.py` đến `test-manual-input-phase-03.py`.
- ⚙️ **[pubspec.yaml](pubspec.yaml)**: File cấu hình các thư viện phụ thuộc của Flutter.
- 📄 **[build-deb.sh](build-deb.sh)**: Script bash hỗ trợ biên dịch và đóng gói ứng dụng thành file cài đặt `.deb` chạy trên Linux.
- 📄 **[bump_version.sh](bump_version.sh)**: Script bash hỗ trợ tự động tăng phiên bản và push tag lên GitHub.
- 📄 **[installer.nsi](installer.nsi)**: Cấu hình kịch bản tạo file cài đặt Windows Installer (`.exe`) bằng NSIS.

---

## 🛠️ Công nghệ Sử dụng

Các thư viện chính cấu thành nên dự án (được khai báo tại [pubspec.yaml](pubspec.yaml)):

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

### Chạy kiểm thử End-to-End cho phần Nhập thủ công (Python):
Bộ kiểm thử sẽ biên dịch bản Release, chạy đóng gói `.deb`, kích hoạt kiểm thử tích hợp Excel và xác thực cấu trúc & giao diện của file Excel đầu ra:
```bash
python3 tests/test-manual-input-phase-03.py
```
Nếu tất cả kiểm tra hợp lệ, bạn sẽ nhận được thông báo:
`[SUCCESS] ALL PHASE 03 E2E VERIFICATION AND PACKAGING CHECKS PASSED!`

---

## 🤖 Quy trình CI/CD & Đóng gói Tự động (GitHub Actions)

Dự án tích hợp hệ thống CI/CD thông qua GitHub Actions giúp tự động hóa quá trình đóng gói và phát hành ứng dụng (Windows & Linux).

### Cơ chế hoạt động của CI/CD:
1. **Auto Version Bump:** Khi lập trình viên push thay đổi lên nhánh `main`, workflow [.github/workflows/auto-version.yml](.github/workflows/auto-version.yml) sẽ tự động tính toán số phiên bản mới, cập nhật `pubspec.yaml`, thực hiện commit và tạo tag (ví dụ: `v1.3`) rồi push ngược lên GitHub.
2. **Build & Release:** Sự kiện push tag mới sẽ kích hoạt workflow [.github/workflows/release.yml](.github/workflows/release.yml).
   - **Job Windows:** Chạy trên môi trường `windows-latest`, build ứng dụng và sử dụng NSIS để đóng gói thành tệp cài đặt `.exe`.
   - **Job Linux:** Chạy trên môi trường `ubuntu-latest`, tối ưu hóa bỏ qua bước build trùng lặp bằng cờ `SKIP_BUILD` và gọi [build-deb.sh](build-deb.sh) để đóng gói thành tệp `.deb`.
   - **Job Release:** Tải các file cài đặt từ hai job trên, sử dụng cơ chế Glob Pattern động để nhận dạng chính xác tên file và đính kèm trực tiếp vào mục **GitHub Release**.

### Công cụ Bump Version thủ công:
Bạn có thể tự tăng phiên bản và kích hoạt phát hành bản release ngay tại máy cục bộ bằng script `bump_version.sh`:
```bash
# Tăng số minor (ví dụ từ 1.2 lên 1.3)
./bump_version.sh minor

# Tăng số patch (ví dụ từ 1.2.0 lên 1.2.1)
./bump_version.sh patch

# Tăng số major (ví dụ từ 1.2 lên 2.0)
./bump_version.sh major
```
Script sẽ tự động commit phiên bản mới, tạo tag và hỏi bạn có muốn push thẳng lên GitHub để kích hoạt CI/CD hay không.

---

## 👨‍💻 Hướng dẫn Sử dụng Ứng dụng

1. **Nhập nguồn thuốc:** 
   - **Smart Import:** Nhập đường dẫn link URL trực tiếp của thuốc hoặc nhập đường dẫn file HTML cục bộ trong ô *Add Drug Source*, chọn số lượng rồi nhấn **Fetch & Add**.
   - **Manual Input:** Chuyển qua thẻ *Manual Input*, nhập các thông tin thuốc thủ công gồm **Tên thuốc**, **Thương hiệu** và **Quy cách**, chọn số lượng rồi nhấn **Add Manually**.
2. **Quản lý danh sách:** 
   - Danh sách thuốc sẽ xuất hiện trên bảng bên phải.
   - Bạn có thể chỉnh sửa trực tiếp số lượng bằng cách bấm nút tăng/giảm ở cột *Số lượng*.
   - Nhấn nút `X` (đỏ) ở cuối dòng để xóa thuốc.
   - Sử dụng phím **Mũi tên Lên / Xuống** trên bàn phím để chọn dòng.
3. **Xuất Excel:** Bấm nút **Export Excel**, chọn vị trí lưu file `.xlsx`. Mở file để xem bảng dữ liệu đã được định dạng chuẩn doanh nghiệp.
4. **Nhập dữ liệu cũ:** Bấm nút **Import Excel**, chọn file Excel đã xuất trước đó để khôi phục nhanh trạng thái danh sách trên bảng điều khiển.

---

**Copyright © Nguyễn Duy Trường 2026**
