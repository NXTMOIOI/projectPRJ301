package Controllers.CustomerController;

import DAO.BookingDAO;
import DAO.PaymentDAO;
import Models.BookingSummary;
import Utils.SePaySandboxConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "SePayIpnServlet", urlPatterns = {"/payment/sepay-ipn"})
public class SePayIpnServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SePaySandboxConfig config = new SePaySandboxConfig();
        String requestSecret = safe(request.getHeader("X-Secret-Key"));
        if (config.isConfigured() && !config.getSecretKey().equals(requestSecret)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false}");
            return;
        }

        String payload = readBody(request);
        String notificationType = extractValue(payload, "notification_type");
        String paymentCode = extractValue(payload, "order_invoice_number");
        String referenceCode = extractValue(payload, "order_id");
        String transactionId = extractValue(payload, "transaction_id");
        String paymentMethod = extractValue(payload, "payment_method");

        if ("ORDER_PAID".equals(notificationType) && !paymentCode.isEmpty()) {
            BookingSummary booking = new BookingDAO().getByPaymentCode(paymentCode);
            if (booking != null) {
                PaymentDAO paymentDAO = new PaymentDAO();
                if (!paymentDAO.hasPaymentForCode(paymentCode)) {
                    paymentDAO.createSandboxPaymentAndMarkPaid(
                            booking,
                            transactionId.isEmpty() ? referenceCode : transactionId,
                            referenceCode,
                            payload,
                            paymentMethod.isEmpty() ? "SePay Sandbox" : paymentMethod
                    );
                }
            }
        }

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType("application/json");
        response.getWriter().write("{\"success\":true}");
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder builder = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                builder.append(line);
            }
        }
        return builder.toString();
    }

    private String extractValue(String payload, String field) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(field) + "\"\\s*:\\s*\"([^\"]*)\"");
        Matcher matcher = pattern.matcher(payload);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return "";
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
