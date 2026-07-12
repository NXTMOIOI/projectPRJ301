<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
    List<BookingSummary> bookings = (List<BookingSummary>) request.getAttribute("bookings");
    if (bookings == null) {
        bookings = new ArrayList<>();
    }

    String keyword = (String) request.getAttribute("keyword");
    String status = (String) request.getAttribute("status");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalItemsObj = (Integer) request.getAttribute("totalItems");
    Integer pendingCountObj = (Integer) request.getAttribute("pendingCount");
    Integer paidCountObj = (Integer) request.getAttribute("paidCount");
    Integer confirmedCountObj = (Integer) request.getAttribute("confirmedCount");
    Integer cancelledCountObj = (Integer) request.getAttribute("cancelledCount");
    Integer expiredCountObj = (Integer) request.getAttribute("expiredCount");

    int currentPage = currentPageObj == null ? 1 : currentPageObj;
    int totalPages = totalPagesObj == null ? 1 : totalPagesObj;
    int totalItems = totalItemsObj == null ? bookings.size() : totalItemsObj;
    int pendingCount = pendingCountObj == null ? 0 : pendingCountObj;
    int paidCount = paidCountObj == null ? 0 : paidCountObj;
    int confirmedCount = confirmedCountObj == null ? 0 : confirmedCountObj;
    int cancelledCount = cancelledCountObj == null ? 0 : cancelledCountObj;
    int expiredCount = expiredCountObj == null ? 0 : expiredCountObj;

    if (keyword == null) {
        keyword = "";
    }
    if (status == null) {
        status = "";
    }

    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staff Booking Management</title>
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: #f7f8fa;
                color: #202124;
            }
            .page {
                max-width: 1180px;
                margin: 0 auto;
                padding: 24px 20px 48px;
            }
            .topbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 16px;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }
            .nav-links {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
            .nav-link {
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
            }
            .nav-link.active,
            .nav-link:hover {
                border-color: #00796b;
                background: #e6f4f1;
                color: #00574d;
            }
            .hero {
                padding: 26px 28px;
                border-radius: 18px;
                background: linear-gradient(135deg, #113f67, #1f6aa5);
                color: #fff;
                margin-bottom: 20px;
            }
            .hero h1 {
                margin: 0 0 10px;
            }
            .stats {
                display: grid;
                grid-template-columns: repeat(5, minmax(0, 1fr));
                gap: 14px;
                margin-bottom: 20px;
            }
            .stat {
                padding: 18px;
                border-radius: 14px;
                border: 1px solid #e0e3e7;
                background: #fff;
            }
            .stat .label {
                display: block;
                margin-bottom: 6px;
                color: #607080;
                font-size: 13px;
            }
            .stat .value {
                font-size: 28px;
                font-weight: 800;
            }
            .panel {
                border: 1px solid #e0e3e7;
                border-radius: 14px;
                background: #fff;
                overflow: hidden;
            }
            .toolbar {
                padding: 18px;
                border-bottom: 1px solid #eef1f4;
                display: grid;
                grid-template-columns: minmax(0, 1fr) auto;
                gap: 12px;
                align-items: end;
            }
            .filter-form {
                display: grid;
                grid-template-columns: minmax(0, 1.4fr) minmax(220px, 0.7fr) auto;
                gap: 12px;
            }
            label {
                display: block;
                margin-bottom: 6px;
                font-size: 13px;
                font-weight: 700;
                color: #5f6368;
            }
            input[type="text"],
            select {
                width: 100%;
                min-height: 42px;
                padding: 10px 12px;
                border: 1px solid #cfd8dc;
                border-radius: 8px;
                font: inherit;
            }
            .button,
            .ghost-button,
            .page-button,
            .danger-button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 40px;
                padding: 10px 14px;
                border-radius: 8px;
                font: inherit;
                font-weight: 700;
                cursor: pointer;
                text-decoration: none;
            }
            .button {
                border: 0;
                background: #00796b;
                color: #fff;
            }
            .ghost-button,
            .page-button {
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
            }
            .danger-button {
                border: 1px solid #efc7c7;
                background: #fff5f5;
                color: #b42318;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                padding: 14px 18px;
                border-top: 1px solid #eef1f4;
                text-align: left;
                vertical-align: top;
            }
            th {
                background: #fafbfc;
                color: #607080;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: .04em;
            }
            .status-pill {
                display: inline-flex;
                padding: 6px 10px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 700;
            }
            .status-pending {
                background: #fff7e6;
                color: #ad6800;
            }
            .status-confirmed {
                background: #e8f7ee;
                color: #18794e;
            }
            .status-cancelled {
                background: #fff0f0;
                color: #b42318;
            }
            .status-done {
                background: #edf4ff;
                color: #1d4ed8;
            }
            .actions {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }
            .notice {
                margin: 0 18px 18px;
                padding: 14px 16px;
                border-radius: 10px;
                background: #eef8f6;
                color: #135b52;
            }
            .warning {
                background: #fff6e5;
                color: #8a5b00;
            }
            .error {
                background: #fff3f3;
                color: #a33a3a;
            }
            .empty {
                padding: 28px 18px;
                color: #5f6368;
            }
            .pagination {
                display: flex;
                justify-content: center;
                gap: 10px;
                flex-wrap: wrap;
                padding: 18px;
                border-top: 1px solid #eef1f4;
            }
            .page-button.active {
                background: #00796b;
                color: #fff;
                border-color: #00796b;
            }
            form {
                margin: 0;
            }
            @media (max-width: 900px) {
                .stats,
                .toolbar,
                .filter-form {
                    grid-template-columns: 1fr;
                }
                table, thead, tbody, th, td, tr {
                    display: block;
                }
                thead {
                    display: none;
                }
                td {
                    padding-top: 10px;
                    padding-bottom: 10px;
                }
                td::before {
                    content: attr(data-label);
                    display: block;
                    margin-bottom: 6px;
                    color: #607080;
                    font-size: 13px;
                    font-weight: 700;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <div class="topbar">
                <div>
                    <strong>Staff Booking</strong>
                </div>
                <nav class="nav-links">
                    <a class="nav-link" href="<%= request.getContextPath()%>/tours">Khách hàng</a>
                    <a class="nav-link active" href="<%= request.getContextPath()%>/staff/bookings">Staff Booking</a>
                    <a class="nav-link" href="<%= request.getContextPath()%>/admin/tours">Admin Tour</a>
                </nav>
            </div>

            <section class="hero">
                <h1>Quản lý booking cho staff</h1>
            </section>

            <section class="stats">
                <div class="stat">
                    <span class="label">Tổng booking</span>
                    <span class="value"><%= totalItems%></span>
                </div>
                <div class="stat">
                    <span class="label">Chờ thanh toán</span>
                    <span class="value"><%= pendingCount%></span>
                </div>
                <div class="stat">
                    <span class="label">Đã thanh toán</span>
                    <span class="value"><%= paidCount%></span>
                </div>
                <div class="stat">
                    <span class="label">Đã xác nhận</span>
                    <span class="value"><%= confirmedCount%></span>
                </div>
                <div class="stat">
                    <span class="label">Đã hủy</span>
                    <span class="value"><%= cancelledCount%></span>
                </div>
                <div class="stat">
                    <span class="label">Hết hạn</span>
                    <span class="value"><%= expiredCount%></span>
                </div>
            </section>

            <section class="panel">
                <div class="toolbar">
                    <form class="filter-form" action="<%= request.getContextPath()%>/staff/bookings" method="get">
                        <div>
                            <label for="keyword">Tìm kiếm booking</label>
                            <input id="keyword" type="text" name="keyword" value="<%= h(keyword)%>" placeholder="Mã booking, tên khách, số điện thoại, tour">
                        </div>
                        <div>
                            <label for="status">Trạng thái</label>
                            <select id="status" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Chờ thanh toán" <%= "Chờ thanh toán".equals(status) ? "selected" : ""%>>Chờ thanh toán</option>
                                <option value="Đã thanh toán" <%= "Đã thanh toán".equals(status) ? "selected" : ""%>>Đã thanh toán</option>
                                <option value="Đã xác nhận" <%= "Đã xác nhận".equals(status) ? "selected" : ""%>>Đã xác nhận</option>
                                <option value="Đã hủy" <%= "Đã hủy".equals(status) ? "selected" : ""%>>Đã hủy</option>
                                <option value="Hoàn tất" <%= "Hoàn tất".equals(status) ? "selected" : ""%>>Hoàn tất</option>
                                <option value="Hết hạn" <%= "Hết hạn".equals(status) ? "selected" : ""%>>Hết hạn</option>
                            </select>
                        </div>
                        <div>
                            <label>&nbsp;</label>
                            <button class="button" type="submit">Lọc booking</button>
                        </div>
                    </form>
                    <div><strong><%= totalItems%></strong> kết quả</div>
                </div>

                <% if (request.getParameter("updated") != null) { %>
                    <div class="notice">Booking đã được cập nhật thành công.</div>
                <% } %>
                <% if (request.getParameter("deleted") != null) { %>
                    <div class="notice">Booking đã được xóa thành công.</div>
                <% } %>
                <% if (request.getParameter("deleteBlocked") != null) { %>
                    <div class="notice warning">Booking đã có payment liên quan nên chưa thể xóa.</div>
                <% } %>
                <% if (request.getParameter("deleteError") != null) { %>
                    <div class="notice error">Không thể xóa booking vì dữ liệu đầu vào không hợp lệ.</div>
                <% } %>

                <% if (bookings.isEmpty()) { %>
                    <div class="empty">Không có booking phù hợp với bộ lọc hiện tại.</div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Booking</th>
                                <th>Khách hàng</th>
                                <th>Tour</th>
                                <th>Số khách</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (BookingSummary booking : bookings) { %>
                                <tr>
                                    <td data-label="Booking">
                                        <strong>#<%= booking.getBookingID()%></strong><br>
                                        <%= h(booking.getBookingDate())%>
                                    </td>
                                    <td data-label="Khách hàng">
                                        <strong><%= h(booking.getCustomerName())%></strong><br>
                                        <%= h(booking.getCustomerPhone())%><br>
                                        <%= h(booking.getCustomerEmail())%>
                                    </td>
                                    <td data-label="Tour">
                                        <strong><%= h(booking.getTourName())%></strong><br>
                                        Tour ID: <%= booking.getTourID()%>
                                    </td>
                                    <td data-label="Số khách"><%= booking.getNumberOfPeople()%></td>
                                    <td data-label="Tổng tiền"><%= money.format(booking.getTotalAmount())%></td>
                                    <td data-label="Trạng thái">
                                        <%
                                            String pillClass = "status-pending";
                                            if ("Đã thanh toán".equals(booking.getStatus())) {
                                                pillClass = "status-done";
                                            } else if ("Đã xác nhận".equals(booking.getStatus())) {
                                                pillClass = "status-confirmed";
                                            } else if ("Đã hủy".equals(booking.getStatus())) {
                                                pillClass = "status-cancelled";
                                            } else if ("Hết hạn".equals(booking.getStatus())) {
                                                pillClass = "status-cancelled";
                                            } else if ("Hoàn tất".equals(booking.getStatus())) {
                                                pillClass = "status-done";
                                            }
                                        %>
                                        <span class="status-pill <%= pillClass%>"><%= h(booking.getStatus())%></span>
                                    </td>
                                    <td data-label="Thao tác">
                                        <div class="actions">
                                            <a class="ghost-button" href="<%= request.getContextPath()%>/staff/booking-form?id=<%= booking.getBookingID()%>">Sửa</a>
                                            <form action="<%= request.getContextPath()%>/staff/booking-delete" method="post" onsubmit="return confirm('Xóa booking này?');">
                                                <input type="hidden" name="id" value="<%= booking.getBookingID()%>">
                                                <button class="danger-button" type="submit">Xóa</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>

                <% if (totalPages > 1) { %>
                    <div class="pagination">
                        <% if (currentPage > 1) { %>
                            <form action="<%= request.getContextPath()%>/staff/bookings" method="get">
                                <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                                <input type="hidden" name="status" value="<%= h(status)%>">
                                <input type="hidden" name="page" value="<%= currentPage - 1%>">
                                <button class="page-button" type="submit">Trước</button>
                            </form>
                        <% } %>
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <form action="<%= request.getContextPath()%>/staff/bookings" method="get">
                                <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                                <input type="hidden" name="status" value="<%= h(status)%>">
                                <input type="hidden" name="page" value="<%= i%>">
                                <button class="page-button <%= i == currentPage ? "active" : ""%>" type="submit"><%= i%></button>
                            </form>
                        <% } %>
                        <% if (currentPage < totalPages) { %>
                            <form action="<%= request.getContextPath()%>/staff/bookings" method="get">
                                <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                                <input type="hidden" name="status" value="<%= h(status)%>">
                                <input type="hidden" name="page" value="<%= currentPage + 1%>">
                                <button class="page-button" type="submit">Sau</button>
                            </form>
                        <% } %>
                    </div>
                <% } %>
            </section>
        </main>
    </body>
</html>
