<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="Models.Tour"%>
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
    List<Tour> tours = (List<Tour>) request.getAttribute("tours");
    if (tours == null) {
        tours = new ArrayList<>();
    }
    List<String> destinations = (List<String>) request.getAttribute("destinations");
    if (destinations == null) {
        destinations = new ArrayList<>();
    }
    String keyword = (String) request.getAttribute("keyword");
    String selectedDestination = (String) request.getAttribute("selectedDestination");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalItemsObj = (Integer) request.getAttribute("totalItems");
    Integer upcomingCountObj = (Integer) request.getAttribute("upcomingCount");
    Integer destinationCountObj = (Integer) request.getAttribute("destinationCount");
    Integer allTourCountObj = (Integer) request.getAttribute("allTourCount");

    int currentPage = currentPageObj == null ? 1 : currentPageObj;
    int totalPages = totalPagesObj == null ? 1 : totalPagesObj;
    int totalItems = totalItemsObj == null ? tours.size() : totalItemsObj;
    int upcomingCount = upcomingCountObj == null ? 0 : upcomingCountObj;
    int destinationCount = destinationCountObj == null ? 0 : destinationCountObj;
    int allTourCount = allTourCountObj == null ? 0 : allTourCountObj;

    if (keyword == null) {
        keyword = "";
    }
    if (selectedDestination == null) {
        selectedDestination = "";
    }
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Tour Management</title>
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
                background: linear-gradient(135deg, #7f1d1d, #b45309);
                color: #fff;
                margin-bottom: 20px;
            }
            .hero h1 {
                margin: 0 0 10px;
            }
            .hero p {
                margin: 0;
                line-height: 1.6;
                color: rgba(255,255,255,.92);
            }
            .stats {
                display: grid;
                grid-template-columns: repeat(4, minmax(0, 1fr));
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
                grid-template-columns: minmax(0, 1.2fr) minmax(220px, 0.7fr) auto auto;
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
            .thumb {
                width: 84px;
                height: 58px;
                object-fit: cover;
                border-radius: 8px;
                background: #dde3ea;
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
            @media (max-width: 980px) {
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
                <div><strong>Admin Tour</strong></div>
                <nav class="nav-links">
                    <a class="nav-link" href="<%= request.getContextPath()%>/tours">Khách hàng</a>
                    <a class="nav-link" href="<%= request.getContextPath()%>/staff/bookings">Staff Booking</a>
                    <a class="nav-link active" href="<%= request.getContextPath()%>/admin/tours">Admin Tour</a>
                </nav>
            </div>

            <section class="hero">
                <h1>Quản lý tour cho admin</h1>
            </section>

            <section class="stats">
                <div class="stat">
                    <span class="label">Tổng tour toàn hệ thống</span>
                    <span class="value"><%= allTourCount%></span>
                </div>
                <div class="stat">
                    <span class="label">Tour đang hiển thị</span>
                    <span class="value"><%= totalItems%></span>
                </div>
                <div class="stat">
                    <span class="label">Tour sắp khởi hành</span>
                    <span class="value"><%= upcomingCount%></span>
                </div>
                <div class="stat">
                    <span class="label">Điểm đến khác nhau</span>
                    <span class="value"><%= destinationCount%></span>
                </div>
            </section>

            <section class="panel">
                <div class="toolbar">
                    <form class="filter-form" action="<%= request.getContextPath()%>/admin/tours" method="get">
                        <div>
                            <label for="keyword">Tìm tour</label>
                            <input id="keyword" type="text" name="keyword" value="<%= h(keyword)%>" placeholder="Tên tour hoặc điểm đến">
                        </div>
                        <div>
                            <label for="destination">Điểm đến</label>
                            <select id="destination" name="destination">
                                <option value="">Tất cả điểm đến</option>
                                <% for (String destination : destinations) { %>
                                    <option value="<%= h(destination)%>" <%= destination.equals(selectedDestination) ? "selected" : ""%>><%= h(destination)%></option>
                                <% } %>
                            </select>
                        </div>
                        <div>
                            <label>&nbsp;</label>
                            <button class="button" type="submit">Lọc tour</button>
                        </div>
                        <div>
                            <label>&nbsp;</label>
                            <a class="ghost-button" href="<%= request.getContextPath()%>/admin/tour-form">Thêm tour mới</a>
                        </div>
                    </form>
                    <div><strong><%= totalItems%></strong> kết quả</div>
                </div>

                <% if (request.getParameter("saved") != null) { %>
                    <div class="notice">Thông tin tour đã được lưu thành công.</div>
                <% } %>
                <% if (request.getParameter("deleted") != null) { %>
                    <div class="notice">Tour đã được xóa thành công.</div>
                <% } %>
                <% if (request.getParameter("deleteBlocked") != null) { %>
                    <div class="notice warning">Tour đang có booking hoặc dữ liệu liên quan nên chưa thể xóa.</div>
                <% } %>
                <% if (request.getParameter("deleteError") != null) { %>
                    <div class="notice error">Không thể xóa tour vì dữ liệu đầu vào không hợp lệ.</div>
                <% } %>

                <% if (tours.isEmpty()) { %>
                    <div class="empty">Không có tour phù hợp với bộ lọc hiện tại.</div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Tên tour</th>
                                <th>Lịch trình</th>
                                <th>Sức chứa</th>
                                <th>Giá</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Tour tour : tours) { %>
                                <tr>
                                    <td data-label="Ảnh">
                                        <img class="thumb" src="<%= request.getContextPath()%>/images/<%= h(tour.getImageURL())%>" alt="<%= h(tour.getTourName())%>">
                                    </td>
                                    <td data-label="Tên tour">
                                        <strong><%= h(tour.getTourName())%></strong><br>
                                        <%= h(tour.getDestination())%>
                                    </td>
                                    <td data-label="Lịch trình">
                                        <%= tour.getDuration()%> ngày<br>
                                        <%= h(tour.getStartDate())%> đến <%= h(tour.getEndDate())%>
                                    </td>
                                    <td data-label="Sức chứa"><%= tour.getMaxPeople()%> khách</td>
                                    <td data-label="Giá"><%= money.format(tour.getPrice())%></td>
                                    <td data-label="Thao tác">
                                        <div class="actions">
                                            <a class="ghost-button" href="<%= request.getContextPath()%>/admin/tour-form?id=<%= tour.getTourID()%>">Sửa</a>
                                            <form action="<%= request.getContextPath()%>/admin/tour-delete" method="post" onsubmit="return confirm('Xóa tour này?');">
                                                <input type="hidden" name="id" value="<%= tour.getTourID()%>">
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
                            <form action="<%= request.getContextPath()%>/admin/tours" method="get">
                                <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                                <input type="hidden" name="destination" value="<%= h(selectedDestination)%>">
                                <input type="hidden" name="page" value="<%= currentPage - 1%>">
                                <button class="page-button" type="submit">Trước</button>
                            </form>
                        <% } %>
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <form action="<%= request.getContextPath()%>/admin/tours" method="get">
                                <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                                <input type="hidden" name="destination" value="<%= h(selectedDestination)%>">
                                <input type="hidden" name="page" value="<%= i%>">
                                <button class="page-button <%= i == currentPage ? "active" : ""%>" type="submit"><%= i%></button>
                            </form>
                        <% } %>
                        <% if (currentPage < totalPages) { %>
                            <form action="<%= request.getContextPath()%>/admin/tours" method="get">
                                <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                                <input type="hidden" name="destination" value="<%= h(selectedDestination)%>">
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
