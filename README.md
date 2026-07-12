# projectPRJ301

## Chạy project cơ bản

Mọi người trong nhóm không bắt buộc phải cài thêm công cụ để chỉ chạy project.

Cần có:
- `JDK 17`
- `Apache Tomcat 10`
- `SQL Server`
- database được tạo từ file [traveldatabase.sql](D:\projectPRJ301-main\projectPRJ301-main\traveldatabase.sql)

Nếu máy đã có database cũ thì không cần chạy lại toàn bộ file SQL. Chỉ chạy phần migration ở cuối file `traveldatabase.sql`.

## Test thanh toán SePay sandbox

Chỉ người nào trực tiếp test hoặc demo luồng thanh toán mới cần làm phần này.

### Cần chuẩn bị

- tài khoản `ngrok`
- `ngrok authtoken`
- tài khoản `SePay sandbox` hoặc bộ `merchantId` và `secretKey` do nhóm dùng chung

### 1. Cài ngrok

Có thể cài bằng `winget`:

```powershell
winget install --id Ngrok.Ngrok --source winget --accept-source-agreements --accept-package-agreements
```

Nếu `winget` cài ra bản cũ, có thể tải bản mới trực tiếp từ trang ngrok hoặc dùng bản đã giải nén local.

### 2. Thêm authtoken cho ngrok

```powershell
ngrok config add-authtoken YOUR_NGROK_AUTHTOKEN
```

Nếu terminal chưa nhận `ngrok` sau khi cài, mở terminal mới hoặc dùng đường dẫn đầy đủ đến `ngrok.exe`.

### 3. Chạy Tomcat

Đảm bảo project chạy được ở:

```text
http://localhost:8080/Travel_Project
```

### 4. Mở public URL bằng ngrok

```powershell
ngrok http 8080
```

Ngrok sẽ trả về một URL kiểu:

```text
https://your-name.ngrok-free.dev
```

### 5. Cấu hình file SePay local

Sửa file [SePaySandbox.properties](D:\projectPRJ301-main\projectPRJ301-main\Travel_Project\src\java\SePaySandbox.properties):

```properties
merchantId=YOUR_SEPAY_MERCHANT_ID
secretKey=YOUR_SEPAY_SECRET_KEY
checkoutUrl=https://pay-sandbox.sepay.vn/v1/checkout/init
appBaseUrl=https://your-name.ngrok-free.dev/Travel_Project
```

Lưu ý:
- không commit `secretKey` thật lên repo
- `appBaseUrl` là cấu hình local, mỗi người test có thể khác nhau vì URL ngrok free thường đổi

### 6. Cấu hình IPN trên SePay

Điền IPN URL trong SePay:

```text
https://your-name.ngrok-free.dev/Travel_Project/payment/sepay-ipn
```

### 7. Restart Tomcat

Sau khi đổi `SePaySandbox.properties`, cần restart Tomcat để project đọc lại cấu hình.

### 8. Cách test

1. Vào `/tours`
2. Chọn tour và đặt booking
3. Bấm `Đi đến thanh toán`
4. Hệ thống sẽ tự chuyển sang cổng SePay
5. Sau khi thanh toán xong, SePay trả về project
6. Nếu callback thành công, booking sẽ đổi sang trạng thái đã thanh toán

## Nếu bạn khác trong nhóm cũng muốn test thanh toán

Người đó cần tự làm các bước sau trên máy của họ:

1. chạy database đúng migration
2. chạy project trên Tomcat
3. cài `ngrok`
4. thêm `ngrok authtoken` của họ
5. tự mở `ngrok http 8080`
6. tự sửa `appBaseUrl` trong `SePaySandbox.properties`
7. cập nhật lại `IPN URL` trên SePay theo URL ngrok mới

Không cần mọi người cùng cài `ngrok` nếu họ không test payment.

## Lỗi thường gặp

### `Cannot create payment record`

Nguyên nhân thường là database cũ còn để `Payments.SePayTransactionId` kiểu `BIGINT`.

Chạy migration:

```sql
ALTER TABLE Payments ALTER COLUMN SePayTransactionId VARCHAR(100) NULL;
```

### SePay không gọi được callback

Kiểm tra:
- `ngrok` còn đang chạy không
- `appBaseUrl` có đúng URL mới nhất không
- `IPN URL` trên SePay có đúng không
- Tomcat có đang chạy ở cổng `8080` không

### Bấm thanh toán nhưng không chuyển sang SePay

Kiểm tra:
- đã restart Tomcat sau khi sửa config chưa
- `merchantId` và `secretKey` có đúng không
- `SePaySandbox.properties` có đang để trống không

