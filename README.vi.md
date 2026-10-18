# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

Tắt Turbo Boost để máy Mac yên tĩnh hơn và khôi phục khi bạn cần hiệu năng tối đa.

## Tải xuống

[Tải xuống](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=vi)

Không. TurboKiller cần máy Mac Intel tương thích chạy macOS 13 trở lên.

Không. Giữ Bảo vệ tính toàn vẹn hệ thống được bật và báo cáo sự cố thay vì thay đổi cài đặt bảo mật.

## Cài đặt

1. Mở DMG và kéo TurboKiller vào Ứng dụng.
2. Mở ứng dụng. Nếu bị chặn: Cài đặt hệ thống → Quyền riêng tư & Bảo mật → Vẫn mở.
3. Cho phép chạy nền nếu được yêu cầu, rồi làm theo hướng dẫn phê duyệt phần mở rộng hoặc khởi động lại.

Thoát TurboKiller và thay ứng dụng trong Ứng dụng bằng phiên bản từ TurboKiller-1.2.0.dmg. Làm theo yêu cầu phê duyệt hoặc khởi động lại nếu có.

Ứng dụng và dịch vụ được ký bằng Developer ID. Phiên bản này chưa được Apple công chứng; macOS có thể chặn lần mở đầu tiên. Chỉ tải từ kho mã chính thức. Thoát ứng dụng cũ trước khi thay thế.

## Cách sử dụng

Chọn “Tắt Turbo Boost” để giảm nhiệt và tiếng quạt; chọn “Khôi phục Turbo Boost” khi cần hiệu năng. Việc tắt có thể làm chậm tác vụ nặng. Kiểm tra trạng thái sau khi chuyển đổi; không bấm liên tục nếu có lỗi.

Xem trạng thái trên biểu tượng gió ở thanh menu

## Ghi chú phát hành · 1.2.0

- Biểu tượng gió cố định với dấu trạng thái đơn sắc: Turbo Boost bật, tắt hoặc chưa xác định.
- Cửa sổ gọn hiển thị trạng thái và điều khiển; máy Mac không được hỗ trợ sẽ hiển thị giải thích thay thế. Cài đặt và Thoát luôn có sẵn.
- 17 phiên bản ngôn ngữ cho ứng dụng, trang web, README và ghi chú này, gồm tiếng Ả Rập và tiếng Do Thái với bố cục từ phải sang trái.
- Cập nhật trạng thái khi khởi chạy, thức dậy, sau thao tác và định kỳ trong nền.

[Ghi chú phát hành](docs/releases/1.2.0/vi.md)

## Phản hồi

Vẫn đang thử nghiệm, đã kiểm tra trên một số máy Mac Intel. Không đảm bảo tương thích với mọi cấu hình phần cứng và macOS. Báo cáo sự cố trên GitHub kèm mẫu máy Mac, phiên bản macOS và ứng dụng, cùng lỗi đầy đủ hoặc ảnh chụp màn hình. Chúng tôi cũng hoan nghênh báo cáo hoạt động thành công.

[Báo cáo sự cố](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.vi.yml)

## Dành cho nhà phát triển

Ứng dụng thanh menu SwiftUI giao tiếp qua XPC với dịch vụ nền đặc quyền để nạp hoặc dỡ phần mở rộng nhân cũ đi kèm. Trạng thái phản ánh việc nạp phần mở rộng, không đo tần số CPU. Mở TurboKiller.xcodeproj trong Xcode để biên dịch. Giữ nguyên gói phần mở rộng lịch sử.

[SHA-256](LegacyKextIntegrity.swift)

## Ủng hộ

TurboKiller miễn phí và có mã nguồn mở. Nếu ứng dụng hữu ích, bạn có thể mời tôi một ly cà phê.

[Mời tôi một ly cà phê](https://ko-fi.com/hello_nico_chan)

## Giấy phép

[GPL-2.0](LICENSE) · [Thông báo của bên thứ ba](THIRD_PARTY_NOTICES.md)
