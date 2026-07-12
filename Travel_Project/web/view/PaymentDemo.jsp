<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Map"%>
<%@page import="Models.BookingSummary"%>
<%@page import="Models.Payment"%>
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
    Payment payment = (Payment) request.getAttribute("payment");
    Boolean expired = (Boolean) request.getAttribute("expired");
    boolean isExpired = expired != null && expired;
    Boolean sepayConfiguredObj = (Boolean) request.getAttribute("sepayConfigured");
    boolean sepayConfigured = sepayConfiguredObj != null && sepayConfiguredObj;
    Boolean autoSubmitCheckoutObj = (Boolean) request.getAttribute("autoSubmitCheckout");
    boolean autoSubmitCheckout = autoSubmitCheckoutObj != null && autoSubmitCheckoutObj;
    String checkoutUrl = (String) request.getAttribute("checkoutUrl");
    String gatewayResult = (String) request.getAttribute("gatewayResult");
    Map<String, String> checkoutFields = (Map<String, String>) request.getAttribute("checkoutFields");
    if (checkoutFields == null) {
        checkoutFields = Collections.emptyMap();
    }
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateTime = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thanh toán SePay</title>
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: #f7f8fa;
                color: #202124;
            }
            .page {
                max-width: 980px;
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
            .layout {
                display: grid;
                grid-template-columns: minmax(0, 1.2fr) minmax(280px, .8fr);
                gap: 18px;
            }
            .card {
                background: #fff;
                border: 1px solid #e0e3e7;
                border-radius: 16px;
                padding: 24px;
            }
            .provider-box {
                min-height: 220px;
                border-radius: 18px;
                background: linear-gradient(135deg, #0b5d52, #1f8a70);
                color: #fff;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-align: center;
                padding: 24px;
            }
            .provider-box strong {
                font-size: 32px;
                letter-spacing: .06em;
            }
            .meta {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 14px;
                margin-top: 18px;
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
            }
            .value {
                font-weight: 700;
            }
            .notice {
                margin-top: 18px;
                padding: 14px 16px;
                border-radius: 12px;
                font-weight: 700;
                line-height: 1.6;
            }
            .warning {
                background: #fff6e5;
                color: #8a5b00;
            }
            .success {
                background: #eef8f6;
                color: #135b52;
            }
            .danger {
                background: #fff3f3;
                color: #a33a3a;
            }
            .actions {
                display: flex;
                gap: 12px;
                margin-top: 20px;
                flex-wrap: wrap;
            }
            .button,
            .secondary {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 42px;
                padding: 10px 16px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 700;
                font: inherit;
                cursor: pointer;
            }
            .button {
                border: 0;
                background: #00796b;
                color: #fff;
            }
            .secondary {
                border: 1px solid #d7dce2;
                background: #fff;
                color: #263238;
            }
            .button[disabled] {
                opacity: .55;
                cursor: not-allowed;
            }
            .status-pill {
                display: inline-flex;
                padding: 6px 10px;
                border-radius: 999px;
                background: #eef8f6;
                color: #135b52;
                font-weight: 700;
            }
            code {
                padding: 2px 6px;
                border-radius: 6px;
                background: #f1f5f9;
                font-family: Consolas, monospace;
                font-size: 13px;
            }
            @media (max-width: 820px) {
                .layout,
                .meta {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <main class="page">
            <a class="back" href="<%= request.getContextPath()%>/tours">Quay lại xem tour</a>

            <% if (booking == null) { %>
                <div class="card">
                    <h1>Không tìm thấy booking</h1>
                </div>
            <% } else { %>
                <div class="layout">
                    <section class="card">
                        <h1>Thanh toán với SePay Sandbox</h1>
                        <p>Booking #<%= booking.getBookingID()%> - <strong><%= h(booking.getTourName())%></strong></p>

                        <div class="provider-box">
                            <span>SEPAY SANDBOX</span>
                            <strong><%= h(booking.getPaymentCode())%></strong>
                            <span><%= money.format(booking.getTotalAmount())%></span>
                        </div>

                        <div class="meta">
                            <div class="meta-item">
                                <span class="label">Khách hàng</span>
                                <span class="value"><%= h(booking.getCustomerName())%></span>
                            </div>
                            <div class="meta-item">
                                <span class="label">Trạng thái</span>
                                <span class="value"><span class="status-pill"><%= h(booking.getStatus())%></span></span>
                            </div>
                            <div class="meta-item">
                                <span class="label">Số tiền</span>
                                <span class="value"><%= money.format(booking.getTotalAmount())%></span>
                            </div>
                            <div class="meta-item">
                                <span class="label">Hết hạn lúc</span>
                                <span class="value"><%= booking.getPaymentExpiredAt() == null ? "" : h(dateTime.format(booking.getPaymentExpiredAt()))%></span>
                            </div>
                        </div>

                        <% if (autoSubmitCheckout) { %>
                            <div class="notice warning">
                                Đang chuyển sang cổng thanh toán SePay.
                            </div>
                        <% } else if ("Đã thanh toán".equals(booking.getStatus()) || "Đã xác nhận".equals(booking.getStatus())) { %>
                            <div class="notice success">
                                Thanh toán đã được SePay ghi nhận thành công.
                            </div>
                        <% } else if ("success".equals(gatewayResult)) { %>
                            <div class="notice warning">
                                Chờ kiểm tra thanh toán trong giây lát.
                            </div>
                        <% } else if ("cancel".equals(gatewayResult)) { %>
                            <div class="notice warning">
                                Bạn đã hủy thanh toán trên SePay. Booking vẫn được giữ ở trạng thái chờ thanh toán nếu chưa quá hạn.
                            </div>
                        <% } else if ("error".equals(gatewayResult)) { %>
                            <div class="notice danger">
                                SePay trả về trạng thái lỗi. Bạn có thể thử thanh toán lại nếu booking chưa hết hạn.
                            </div>
                        <% } else if ("Hết hạn".equals(booking.getStatus()) || isExpired) { %>
                            <div class="notice danger">
                                Phiên thanh toán này đã hết hạn.
                            </div>
                        <% } else if (!sepayConfigured) { %>
                            <div class="notice warning">
                                Chưa cấu hình SePay sandbox. Điền <code>merchantId</code>, <code>secretKey</code> và <code>appBaseUrl</code>
                                trong file <code>src/java/SePaySandbox.properties</code> rồi chạy lại.
                            </div>
                        <% } %>

                        <div class="actions">
                            <% if (sepayConfigured && "Chờ thanh toán".equals(booking.getStatus()) && !isExpired && !checkoutFields.isEmpty()) { %>
                                <form id="sepayCheckoutForm" action="<%= h(checkoutUrl)%>" method="post">
                                    <% for (Map.Entry<String, String> field : checkoutFields.entrySet()) { %>
                                        <input type="hidden" name="<%= h(field.getKey())%>" value="<%= h(field.getValue())%>">
                                    <% } %>
                                    <button class="button" type="submit"><%= autoSubmitCheckout ? "Nếu chưa chuyển, bấm vào đây" : "Thanh toán với SePay Sandbox"%></button>
                                </form>
                            <% } %>
                            <a class="secondary" href="<%= request.getContextPath()%>/tours">Quay lại xem tour</a>
                        </div>
                    </section>

                    <aside class="card">
                        <h2>Thông tin thanh toán</h2>
                        <div class="meta" style="grid-template-columns: 1fr;">
                            <div class="meta-item">
                                <span class="label">Mã booking / invoice</span>
                                <span class="value"><%= h(booking.getPaymentCode())%></span>
                            </div>
                            <div class="meta-item">
                                <span class="label">Kết quả cổng thanh toán</span>
                                <span class="value">
                                    <%= "success".equals(gatewayResult) ? "Đã trả về thành công" : ("cancel".equals(gatewayResult) ? "Đã hủy" : ("error".equals(gatewayResult) ? "Báo lỗi" : "Chưa có kết quả"))%>
                                </span>
                            </div>
                            <% if (payment != null) { %>
                                <div class="meta-item">
                                    <span class="label">Mã tham chiếu SePay</span>
                                    <span class="value"><%= h(payment.getReferenceCode())%></span>
                                </div>
                                <div class="meta-item">
                                    <span class="label">Phương thức</span>
                                    <span class="value"><%= h(payment.getPaymentMethod())%></span>
                                </div>
                                <div class="meta-item">
                                    <span class="label">Ngày ghi nhận</span>
                                    <span class="value"><%= payment.getPaymentDate() == null ? "" : h(payment.getPaymentDate())%></span>
                                </div>
                            <% } else { %>
                                <div class="meta-item">
                                    <span class="label">Ghi nhận giao dịch</span>
                                    <span class="value">Chưa có giao dịch được lưu.</span>
                                </div>
                            <% } %>
                        </div>
                    </aside>
                </div>
            <% } %>
        </main>
        <% if (autoSubmitCheckout && !checkoutFields.isEmpty()) { %>
            <script>
                window.addEventListener("load", function () {
                    var form = document.getElementById("sepayCheckoutForm");
                    if (form) {
                        form.submit();
                    }
                });
            </script>
        <% } %>
    </body>
</html>
