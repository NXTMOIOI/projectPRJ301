package Controllers.CustomerController;

import DAO.BookingDAO;
import DAO.PaymentDAO;
import Models.BookingSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SePayReturnServlet", urlPatterns = {"/payment/sepay-return"})
public class SePayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = parseInt(request.getParameter("id"));
        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        String gatewayResult = safe(request.getParameter("gatewayResult"));
        persistDemoPaymentIfNeeded(bookingID, gatewayResult);
        response.sendRedirect(request.getContextPath() + "/payment?id=" + bookingID + "&gatewayResult=" + gatewayResult);
    }

    private void persistDemoPaymentIfNeeded(int bookingID, String gatewayResult) {
        if (!"success".equalsIgnoreCase(gatewayResult)) {
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.markExpiredIfNeeded(bookingID);
        BookingSummary booking = bookingDAO.getSummaryById(bookingID);
        if (booking == null
                || !"Chờ thanh toán".equals(booking.getStatus())
                || bookingDAO.isExpired(booking)) {
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        if (paymentDAO.hasPaymentForCode(booking.getPaymentCode())) {
            return;
        }

        String referenceCode = "SEPAY-RETURN-" + bookingID + "-" + System.currentTimeMillis();
        paymentDAO.createSandboxPaymentAndMarkPaid(
                booking,
                referenceCode,
                referenceCode,
                "Payment confirmed from SePay return URL",
                "SePay Sandbox"
        );
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
