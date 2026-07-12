<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="Models.BookingSummary"%>
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

    String selectedDestination = (String) request.getAttribute("selectedDestination");
    if (selectedDestination == null) {
        selectedDestination = "";
    }

    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) {
        keyword = "";
    }

    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalItemsObj = (Integer) request.getAttribute("totalItems");
    int currentPage = currentPageObj == null ? 1 : currentPageObj;
    int totalPages = totalPagesObj == null ? 1 : totalPagesObj;
    int totalItems = totalItemsObj == null ? tours.size() : totalItemsObj;
    BookingSummary pendingBooking = (BookingSummary) request.getAttribute("pendingBooking");

    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tour Dashboard</title>
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                color: #202124;
                background: #f7f8fa;
            }

            .page {
                max-width: 1120px;
                margin: 0 auto;
                padding: 24px 20px 48px;
            }

            .topbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 16px;
                margin-bottom: 22px;
            }

            .brand {
                font-size: 14px;
                font-weight: 700;
                letter-spacing: .08em;
                text-transform: uppercase;
                color: #00796b;
            }

            .nav-links {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .nav-link {
                padding: 10px 14px;
                border-radius: 999px;
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
                text-decoration: none;
                font-weight: 600;
            }

            .nav-link.active,
            .nav-link:hover {
                border-color: #00796b;
                background: #e6f4f1;
                color: #00574d;
            }

            .hero {
                padding: 28px;
                border-radius: 18px;
                background: linear-gradient(135deg, #0b5d52, #1f8a70);
                color: #fff;
                margin-bottom: 22px;
            }

            .pending-banner {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
                flex-wrap: wrap;
                margin-bottom: 18px;
                padding: 16px 18px;
                border: 1px solid #f0d5a7;
                border-radius: 14px;
                background: #fff8ea;
                color: #7a4f01;
            }

            .hero h1 {
                margin: 0 0 10px;
                font-size: 34px;
            }

            .toolbar {
                display: grid;
                grid-template-columns: minmax(0, 1fr) auto;
                gap: 16px;
                align-items: end;
                margin-bottom: 18px;
            }

            .search-form {
                display: grid;
                grid-template-columns: minmax(0, 1.5fr) minmax(180px, 0.8fr) auto;
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
                background: #fff;
            }

            .button,
            .ghost-button,
            .page-button,
            .destination {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 40px;
                padding: 9px 14px;
                border: 0;
                border-radius: 8px;
                font: inherit;
                font-weight: 700;
                cursor: pointer;
                text-decoration: none;
            }

            .button {
                background: #00796b;
                color: #fff;
            }

            .ghost-button,
            .page-button {
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
            }

            .summary {
                font-weight: 700;
                color: #37474f;
            }

            .destination-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-bottom: 24px;
            }

            .destination {
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
            }

            .destination.active,
            .destination:hover {
                border-color: #00796b;
                background: #e6f4f1;
                color: #00574d;
            }

            .grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                gap: 18px;
            }

            .tour-card {
                overflow: hidden;
                border: 1px solid #e0e3e7;
                border-radius: 12px;
                background: #fff;
                box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
            }

            .tour-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
                display: block;
                background: #dde3ea;
            }

            .content {
                padding: 18px;
            }

            .tour-card h2 {
                margin: 0 0 8px;
                font-size: 21px;
                line-height: 1.3;
            }

            .meta {
                margin: 0 0 14px;
                color: #5f6368;
                line-height: 1.6;
            }

            .price {
                margin: 0 0 16px;
                font-size: 18px;
                font-weight: 800;
                color: #00695c;
            }

            .empty {
                padding: 28px;
                border: 1px solid #e0e3e7;
                border-radius: 12px;
                background: #fff;
                color: #5f6368;
            }

            .pagination {
                display: flex;
                justify-content: center;
                gap: 10px;
                flex-wrap: wrap;
                margin-top: 26px;
            }

            .pagination form,
            .destination-bar form,
            .actions form {
                margin: 0;
            }

            .page-button.active {
                background: #00796b;
                color: #fff;
                border-color: #00796b;
            }

            @media (max-width: 760px) {
                .toolbar,
                .search-form,
                .topbar {
                    grid-template-columns: 1fr;
                    display: grid;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <div class="topbar">
                <div class="brand">Travel Project</div>
                <nav class="nav-links">
                    <a class="nav-link active" href="<%= request.getContextPath()%>/tours">Khách hàng</a>
                    <a class="nav-link" href="<%= request.getContextPath()%>/staff/bookings">Staff Booking</a>
                    <a class="nav-link" href="<%= request.getContextPath()%>/admin/tours">Admin Tour</a>
                </nav>
            </div>

            <section class="hero">
                <h1>Chọn tour phù hợp và đặt ngay trên cùng một luồng</h1>
            </section>

            <% if (pendingBooking != null) { %>
                <section class="pending-banner">
                    <div>
                        <strong>Bạn có booking chưa thanh toán: #<%= pendingBooking.getBookingID()%></strong><br>
                        Mã thanh toán: <%= h(pendingBooking.getPaymentCode())%> - Tổng tiền: <%= money.format(pendingBooking.getTotalAmount())%>
                    </div>
                    <a class="button" href="<%= request.getContextPath()%>/payment?id=<%= pendingBooking.getBookingID()%>&autoStart=1">Tiếp tục thanh toán</a>
                </section>
            <% } %>

            <section class="toolbar">
                <form class="search-form" action="<%= request.getContextPath()%>/tours" method="get">
                    <div>
                        <label for="keyword">Tìm theo tên tour hoặc điểm đến</label>
                        <input id="keyword" type="text" name="keyword" value="<%= h(keyword)%>" placeholder="Ví dụ: Sapa, Phú Quốc">
                    </div>
                    <div>
                        <label for="destinationSelect">Điểm đến</label>
                        <select id="destinationSelect" name="destination">
                            <option value="">Tất cả điểm đến</option>
                            <% for (String destination : destinations) { %>
                                <option value="<%= h(destination)%>" <%= destination.equals(selectedDestination) ? "selected" : ""%>><%= h(destination)%></option>
                            <% } %>
                        </select>
                    </div>
                    <div>
                        <label>&nbsp;</label>
                        <button class="button" type="submit">Tìm tour</button>
                    </div>
                </form>
                <div class="summary"><%= totalItems%> tour phù hợp</div>
            </section>

            <nav class="destination-bar" aria-label="Lọc nhanh theo điểm đến">
                <form action="<%= request.getContextPath()%>/tours" method="get">
                    <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                    <button class="destination <%= selectedDestination.isEmpty() ? "active" : ""%>" type="submit">Tất cả</button>
                </form>
                <% for (String destination : destinations) { %>
                    <form action="<%= request.getContextPath()%>/tours" method="get">
                        <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                        <input type="hidden" name="destination" value="<%= h(destination)%>">
                        <button class="destination <%= destination.equals(selectedDestination) ? "active" : ""%>" type="submit"><%= h(destination)%></button>
                    </form>
                <% } %>
            </nav>

            <% if (tours.isEmpty()) { %>
                <div class="empty">Chưa có tour phù hợp với bộ lọc hiện tại.</div>
            <% } else { %>
                <section class="grid">
                    <% for (Tour tour : tours) { %>
                        <article class="tour-card">
                            <img src="<%= request.getContextPath()%>/images/<%= h(tour.getImageURL())%>" alt="<%= h(tour.getTourName())%>">
                            <div class="content">
                                <h2><%= h(tour.getTourName())%></h2>
                                <p class="meta">
                                    <strong><%= h(tour.getDestination())%></strong><br>
                                    <%= tour.getDuration()%> ngày · Tối đa <%= tour.getMaxPeople()%> khách<br>
                                    <%= h(tour.getStartDate())%> đến <%= h(tour.getEndDate())%>
                                </p>
                                <p class="price"><%= money.format(tour.getPrice())%></p>
                                <div class="actions">
                                    <form action="<%= request.getContextPath()%>/tour-details" method="get">
                                        <input type="hidden" name="id" value="<%= tour.getTourID()%>">
                                        <button class="button" type="submit">Xem chi tiết và đặt tour</button>
                                    </form>
                                </div>
                            </div>
                        </article>
                    <% } %>
                </section>
            <% } %>

            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                        <form action="<%= request.getContextPath()%>/tours" method="get">
                            <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                            <input type="hidden" name="destination" value="<%= h(selectedDestination)%>">
                            <input type="hidden" name="page" value="<%= currentPage - 1%>">
                            <button class="page-button" type="submit">Trước</button>
                        </form>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <form action="<%= request.getContextPath()%>/tours" method="get">
                            <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                            <input type="hidden" name="destination" value="<%= h(selectedDestination)%>">
                            <input type="hidden" name="page" value="<%= i%>">
                            <button class="page-button <%= i == currentPage ? "active" : ""%>" type="submit"><%= i%></button>
                        </form>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                        <form action="<%= request.getContextPath()%>/tours" method="get">
                            <input type="hidden" name="keyword" value="<%= h(keyword)%>">
                            <input type="hidden" name="destination" value="<%= h(selectedDestination)%>">
                            <input type="hidden" name="page" value="<%= currentPage + 1%>">
                            <button class="page-button" type="submit">Sau</button>
                        </form>
                    <% } %>
                </div>
            <% } %>
        </main>
    </body>
</html>
