# Thông báo:

## Dự án gốc đã dược lưu trữ nên sẽ không thể duy trì cũng như không có phiên bản mới.
## Đây là IAS phiên bản custom bởi DucNguyen, phiên bản gốc tại đây [GitHub](https://github.com/WindowsAddict/IDM-Activation-Script).

------------------------------------------------------------------------

## IDM Activation Script Việt Hoá

Một công cụ mã nguồn mở để kích hoạt và reset bản dùng thử [Internet Download Manager](https://www.internetdownloadmanager.com/)

## Tính năng

-   Khóa thời gian dùng thử IDM và kích hoạt bằng phương pháp khóa Registry.
-   Thời gian dùng thử vẫn duy trì ngay cả sau khi cài đặt các bản cập nhật của IDM.
-   Đặt lại thời gian dùng thử IDM.
-   Hoàn toàn mã nguồn mở.
-   Dựa trên script batch minh bạch.

## Phiên bản IAS Gốc mới nhất

Phiên bản cuối - v1.2 (12-Feb-2024)\
[GitHub](https://github.com/WindowsAddict/IDM-Activation-Script) - [BitBucket](https://bitbucket.org/WindowsAddict/idm-activation-script/)

## Tải xuống / Cách sử dụng?

-   Đầu tiên, cài đặt mới [Internet Download Manager](https://www.internetdownloadmanager.com/). Đảm bảo các bản crack/bản vá trước đó đã được xóa/gỡ cài đặt nếu có.
-   Sau đó, hãy làm theo các bước bên dưới để kích hoạt.

## Lưu ý

-   📌 Tùy chọn kích hoạt hiện không hoạt động trong script, hãy sử dụng tùy chọn "Freeze trial" để khóa thời gian dùng thử 30 ngày vĩnh viễn.
-   Phiên bản 1.2 đã có thể kích hoạt và sử dụng bản quyền bình thường, đôi khi sẽ bị tình trạng mất bản quyền.

## Thông tin

#### Đóng băng bản dùng thử

-   IDM cung cấp thời gian dùng thử 30 ngày, bạn có thể sử dụng tùy chọn này trong tập lệnh để khóa thời gian dùng thử này trong suốt thời gian sử dụng để bạn không phải đặt lại bản dùng thử và bản dùng thử của bạn sẽ không hết hạn.
-   Phương pháp này yêu cầu phải có Internet tại thời điểm áp dụng tùy chọn này.
-   Có thể cài đặt trực tiếp các bản cập nhật IDM mà không cần phải đóng băng lại.

#### Kích hoạt

(\*Hiện không hoạt động)

-   Tập lệnh này áp dụng phương pháp khóa sổ đăng ký để kích hoạt trình quản lý tải xuống Internet (IDM).
-   Phương pháp này yêu cầu Internet tại thời điểm kích hoạt.
-   Có thể cài đặt trực tiếp các bản cập nhật IDM mà không cần phải kích hoạt lại.
-   Sau khi kích hoạt, nếu trong một số trường hợp, IDM bắt đầu hiển thị màn hình nhắc nhở kích hoạt, thì chỉ cần chạy lại tùy chọn kích hoạt mà không cần sử dụng tùy chọn đặt lại.

#### Đặt lại Kích hoạt / Dùng thử IDM

-   Trình quản lý tải xuống Internet cung cấp thời gian dùng thử 30 ngày, bạn có thể sử dụng tập lệnh này để đặt lại Thời gian dùng thử / Kích hoạt này bất cứ khi nào bạn muốn.
-   Tùy chọn này cũng có thể được sử dụng để khôi phục trạng thái nếu trong trường hợp IDM báo cáo khóa sê-ri giả và các lỗi tương tự khác.

#### Yêu cầu hệ điều hành

-   Dự án được hỗ trợ cho Windows 7/8/8.1/10/11 và Máy chủ tương đương của chúng.
-   Phương pháp PowerShell để chạy IAS được hỗ trợ trên Windows 8 trở lên.

#### Thông tin nâng cao

-   Để kích hoạt ở chế độ không giám sát, hãy chạy tập lệnh với tham số `/act`.
-   Để đóng băng bản dùng thử ở chế độ không giám sát, hãy chạy tập lệnh với tham số `/frz`.
-   Để đặt lại ở chế độ không giám sát, hãy chạy tập lệnh với tham số `/res`.

## Nó hoạt động như thế nào?

-   IDM lưu trữ dữ liệu liên quan đến bản dùng thử và kích hoạt trên nhiều khóa sổ đăng ký khác nhau. Một số khóa này bị khóa để bảo vệ chúng khỏi bị giả mạo và dữ liệu được lưu trữ theo một mẫu để theo dõi sự cố sê-ri giả và số ngày dùng thử còn lại. Để kích hoạt, tập lệnh ở đây chỉ cần tạo các khóa sổ đăng ký đó bằng cách kích hoạt một vài lượt tải xuống trong IDM, xác định các khóa sổ đăng ký đó và khóa chúng để IDM không thể chỉnh sửa và xem chúng. Theo cách đó, IDM không thể hiển thị cảnh báo rằng nó được kích hoạt bằng khóa sê-ri giả.

## Khắc phục sự cố

-   Sửa lỗi tích hợp trình duyệt: [Chrome](https://www.internetdownloadmanager.com/register/new_faq/bi9.html) - [Firefox](https://www.internetdownloadmanager.com/register/new_faq/bi4.html)
-   Nêu vấn đề trên [Github](https://github.com/WindowsAddict/IDM-Activation-Script) kèm theo ảnh chụp màn hình.

## Nhật ký thay đổi

#### v1.2

-   Thêm tùy chọn kích hoạt lại với tên, email và thông tin đăng ký ngẫu nhiên cùng với cảnh báo rằng tùy chọn này không hoạt động đối với một số người dùng, tùy chọn được khuyến nghị là sử dụng bản dùng thử Freeze.

## Ảnh chụp màn hình

![](https://massgrave.dev/images/IAS.png?raw=true)

![](https://massgrave.dev/images/IAS_Freeze_Trial.png?raw=true)

## Ghi công

| | |
|----------------------|--------------------------------------------------|
| Dukun Cabul | Nhà nghiên cứu ban đầu về logic kích hoạt và thiết lập lại bản dùng thử IDM này, đã tạo ra một công cụ Autoit cho các phương pháp này, [IDM-AIO_2020_Final](https://nsaneforums.com/topic/371047-discussion-internet-download-manager-fixes/page/8/#comment-1632062) |
| AveYo hay còn gọi là BAU | [reg_own lean and mean snippet](https://pastebin.com/XTPt0JSC) |
| [abbodi1406](https://github.com/abbodi1406) | Trợ giúp về mã hóa |
| WindowsAddict | Tác giả IAS |

Và cảm ơn người dùng IAS vì sự quan tâm, phản hồi và hỗ trợ của họ.

------------------------------------------------------------------------

Được tạo ra với tình yêu ❤️
