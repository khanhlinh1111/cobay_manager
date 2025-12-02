#!/bin/bash

# Màu sắc cho giao diện đẹp hơn
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== BẮT ĐẦU CÀI ĐẶT DỰ ÁN COBAY_MANAGER ===${NC}"

# 1. Kiểm tra Flutter đã cài chưa
if ! command -v flutter &> /dev/null
then
    echo -e "${RED}[LỖI] Không tìm thấy lệnh 'flutter'.${NC}"
    echo "Vui lòng cài đặt Flutter SDK trước: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo -e "${GREEN}[1/3] Đang tải các thư viện (Flutter Pub Get)...${NC}"
flutter pub get

echo -e "${GREEN}[2/3] Đang sinh code tự động cho Isar & Riverpod (Build Runner)...${NC}"
echo "Bước này có thể mất vài phút, vui lòng chờ..."
flutter pub run build_runner build --delete-conflicting-outputs

echo -e "${GREEN}[3/3] Kiểm tra môi trường...${NC}"
flutter doctor -v

echo -e "${GREEN}=== CÀI ĐẶT HOÀN TẤT! ===${NC}"
echo "Bạn có thể chạy ứng dụng bằng lệnh: flutter run"
