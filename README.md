# 👵 Cô Bảy Quản Lý (CoBayManager)

> Ứng dụng quản lý Salon Tóc & Môi giới Bất động sản dành riêng cho người lớn tuổi (Low-tech users).
>
> **Đặc điểm:** Chữ to, giao diện đơn giản, nhập liệu bằng giọng nói tiếng Việt, hoạt động không cần mạng (Offline-first).

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![CI/CD](https://github.com/USERNAME/cobay_manager/actions/workflows/main.yml/badge.svg)

---

## 🛠️ Yêu cầu hệ thống (Prerequisites)

Trước khi bắt đầu, hãy đảm bảo máy tính của bạn đã cài:

1.  **Flutter SDK** (Phiên bản 3.0 trở lên). [Hướng dẫn cài đặt](https://docs.flutter.dev/get-started/install).
2.  **Git**.

---

## 🚀 Cài đặt nhanh (Quick Start)

Chúng tôi đã chuẩn bị sẵn script cài đặt tự động.

### 👉 Dành cho Linux / macOS
Mở Terminal tại thư mục dự án và chạy:

```bash
./setup.sh
```

### 👉 Dành cho Windows
Click đúp vào file `setup.bat` hoặc chạy trong CMD:

```cmd
setup.bat
```

---

## 📖 Cài đặt thủ công (Manual Setup)

Nếu bạn muốn hiểu rõ quy trình, hãy làm theo các bước sau:

1.  **Tải thư viện (Dependencies):**
    ```bash
    flutter pub get
    ```

2.  **Sinh code tự động (Code Generation):**
    *Quan trọng*: Dự án dùng `Isar` (Database) và `Riverpod` (State Management) nên cần bước này để tạo ra các file `.g.dart`.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **Chạy ứng dụng:**
    ```bash
    flutter run
    ```

---

## 🏗️ Cấu trúc dự án (Project Structure)

Dự án tuân theo kiến trúc **Feature-first** kết hợp **Clean Architecture**:

```text
lib/
├── main.dart                  # Điểm khởi chạy, cấu hình Isar & Riverpod
├── src/
│   ├── app.dart               # Cấu hình App Widget & Theme chữ to
│   ├── common_widgets/        # Các Widget dùng chung (Nút bấm to, Card to...)
│   └── features/              # Các tính năng chính
│       ├── dashboard/         # Màn hình chính
│       ├── salon/             # Quản lý Tiệm tóc (Data, Domain, UI)
│       ├── real_estate/       # Quản lý Bất động sản
│       └── voice/             # Xử lý giọng nói (AI Logic)
```

## 🤖 CI/CD (Tự động hóa)

Dự án này đã tích hợp **GitHub Actions** để:
1.  Tự động kiểm tra code (Lint & Analyze).
2.  Tự động build file cài đặt **Android (.apk)** mỗi khi có code mới được đẩy lên nhánh `main`.
3.  Bạn có thể tải file APK trong phần **Actions** > **Artifacts** trên GitHub.

## 📝 Tài liệu kỹ thuật

*   [Yêu cầu sản phẩm & UX (PRD)](../docs/01_PRD_UX.md)
*   [Kiến trúc hệ thống](../docs/02_Architecture.md)
*   [Logic xử lý giọng nói](../docs/03_Voice_Logic.md)

---
Developed with ❤️ for Cô Bảy.