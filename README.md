# Emodiary

## Information
Ngô Trí Cảnh - 20220015  
Email: canh.nt220015@sis.hust.edu.vn  

## Tính Năng Chính (Dự kiến)

### Phân loại và Tìm kiếm Nhật Ký Cảm Xúc
Gắn tags và tìm kiếm theo từ khóa để truy cập nhanh chóng.

### Đính kèm Hình Ảnh và Video
Hỗ trợ tải lên và hiển thị ảnh/video trong nhật ký.

### Lịch Sự Kiện và Kỷ Niệm Quan Trọng
Hiển thị nhật ký theo dạng lịch và đánh dấu các sự kiện đặc biệt.

### Tạo Ghi Chú Bí Mật (Private Entries)
Cho phép bảo mật ghi chú với mật khẩu hoặc các phương thức xác thực.

### Tính Năng “Mood Replay”
Gợi ý playlist âm nhạc hoặc hoạt động giúp cải thiện tâm trạng.

### Viết Lời Nhắn Cho Tương Lai
Người dùng có thể viết thư cho bản thân và đặt ngày để mở lại.

### Nhắc Nhở Nhật Ký bằng Câu Hỏi Ngẫu Nhiên
Hằng ngày, app sẽ gợi ý một câu hỏi để khơi gợi cảm xúc.

### Chế Độ Offline
Ghi nhật ký khi không có mạng và đồng bộ tự động khi online.


## Kế hoạch làm việc (Dự kiến)

### Week 1-2: UI Design and Offline Mode
- **Thiết kế giao diện cơ bản:**
    - Trang đăng nhập/đăng ký (sử dụng Firebase Authentication).
    - Trang chính hiển thị các mục nhật ký theo lịch hoặc danh sách.
- **Thêm chế độ ngoại tuyến:**
    - Tích hợp Local Storage của Flutter để lưu dữ liệu ngoại tuyến.
- **Kết quả:**
    - Hoàn thành giao diện cơ bản và cho phép người dùng lưu các mục nhật ký ngoại tuyến.

### Week 3-4: Phân loại, Tìm kiếm Nhật ký & Đính kèm Hình ảnh/Video
- **Tạo các trường nhật ký:**
    - Nội dung, cảm xúc (sử dụng biểu tượng cảm xúc), thẻ để phân loại.
- **Thêm tính năng tìm kiếm:**
    - Cho phép tìm kiếm bằng từ khóa hoặc thẻ.
- **Đính kèm hình ảnh/video:**
    - Sử dụng Firebase Storage để tải lên các tệp.
- **Kết quả:**
    - Người dùng có thể tạo các mục nhật ký, phân loại bằng thẻ và đính kèm phương tiện.

### Week 5: Nhắc nhở và Tin nhắn Tương lai
- **Tạo thông báo nhắc nhở:**
    - Kết nối với Firebase Cloud Messaging để nhận thông báo hàng ngày.
    - Hiển thị các câu hỏi ngẫu nhiên.
- **Tính năng tin nhắn tương lai:**
    - Lưu các tin nhắn để mở vào một ngày cụ thể.
- **Kết quả:**
    - Hoàn thành tính năng nhắc nhở và tin nhắn tương lai.

### Week 6: Lịch sự kiện và Kỷ niệm quan trọng
- **Thêm lịch sự kiện:**
    - Hiển thị các mục nhật ký theo tháng và đánh dấu các ngày đặc biệt.
- **Đánh dấu kỷ niệm:**
    - Tạo thông báo cho các kỷ niệm quan trọng dựa trên dữ liệu người dùng.
- **Kết quả:**
    - Người dùng có thể xem lịch và nhận thông báo sự kiện.

### Week 7: Thống kê nâng cao và Mục nhật ký riêng tư
- **Thống kê xu hướng cảm xúc:**
    - Vẽ biểu đồ cảm xúc từ dữ liệu người dùng
- **Chế độ mục nhật ký riêng tư:**
    - Bảo vệ các ghi chú bí mật bằng mật khẩu hoặc xác thực sinh trắc học.
- **Kết quả:**
    - Người dùng có thể xem thống kê cảm xúc và tạo các ghi chú riêng tư.

### Week 8: Kiểm tra, Tối ưu hóa và Trình bày sản phẩm
- **Kiểm tra ứng dụng:**
    - Kiểm tra trên nhiều thiết bị và sửa lỗi.
- **Tối ưu hóa giao diện và hiệu suất:**
    - Đảm bảo đồng bộ hóa dữ liệu mượt mà trên các thiết bị.
- **Trình bày sản phẩm:**
    - Chuẩn bị bản demo và báo cáo kết quả.
- **Kết quả:**
    - Hoàn thành ứng dụng, sẵn sàng cho buổi trình bày cuối cùng.
### Đồng Bộ Trên Nhiều Thiết Bị
Sử dụng Firebase hoặc một hệ thống backend để đồng bộ hóa dữ liệu.

### Thống Kê Sâu Hơn với Tính Năng Xu Hướng
Phân tích dữ liệu cảm xúc và hiển thị biểu đồ xu hướng theo thời gian.
