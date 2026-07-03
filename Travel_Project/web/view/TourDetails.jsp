<%-- 
    Document   : tour-details
    Created on : Jun 21, 2026, 9:52:36 PM
    Author     : Admin
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
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
                max-width: 1040px;
                margin: 0 auto;
                padding: 32px 20px 48px;
            }

            .back {
                display: inline-flex;
                margin-bottom: 18px;
                border: 0;
                background: transparent;
                color: #00796b;
                font-weight: 700;
                text-decoration: none;
                font-family: inherit;
                font-size: 16px;
                cursor: pointer;
            }

            form {
                margin: 0;
            }

            .detail {
                overflow: hidden;
                border: 1px solid #e0e3e7;
                border-radius: 8px;
                background: #fff;
            }

            .hero {
                display: grid;
                grid-template-columns: minmax(0, 1.1fr) minmax(300px, .9fr);
                gap: 0;
            }

            .hero img {
                width: 100%;
                height: 100%;
                min-height: 360px;
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
                line-height: 1.15;
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
                border-radius: 6px;
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
                margin: 0;
                color: #00695c;
                font-size: 26px;
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

            @media (max-width: 760px) {
                .hero {
                    grid-template-columns: 1fr;
                }

                .hero img {
                    min-height: 240px;
                }

                .facts {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <form action="<%= request.getContextPath()%>/tours" method="get">
                <button class="back" type="submit">Back to tours</button>
            </form>

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
                                    <span class="label">Duration</span>
                                    <span class="value"><%= tour.getDuration()%> days</span>
                                </div>
                                <div class="fact">
                                    <span class="label">Max people</span>
                                    <span class="value"><%= tour.getMaxPeople()%></span>
                                </div>
                                <div class="fact">
                                    <span class="label">Start date</span>
                                    <span class="value"><%= h(tour.getStartDate())%></span>
                                </div>
                                <div class="fact">
                                    <span class="label">End date</span>
                                    <span class="value"><%= h(tour.getEndDate())%></span>
                                </div>
                            </div>

                            <p class="price"><%= money.format(tour.getPrice())%></p>
                        </div>
                    </section>

                    <section class="section">
                        <h2>Itinerary</h2>
                        <% if (itineraries.isEmpty()) { %>
                            <p>No itinerary has been added for this tour.</p>
                        <% } else { %>
                            <% for (Itinerary itinerary : itineraries) {%>
                                <div class="itinerary">
                                    <div class="day">Day <%= itinerary.getDayNumber()%></div>
                                    <div><%= h(itinerary.getActivities())%></div>
                                </div>
                            <% } %>
                        <% } %>
                    </section>
                </article>
            <% } %>
        </main>
    </body>
</html>
