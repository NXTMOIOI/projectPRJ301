<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
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
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    if (errors == null) {
        errors = new LinkedHashMap<>();
    }
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Booking</title>
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: #f7f8fa;
                color: #202124;
            }
            .page {
                max-width: 860px;
                margin: 0 auto;
                padding: 28px 20px 48px;
            }
            .back {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 40px;
                padding: 10px 14px;
                border-radius: 999px;
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
                text-decoration: none;
                font-weight: 700;
                margin-bottom: 18px;
            }
            .card {
                background: #fff;
                border: 1px solid #e0e3e7;
                border-radius: 16px;
                padding: 28px;
            }
            .meta {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
                margin: 18px 0 22px;
            }
            .meta-item {
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
                font-weight: 700;
            }
            .field {
                margin-bottom: 16px;
            }
            .field label {
                display: block;
                margin-bottom: 6px;
                font-size: 13px;
                color: #5f6368;
                font-weight: 700;
            }
            .field input,
            .field select {
                width: 100%;
                min-height: 42px;
                padding: 10px 12px;
                border: 1px solid #cfd8dc;
                border-radius: 8px;
                font: inherit;
            }
            .error-box {
                margin-bottom: 18px;
                padding: 14px 16px;
                border-radius: 10px;
                background: #fff3f3;
                color: #a33a3a;
            }
            .error-text {
                margin-top: 6px;
                font-size: 13px;
                color: #b42318;
            }
            .actions {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                margin-top: 20px;
            }
            .button,
            .danger-button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 42px;
                padding: 10px 16px;
                border-radius: 8px;
                font: inherit;
                font-weight: 700;
                text-decoration: none;
                cursor: pointer;
            }
            .button {
                border: 0;
                background: #00796b;
                color: #fff;
            }
            .danger-button {
                border: 1px solid #efc7c7;
                background: #fff5f5;
                color: #b42318;
            }
            form {
                margin: 0;
            }
            @media (max-width: 680px) {
                .meta {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <a class="back" href="<%= request.getContextPath()%>/staff/bookings">Quay lại danh sách booking</a>

            <% if (booking == null) { %>
                <div class="card">
                    <h1>Không tìm thấy booking</h1>
                </div>
            <% } else { %>
                <div class="card">
                    <h1>Cập nhật booking #<%= booking.getBookingID()%></h1>
                    <p>Staff có thể chỉnh số khách và trạng thái booking trong khi vẫn giữ đúng sức chứa của tour.</p>

                    <% if (!errors.isEmpty()) { %>
                        <div class="error-box">Vui lòng kiểm tra lại thông tin trước khi lưu.</div>
                    <% } %>

                    <div class="meta">
                        <div class="meta-item">
                            <span class="label">Khách hàng</span>
                            <strong><%= h(booking.getCustomerName())%></strong><br>
                            <%= h(booking.getCustomerPhone())%><br>
                            <%= h(booking.getCustomerEmail())%>
                        </div>
                        <div class="meta-item">
                            <span class="label">Tour</span>
                            <strong><%= h(booking.getTourName())%></strong><br>
                            Giá hiện tại: <%= money.format(booking.getUnitPrice())%>
                        </div>
                    </div>

                    <form action="<%= request.getContextPath()%>/staff/booking-form" method="post">
                        <input type="hidden" name="bookingID" value="<%= booking.getBookingID()%>">

                        <div class="field">
                            <label for="numberOfPeople">Số khách</label>
                            <input id="numberOfPeople" type="number" name="numberOfPeople" min="1" value="<%= booking.getNumberOfPeople()%>">
                            <% if (errors.get("numberOfPeople") != null) { %>
                                <div class="error-text"><%= h(errors.get("numberOfPeople"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="status">Trạng thái</label>
                            <select id="status" name="status">
                                <option value="Chờ thanh toán" <%= "Chờ thanh toán".equals(booking.getStatus()) ? "selected" : ""%>>Chờ thanh toán</option>
                                <option value="Đã thanh toán" <%= "Đã thanh toán".equals(booking.getStatus()) ? "selected" : ""%>>Đã thanh toán</option>
                                <option value="Đã xác nhận" <%= "Đã xác nhận".equals(booking.getStatus()) ? "selected" : ""%>>Đã xác nhận</option>
                                <option value="Đã hủy" <%= "Đã hủy".equals(booking.getStatus()) ? "selected" : ""%>>Đã hủy</option>
                                <option value="Hoàn tất" <%= "Hoàn tất".equals(booking.getStatus()) ? "selected" : ""%>>Hoàn tất</option>
                                <option value="Hết hạn" <%= "Hết hạn".equals(booking.getStatus()) ? "selected" : ""%>>Hết hạn</option>
                            </select>
                            <% if (errors.get("status") != null) { %>
                                <div class="error-text"><%= h(errors.get("status"))%></div>
                            <% } %>
                        </div>

                        <% if (errors.get("general") != null) { %>
                            <div class="error-box"><%= h(errors.get("general"))%></div>
                        <% } %>

                        <div class="actions">
                            <button class="button" type="submit">Lưu thay đổi</button>
                        </div>
                    </form>

                    <div class="actions">
                        <form action="<%= request.getContextPath()%>/staff/booking-delete" method="post" onsubmit="return confirm('Xóa booking này?');">
                            <input type="hidden" name="id" value="<%= booking.getBookingID()%>">
                            <button class="danger-button" type="submit">Xóa booking</button>
                        </form>
                    </div>
                </div>
            <% } %>
        </main>
    </body>
</html>
