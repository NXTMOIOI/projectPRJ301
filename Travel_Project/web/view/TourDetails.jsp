<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
<%@page import="Models.Itinerary"%>
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
    Tour tour = (Tour) request.getAttribute("tour");
    List<Itinerary> itineraries = (List<Itinerary>) request.getAttribute("itineraries");
    if (itineraries == null) {
        itineraries = new ArrayList<>();
    }

    Map<String, String> bookingForm = (Map<String, String>) request.getAttribute("bookingForm");
    if (bookingForm == null) {
        bookingForm = new LinkedHashMap<>();
    }

    Map<String, String> bookingErrors = (Map<String, String>) request.getAttribute("bookingErrors");
    if (bookingErrors == null) {
        bookingErrors = new LinkedHashMap<>();
    }

    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tour Details</title>
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
                margin-bottom: 18px;
                flex-wrap: wrap;
            }

            .nav-links {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .nav-link,
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
                cursor: pointer;
            }

            .nav-link:hover,
            .back:hover {
                border-color: #00796b;
                background: #e6f4f1;
                color: #00574d;
            }

            form {
                margin: 0;
            }

            .detail {
                overflow: hidden;
                border: 1px solid #e0e3e7;
                border-radius: 14px;
                background: #fff;
            }

            .hero {
                display: grid;
                grid-template-columns: minmax(0, 1.1fr) minmax(320px, .9fr);
            }

            .hero img {
                width: 100%;
                height: 100%;
                min-height: 380px;
                object-fit: cover;
                display: block;
                background: #dde3ea;
            }

            .summary {
                padding: 30px;
            }

            .summary h1 {
                margin: 0 0 10px;
                font-size: 34px;
                line-height: 1.2;
            }

            .destination {
                margin: 0 0 22px;
                color: #5f6368;
                font-size: 18px;
            }

            .facts {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 12px;
                margin-bottom: 24px;
            }

            .fact {
                padding: 12px;
                border: 1px solid #e6e9ed;
                border-radius: 8px;
                background: #fafbfc;
            }

            .label {
                display: block;
                margin-bottom: 5px;
                color: #6b7280;
                font-size: 13px;
            }

            .value {
                font-weight: 700;
            }

            .price {
                margin: 0 0 14px;
                color: #00695c;
                font-size: 28px;
                font-weight: 800;
            }

            .section {
                padding: 28px 30px 32px;
                border-top: 1px solid #e0e3e7;
            }

            .section h2 {
                margin: 0 0 16px;
                font-size: 24px;
            }

            .itinerary {
                display: grid;
                grid-template-columns: 92px 1fr;
                gap: 16px;
                padding: 14px 0;
                border-top: 1px solid #eef1f4;
            }

            .itinerary:first-of-type {
                border-top: 0;
            }

            .day {
                font-weight: 800;
                color: #00796b;
            }

            .booking-grid {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 16px;
            }

            .field.full {
                grid-column: 1 / -1;
            }

            .field label {
                display: block;
                margin-bottom: 6px;
                font-size: 13px;
                font-weight: 700;
                color: #5f6368;
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

            .actions {
                display: flex;
                gap: 12px;
                align-items: center;
                flex-wrap: wrap;
                margin-top: 18px;
            }

            .button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 42px;
                padding: 10px 18px;
                border: 0;
                border-radius: 8px;
                background: #00796b;
                color: #fff;
                font: inherit;
                font-weight: 700;
                cursor: pointer;
            }

            .error-box {
                margin-bottom: 18px;
                padding: 14px 16px;
                border: 1px solid #f3c2c2;
                border-radius: 10px;
                background: #fff3f3;
                color: #a33a3a;
            }

            .error-text {
                margin-top: 6px;
                color: #b42318;
                font-size: 13px;
            }

            @media (max-width: 820px) {
                .hero,
                .booking-grid {
                    grid-template-columns: 1fr;
                }

                .hero img {
                    min-height: 250px;
                }

                .facts {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <div class="topbar">
                <form action="<%= request.getContextPath()%>/tours" method="get">
                    <button class="back" type="submit">Quay lại danh sách tour</button>
                </form>
                <nav class="nav-links">
                    <a class="nav-link" href="<%= request.getContextPath()%>/staff/bookings">Staff Booking</a>
                    <a class="nav-link" href="<%= request.getContextPath()%>/admin/tours">Admin Tour</a>
                </nav>
            </div>

            <% if (tour == null) { %>
                <p>Tour details are not available.</p>
            <% } else { %>
                <article class="detail">
                    <section class="hero">
                        <img src="<%= request.getContextPath()%>/images/<%= h(tour.getImageURL())%>" alt="<%= h(tour.getTourName())%>">
                        <div class="summary">
                            <h1><%= h(tour.getTourName())%></h1>
                            <p class="destination"><%= h(tour.getDestination())%></p>

                            <div class="facts">
                                <div class="fact">
                                    <span class="label">Thời lượng</span>
                                    <span class="value"><%= tour.getDuration()%> ngày</span>
                                </div>
                                <div class="fact">
                                    <span class="label">Sức chứa tối đa</span>
                                    <span class="value"><%= tour.getMaxPeople()%> khách</span>
                                </div>
                                <div class="fact">
                                    <span class="label">Khởi hành</span>
                                    <span class="value"><%= h(tour.getStartDate())%></span>
                                </div>
                                <div class="fact">
                                    <span class="label">Kết thúc</span>
                                    <span class="value"><%= h(tour.getEndDate())%></span>
                                </div>
                            </div>

                            <p class="price"><%= money.format(tour.getPrice())%></p>
                        </div>
                    </section>

                    <section class="section">
                        <h2>Lịch trình</h2>
                        <% if (itineraries.isEmpty()) { %>
                            <p>Chưa có lịch trình chi tiết cho tour này.</p>
                        <% } else { %>
                            <% for (Itinerary itinerary : itineraries) { %>
                                <div class="itinerary">
                                    <div class="day">Ngày <%= itinerary.getDayNumber()%></div>
                                    <div><%= h(itinerary.getActivities())%></div>
                                </div>
                            <% } %>
                        <% } %>
                    </section>

                    <section class="section">
                        <h2>Đặt tour</h2>

                        <% if (!bookingErrors.isEmpty()) { %>
                            <div class="error-box">
                                Vui lòng kiểm tra lại thông tin đặt tour trước khi tiếp tục.
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath()%>/book-tour" method="post">
                            <input type="hidden" name="tourID" value="<%= tour.getTourID()%>">
                            <div class="booking-grid">
                                <div class="field">
                                    <label for="fullName">Họ và tên</label>
                                    <input id="fullName" type="text" name="fullName" value="<%= h(bookingForm.get("fullName"))%>">
                                    <% if (bookingErrors.get("fullName") != null) { %>
                                        <div class="error-text"><%= h(bookingErrors.get("fullName"))%></div>
                                    <% } %>
                                </div>
                                <div class="field">
                                    <label for="phone">Số điện thoại</label>
                                    <input id="phone" type="text" name="phone" value="<%= h(bookingForm.get("phone"))%>">
                                    <% if (bookingErrors.get("phone") != null) { %>
                                        <div class="error-text"><%= h(bookingErrors.get("phone"))%></div>
                                    <% } %>
                                </div>
                                <div class="field">
                                    <label for="email">Email</label>
                                    <input id="email" type="text" name="email" value="<%= h(bookingForm.get("email"))%>">
                                    <% if (bookingErrors.get("email") != null) { %>
                                        <div class="error-text"><%= h(bookingErrors.get("email"))%></div>
                                    <% } %>
                                </div>
                                <div class="field">
                                    <label for="numberOfPeople">Số khách</label>
                                    <input id="numberOfPeople" type="number" name="numberOfPeople" min="1" max="<%= tour.getMaxPeople()%>" value="<%= h(bookingForm.get("numberOfPeople"))%>">
                                    <% if (bookingErrors.get("numberOfPeople") != null) { %>
                                        <div class="error-text"><%= h(bookingErrors.get("numberOfPeople"))%></div>
                                    <% } %>
                                </div>
                                <div class="field">
                                    <label for="dateOfBirth">Ngày sinh</label>
                                    <input id="dateOfBirth" type="date" name="dateOfBirth" value="<%= h(bookingForm.get("dateOfBirth"))%>">
                                    <% if (bookingErrors.get("dateOfBirth") != null) { %>
                                        <div class="error-text"><%= h(bookingErrors.get("dateOfBirth"))%></div>
                                    <% } %>
                                </div>
                                <div class="field full">
                                    <label for="address">Địa chỉ</label>
                                    <input id="address" type="text" name="address" value="<%= h(bookingForm.get("address"))%>">
                                </div>
                                <div class="field full">
                                    <label for="cccd">CCCD</label>
                                    <input id="cccd" type="text" name="cccd" value="<%= h(bookingForm.get("cccd"))%>">
                                </div>
                            </div>

                            <div class="actions">
                                <button class="button" type="submit">Tạo booking</button>
                            </div>
                        </form>
                    </section>
                </article>
            <% } %>
        </main>
    </body>
</html>
