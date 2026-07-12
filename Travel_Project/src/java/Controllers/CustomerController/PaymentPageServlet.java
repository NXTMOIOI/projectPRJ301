package Controllers.CustomerController;

import DAO.BookingDAO;
import DAO.PaymentDAO;
import Models.BookingSummary;
import Models.Payment;
import Utils.SePayCheckoutSigner;
import Utils.SePaySandboxConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.RoundingMode;
import java.util.Map;

@WebServlet(name = "PaymentPageServlet", urlPatterns = {"/payment"})
public class PaymentPageServlet extends HttpServlet {

    public static final String PENDING_BOOKING_SESSION_KEY = "pendingBookingId";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingID = parseInt(request.getParameter("id"));
        if (bookingID <= 0) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.markExpiredIfNeeded(bookingID);
        BookingSummary booking = bookingDAO.getSummaryById(bookingID);
        if (booking == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }

        boolean expired = bookingDAO.isExpired(booking) && "Chờ thanh toán".equals(booking.getStatus());
        if ("Chờ thanh toán".equals(booking.getStatus()) && !expired) {
            request.getSession().setAttribute(PENDING_BOOKING_SESSION_KEY, booking.getBookingID());
        } else {
            request.getSession().removeAttribute(PENDING_BOOKING_SESSION_KEY);
        }

        Payment payment = new PaymentDAO().getByBookingId(bookingID);
        SePaySandboxConfig config = new SePaySandboxConfig();

        request.setAttribute("booking", booking);
        request.setAttribute("payment", payment);
        request.setAttribute("expired", expired);
        request.setAttribute("sepayConfigured", config.isConfigured());
        request.setAttribute("checkoutUrl", config.getCheckoutUrl());
        request.setAttribute("publicBaseUrl", config.resolveAppBaseUrl(request));
        request.setAttribute("gatewayResult", safe(request.getParameter("gatewayResult")));

        if (config.isConfigured() && "Chờ thanh toán".equals(booking.getStatus()) && !expired) {
            request.setAttribute("checkoutFields", buildCheckoutFields(request, booking, config));
            request.setAttribute("autoSubmitCheckout", shouldAutoSubmit(request, payment));
        }

        request.getRequestDispatcher("/view/PaymentDemo.jsp").forward(request, response);
    }

    private Map<String, String> buildCheckoutFields(HttpServletRequest request, BookingSummary booking, SePaySandboxConfig config) {
        String appBaseUrl = config.resolveAppBaseUrl(request);
        String bookingId = String.valueOf(booking.getBookingID());
        String successUrl = appBaseUrl + "/payment/sepay-return?id=" + bookingId + "&gatewayResult=success";
        String errorUrl = appBaseUrl + "/payment/sepay-return?id=" + bookingId + "&gatewayResult=error";
        String cancelUrl = appBaseUrl + "/payment/sepay-return?id=" + bookingId + "&gatewayResult=cancel";
        String orderAmount = booking.getTotalAmount().setScale(0, RoundingMode.HALF_UP).toPlainString();
        String description = "Thanh toan booking " + booking.getPaymentCode();

        return new SePayCheckoutSigner().buildCheckoutFields(
                config.getMerchantId(),
                config.getSecretKey(),
                orderAmount,
                description,
                booking.getPaymentCode(),
                String.valueOf(booking.getCustomerID()),
                successUrl,
                errorUrl,
                cancelUrl,
                "BANK_TRANSFER"
        );
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    private boolean shouldAutoSubmit(HttpServletRequest request, Payment payment) {
        return "1".equals(request.getParameter("autoStart"))
                && payment == null
                && safe(request.getParameter("gatewayResult")).isEmpty();
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
