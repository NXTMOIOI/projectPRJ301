<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Travel Project Hub</title>
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: linear-gradient(135deg, #0f172a, #134e4a);
                color: #fff;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 24px;
            }
            .card {
                width: min(980px, 100%);
                padding: 32px;
                border-radius: 24px;
                background: rgba(255, 255, 255, 0.08);
                backdrop-filter: blur(12px);
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.18);
            }
            h1 {
                margin: 0 0 10px;
                font-size: 40px;
            }
            p {
                margin: 0 0 24px;
                max-width: 760px;
                line-height: 1.7;
                color: rgba(255,255,255,.9);
            }
            .grid {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 18px;
            }
            .link-card {
                display: block;
                padding: 22px;
                border-radius: 18px;
                background: rgba(255, 255, 255, 0.12);
                color: #fff;
                text-decoration: none;
                border: 1px solid rgba(255,255,255,.14);
            }
            .link-card strong {
                display: block;
                margin-bottom: 8px;
                font-size: 20px;
            }
            .link-card span {
                color: rgba(255,255,255,.88);
                line-height: 1.6;
            }
            @media (max-width: 820px) {
                .grid {
                    grid-template-columns: 1fr;
                }
                h1 {
                    font-size: 32px;
                }
            }
        </style>
    </head>
    <body>
        <section class="card">
            <h1>Travel Project</h1>
            <p>
                Hub này gom đúng các phần bạn đang đảm nhận: khách đặt tour, staff quản lý booking,
                admin quản lý tour. Phần thanh toán online chưa được nhồi vào đây để dành cho SePay sandbox sau.
            </p>
            <div class="grid">
                <a class="link-card" href="<%= request.getContextPath()%>/tours">
                    <strong>Khách hàng</strong>
                    <span>Xem tour, lọc tìm kiếm và tạo booking trực tiếp từ trang chi tiết tour.</span>
                </a>
                <a class="link-card" href="<%= request.getContextPath()%>/staff/bookings">
                    <strong>Staff Booking</strong>
                    <span>Tìm, lọc, cập nhật và xóa booking khi chưa có payment liên quan.</span>
                </a>
                <a class="link-card" href="<%= request.getContextPath()%>/admin/tours">
                    <strong>Admin Tour</strong>
                    <span>CRUD tour, tìm kiếm, phân trang và chặn xóa khi còn dữ liệu ràng buộc.</span>
                </a>
            </div>
        </section>
    </body>
</html>
