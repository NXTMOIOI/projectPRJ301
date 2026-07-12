package Controllers.StaffController;

import DAO.BookingDAO;
import Models.BookingSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingManagementServlet", urlPatterns = {"/staff/bookings"})
public class BookingManagementServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String keyword = safe(request.getParameter("keyword"));
        String status = safe(request.getParameter("status"));
        int page = Math.max(parseInt(request.getParameter("page")), 1);
        int offset = (page - 1) * PAGE_SIZE;

        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.expirePendingBookings();
        int totalItems = bookingDAO.countBookings(keyword, status);
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
            offset = (page - 1) * PAGE_SIZE;
        }

        List<BookingSummary> bookings = bookingDAO.searchBookings(keyword, status, offset, PAGE_SIZE);
        request.setAttribute("bookings", bookings);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pendingCount", bookingDAO.countByStatus("Chờ thanh toán"));
        request.setAttribute("paidCount", bookingDAO.countByStatus("Đã thanh toán"));
        request.setAttribute("confirmedCount", bookingDAO.countByStatus("Đã xác nhận"));
        request.setAttribute("cancelledCount", bookingDAO.countByStatus("Đã hủy"));
        request.setAttribute("expiredCount", bookingDAO.countByStatus("Hết hạn"));
        request.getRequestDispatcher("/view/StaffBookingManagement.jsp").forward(request, response);
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return 1;
        }
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}
