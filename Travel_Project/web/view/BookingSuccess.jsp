<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="Models.BookingSummary"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    private String h(Object value) {
        if (value == null) {
            return "";
        }
        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
%>
<%
    BookingSummary booking = (BookingSummary) request.getAttribute("booking");
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateTime = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Created</title>
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: #f7f8fa;
                color: #202124;
            }
            .page {
                max-width: 760px;
                margin: 0 auto;
                padding: 40px 20px 48px;
            }
            .card {
                background: #fff;
                border: 1px solid #e0e3e7;
                border-radius: 16px;
                padding: 28px;
                box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
            }
            h1 {
                margin: 0 0 10px;
                color: #0b6b5f;
            }
            p {
                line-height: 1.6;
            }
            .grid {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
                margin: 22px 0;
            }
            .item {
                padding: 14px;
                border: 1px solid #e8edf1;
                border-radius: 10px;
                background: #fafcfd;
            }
            .label {
                display: block;
                margin-bottom: 6px;
                font-size: 13px;
                color: #607080;
            }
            .value {
                font-weight: 700;
            }
            .actions {
                display: flex;
                gap: 12px;
                margin-top: 22px;
                flex-wrap: wrap;
            }
            .button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 42px;
                padding: 10px 16px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 700;
            }
            .primary {
                background: #00796b;
                color: #fff;
            }
            .secondary {
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
            }
            @media (max-width: 680px) {
                .grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <% if (booking == null) { %>
                <div class="card">
                    <h1>Không tìm thấy booking</h1>
                    <p>Booking vừa tạo không còn khả dụng.</p>
                    <div class="actions">
                        <a class="button primary" href="<%= request.getContextPath()%>/tours">Quay lại tour</a>
                    </div>
                </div>
            <% } else { %>
                <div class="card">
                    <h1>Đặt tour thành công</h1>
                    <p>Booking đã được tạo và đang ở trạng thái <strong><%= h(booking.getStatus())%></strong>.</p>

                    <div class="grid">
                        <div class="item">
                            <span class="label">Mã booking</span>
                            <span class="value">#<%= booking.getBookingID()%></span>
                        </div>
                        <div class="item">
                            <span class="label">Khách hàng</span>
                            <span class="value"><%= h(booking.getCustomerName())%></span>
                        </div>
                        <div class="item">
                            <span class="label">Tour</span>
                            <span class="value"><%= h(booking.getTourName())%></span>
                        </div>
                        <div class="item">
                            <span class="label">Số khách</span>
                            <span class="value"><%= booking.getNumberOfPeople()%></span>
                        </div>
                        <div class="item">
                            <span class="label">Ngày đặt</span>
                            <span class="value"><%= h(booking.getBookingDate())%></span>
                        </div>
                        <div class="item">
                            <span class="label">Tổng tiền</span>
                            <span class="value"><%= money.format(booking.getTotalAmount())%></span>
                        </div>
                        <div class="item">
                            <span class="label">Mã thanh toán</span>
                            <span class="value"><%= h(booking.getPaymentCode())%></span>
                        </div>
                        <div class="item">
                            <span class="label">Hết hạn thanh toán</span>
                            <span class="value"><%= booking.getPaymentExpiredAt() == null ? "" : h(dateTime.format(booking.getPaymentExpiredAt()))%></span>
                        </div>
                    </div>

                    <div class="actions">
                        <a class="button primary" href="<%= request.getContextPath()%>/payment?id=<%= booking.getBookingID()%>&autoStart=1">Đi đến thanh toán</a>
                    </div>
                </div>
            <% } %>
        </main>
    </body>
</html>
