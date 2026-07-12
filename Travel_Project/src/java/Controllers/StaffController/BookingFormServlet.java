package Controllers.StaffController;

import DAO.BookingDAO;
import DAO.TourDAO;
import Models.BookingSummary;
import Models.Tour;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "BookingFormServlet", urlPatterns = {"/staff/booking-form"})
public class BookingFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookingSummary booking = new BookingDAO().getSummaryById(parseInt(request.getParameter("id")));
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/staff/bookings");
            return;
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/view/StaffBookingForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int bookingID = parseInt(request.getParameter("bookingID"));
        BookingDAO bookingDAO = new BookingDAO();
        BookingSummary booking = bookingDAO.getSummaryById(bookingID);
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/staff/bookings");
            return;
        }

        String status = safe(request.getParameter("status"));
        int numberOfPeople = parseInt(request.getParameter("numberOfPeople"));
        Map<String, String> errors = new LinkedHashMap<>();

        if (numberOfPeople <= 0) {
            errors.put("numberOfPeople", "So luong khach phai lon hon 0.");
        }
        if (!isAllowedStatus(status)) {
            errors.put("status", "Trang thai booking khong hop le.");
        }

        Tour tour = new TourDAO().getById(booking.getTourID());
        if (tour == null) {
            errors.put("general", "Khong tim thay thong tin tour de cap nhat booking.");
        } else {
            int reservedWithoutCurrent = bookingDAO.getReservedPeopleByTourExcludingBooking(tour.getTourID(), bookingID);
            if (numberOfPeople > 0 && reservedWithoutCurrent + numberOfPeople > tour.getMaxPeople()) {
                errors.put("numberOfPeople", "So cho con lai cua tour khong du de cap nhat booking.");
            }
        }

        if (!errors.isEmpty()) {
            booking.setNumberOfPeople(numberOfPeople > 0 ? numberOfPeople : booking.getNumberOfPeople());
            booking.setStatus(status);
            if (tour != null) {
                booking.setTotalAmount(tour.getPrice().multiply(BigDecimal.valueOf(Math.max(numberOfPeople, 1))));
            }
            request.setAttribute("booking", booking);
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/view/StaffBookingForm.jsp").forward(request, response);
            return;
        }

        BigDecimal totalAmount = tour.getPrice().multiply(BigDecimal.valueOf(numberOfPeople));
        bookingDAO.updateBooking(bookingID, numberOfPeople, totalAmount, status);
        response.sendRedirect(request.getContextPath() + "/staff/bookings?updated=1");
    }

    private boolean isAllowedStatus(String status) {
        return "Chờ thanh toán".equals(status)
                || "Đã thanh toán".equals(status)
                || "Đã xác nhận".equals(status)
                || "Đã hủy".equals(status)
                || "Hoàn tất".equals(status)
                || "Hết hạn".equals(status);
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
