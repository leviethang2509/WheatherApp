# Flutter Weather App - Le Viet Thang

Ứng dụng thời tiết Flutter sử dụng OpenWeatherMap API để hiển thị thời tiết hiện tại, dự báo theo giờ, dự báo 5 ngày, tìm kiếm thành phố, lưu thành phố yêu thích, cache dữ liệu offline và đổi đơn vị nhiệt độ.

## Tính năng chính

- Hiển thị nhiệt độ, cảm giác như, mô tả thời tiết, icon thời tiết, thành phố và quốc gia.
- Giao diện động theo điều kiện thời tiết: nắng, mưa, nhiều mây, ban đêm.
- Dự báo 24 giờ tới và dự báo 5 ngày.
- Chi tiết thời tiết: độ ẩm, gió, áp suất, tầm nhìn, mây, mặt trời mọc/lặn, nhiệt độ min/max.
- Tìm kiếm thành phố, lịch sử tìm kiếm và tối đa 5 thành phố yêu thích.
- Lấy thời tiết theo vị trí hiện tại.
- Cache dữ liệu gần nhất để hiển thị khi mất mạng hoặc lỗi API.
- Pull-to-refresh, loading state và error state.
- Cài đặt đơn vị Celsius/Fahrenheit.

## Công nghệ sử dụng

- Flutter, Dart, Material 3
- Provider
- OpenWeatherMap API
- http
- geolocator
- shared_preferences
- cached_network_image
- flutter_dotenv
- intl

## Cấu hình API

1. Đăng ký API key miễn phí tại OpenWeatherMap: https://openweathermap.org/api
2. Mở file `.env.example`.
3. Thay `YOUR_API_KEY_HERE` bằng API key thật:

```env
OPENWEATHER_API_KEY=your_actual_api_key_here
```

Không đưa API key thật lên GitHub.

## Cách chạy dự án

```bash
flutter pub get
flutter run
```

## Kiểm thử

```bash
flutter analyze
flutter test
```

## Cấu trúc thư mục

```text
lib/
  config/
  models/
  providers/
  screens/
  services/
  utils/
  widgets/
test/
screenshots/
```

## Screenshots cần bổ sung

Đặt ảnh vào thư mục `screenshots/` rồi chèn vào README hoặc báo cáo theo mẫu:

```md
![Màn hình thời tiết nắng](screenshots/sunny.png)
```

Danh sách ảnh nên có:

- `sunny.png`: thời tiết nắng
- `rainy.png`: thời tiết mưa
- `cloudy.png`: thời tiết nhiều mây
- `night.png`: giao diện ban đêm
- `search.png`: màn hình tìm kiếm
- `forecast.png`: màn hình dự báo
- `error.png`: trạng thái lỗi
- `loading.png`: trạng thái tải dữ liệu

## Hạn chế

- Chưa có bản đồ thời tiết, AQI và cảnh báo thời tiết nâng cao.
- Dữ liệu forecast phụ thuộc giới hạn gói miễn phí của OpenWeatherMap.

## Hướng phát triển

- Thêm đa ngôn ngữ.
- Thêm AQI và khuyến nghị sức khỏe.
- Thêm thông báo cảnh báo thời tiết.
- Bổ sung widget ngoài màn hình chính.
