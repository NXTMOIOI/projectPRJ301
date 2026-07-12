<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
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
    if (tour == null) {
        tour = new Tour();
    }
    String formMode = (String) request.getAttribute("formMode");
    if (formMode == null) {
        formMode = "create";
    }
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    if (errors == null) {
        errors = new LinkedHashMap<>();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tour Form</title>
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: #f7f8fa;
                color: #202124;
            }
            .page {
                max-width: 940px;
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
            .grid {
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
                color: #5f6368;
                font-weight: 700;
            }
            .field input {
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
                margin-top: 22px;
            }
            .button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 42px;
                padding: 10px 16px;
                border-radius: 8px;
                border: 0;
                background: #00796b;
                color: #fff;
                font: inherit;
                font-weight: 700;
                cursor: pointer;
            }
            @media (max-width: 760px) {
                .grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <a class="back" href="<%= request.getContextPath()%>/admin/tours">Quay lại danh sách tour</a>

            <div class="card">
                <h1><%= "edit".equals(formMode) ? "Cập nhật tour" : "Thêm tour mới"%></h1>
                <p>Form này bám đúng cấu trúc hiện tại của bảng `Tours`, không nhồi thêm trường ngoài schema.</p>

                <% if (!errors.isEmpty()) { %>
                    <div class="error-box">Vui lòng kiểm tra lại thông tin tour trước khi lưu.</div>
                <% } %>

                <form action="<%= request.getContextPath()%>/admin/tour-form" method="post">
                    <input type="hidden" name="tourID" value="<%= tour.getTourID()%>">
                    <div class="grid">
                        <div class="field full">
                            <label for="tourName">Tên tour</label>
                            <input id="tourName" type="text" name="tourName" value="<%= h(tour.getTourName())%>">
                            <% if (errors.get("tourName") != null) { %>
                                <div class="error-text"><%= h(errors.get("tourName"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="destination">Điểm đến</label>
                            <input id="destination" type="text" name="destination" value="<%= h(tour.getDestination())%>">
                            <% if (errors.get("destination") != null) { %>
                                <div class="error-text"><%= h(errors.get("destination"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="imageURL">Tên file ảnh</label>
                            <input id="imageURL" type="text" name="imageURL" value="<%= h(tour.getImageURL())%>" placeholder="sapa.jpg">
                            <% if (errors.get("imageURL") != null) { %>
                                <div class="error-text"><%= h(errors.get("imageURL"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="duration">Số ngày</label>
                            <input id="duration" type="number" name="duration" min="1" value="<%= tour.getDuration() == 0 ? "" : tour.getDuration()%>">
                            <% if (errors.get("duration") != null) { %>
                                <div class="error-text"><%= h(errors.get("duration"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="price">Giá tour</label>
                            <input id="price" type="number" name="price" min="0" step="1000" value="<%= h(tour.getPrice())%>">
                            <% if (errors.get("price") != null) { %>
                                <div class="error-text"><%= h(errors.get("price"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="maxPeople">Sức chứa tối đa</label>
                            <input id="maxPeople" type="number" name="maxPeople" min="1" value="<%= tour.getMaxPeople() == 0 ? "" : tour.getMaxPeople()%>">
                            <% if (errors.get("maxPeople") != null) { %>
                                <div class="error-text"><%= h(errors.get("maxPeople"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="startDate">Ngày khởi hành</label>
                            <input id="startDate" type="date" name="startDate" value="<%= tour.getStartDate() == null ? "" : tour.getStartDate()%>">
                            <% if (errors.get("startDate") != null) { %>
                                <div class="error-text"><%= h(errors.get("startDate"))%></div>
                            <% } %>
                        </div>

                        <div class="field">
                            <label for="endDate">Ngày kết thúc</label>
                            <input id="endDate" type="date" name="endDate" value="<%= tour.getEndDate() == null ? "" : tour.getEndDate()%>">
                            <% if (errors.get("endDate") != null) { %>
                                <div class="error-text"><%= h(errors.get("endDate"))%></div>
                            <% } %>
                        </div>
                    </div>

                    <div class="actions">
                        <button class="button" type="submit"><%= "edit".equals(formMode) ? "Lưu cập nhật" : "Tạo tour"%></button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>
