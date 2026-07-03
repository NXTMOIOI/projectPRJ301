<%-- 
    Document   : tour-show
    Created on : Jun 21, 2026, 9:51:41 PM
    Author     : Admin
--%>

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

    String selectedDestination = (String) request.getAttribute("selectedDestination");
    if (selectedDestination == null) {
        selectedDestination = "";
    }

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
                padding: 32px 20px 48px;
            }

            .header {
                display: flex;
                justify-content: space-between;
                gap: 24px;
                align-items: flex-end;
                margin-bottom: 24px;
            }

            .header h1 {
                margin: 0 0 8px;
                font-size: 32px;
            }

            .header p {
                margin: 0;
                color: #5f6368;
            }

            .destination-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-bottom: 28px;
            }

            .destination {
                display: inline-flex;
                align-items: center;
                min-height: 38px;
                padding: 8px 14px;
                border: 1px solid #d7dce2;
                border-radius: 6px;
                color: #263238;
                background: #fff;
                text-decoration: none;
                font-weight: 600;
                cursor: pointer;
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
                border-radius: 8px;
                background: #fff;
            }

            .tour-card img {
                width: 100%;
                height: 170px;
                object-fit: cover;
                display: block;
                background: #dde3ea;
            }

            .tour-card .content {
                padding: 16px;
            }

            .tour-card h2 {
                margin: 0 0 8px;
                font-size: 20px;
                line-height: 1.25;
            }

            .meta {
                margin: 0 0 12px;
                color: #5f6368;
                line-height: 1.5;
            }

            .price {
                margin: 0 0 16px;
                font-size: 18px;
                font-weight: 700;
                color: #00695c;
            }

            .actions {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            form {
                margin: 0;
            }

            .button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 38px;
                padding: 8px 13px;
                border-radius: 6px;
                border: 0;
                background: #00796b;
                color: #fff;
                text-decoration: none;
                font-weight: 700;
                font-family: inherit;
                font-size: 14px;
                cursor: pointer;
            }

            .button.secondary {
                background: #eef1f4;
                color: #263238;
            }

            .empty {
                padding: 28px;
                border: 1px solid #e0e3e7;
                border-radius: 8px;
                background: #fff;
                color: #5f6368;
            }
        </style>
    </head>
    <body>
        <main class="page">
            <section class="header">
                <div>
                    <h1>Your Journey Starts Here</h1>
                    <p>Choose a destination to review available tours.</p>
                </div>
                <strong><%= tours.size()%> tour(s)</strong>
            </section>

            <nav class="destination-bar" aria-label="Tour destinations">
                <form action="<%= request.getContextPath()%>/tours" method="get">
                    <button class="destination <%= selectedDestination.isEmpty() ? "active" : ""%>" type="submit">All destinations</button>
                </form>
                <% for (String destination : destinations) {%>
                    <form action="<%= request.getContextPath()%>/tours" method="get">
                        <input type="hidden" name="destination" value="<%= h(destination)%>">
                        <button class="destination <%= destination.equals(selectedDestination) ? "active" : ""%>" type="submit"><%= h(destination)%></button>
                    </form>
                <% } %>
            </nav>

            <% if (tours.isEmpty()) { %>
                <div class="empty">No tours found for this destination.</div>
            <% } else { %>
                <section class="grid">
                    <% for (Tour tour : tours) {%>
                        <article class="tour-card">
                            <img src="<%= request.getContextPath()%>/images/<%= h(tour.getImageURL())%>" alt="<%= h(tour.getTourName())%>">
                            <div class="content">
                                <h2><%= h(tour.getTourName())%></h2>
                                <p class="meta">
                                    <strong><%= h(tour.getDestination())%></strong><br>
                                    <%= tour.getDuration()%> days · Max <%= tour.getMaxPeople()%> people<br>
                                    <%= h(tour.getStartDate())%> to <%= h(tour.getEndDate())%>
                                </p>
                                <p class="price"><%= money.format(tour.getPrice())%></p>
                                <div class="actions">
                                    <form action="<%= request.getContextPath()%>/tour-details" method="get">
                                        <input type="hidden" name="id" value="<%= tour.getTourID()%>">
                                        <button class="button" type="submit">View details</button>
                                    </form>
                                </div>
                            </div>
                        </article>
                    <% } %>
                </section>
            <% } %>
        </main>
    </body>
</html>
