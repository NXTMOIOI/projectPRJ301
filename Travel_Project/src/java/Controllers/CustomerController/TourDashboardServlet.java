package Controllers.CustomerController;

import DAO.BookingDAO;
import DAO.TourDAO;
import Models.BookingSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import Models.Tour;

@WebServlet(name = "TourDashboardServlet", urlPatterns = {"/tours"})
public class TourDashboardServlet extends HttpServlet {

    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        String destination = request.getParameter("destination");
        TourDAO toursDAO = new TourDAO();
        if (keyword == null) {
            keyword = "";
        }
        if (destination == null) {
            destination = "";
        }

        keyword = keyword.trim();
        destination = destination.trim();

        int page = Math.max(parsePage(request.getParameter("page")), 1);
        int totalItems = toursDAO.countTours(keyword, destination);
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * PAGE_SIZE;
        List<Tour> tours = toursDAO.searchTours(keyword, destination, offset, PAGE_SIZE);
        loadPendingBooking(request);

        request.setAttribute("tours", tours);
        request.setAttribute("destinations", toursDAO.getDestinations());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedDestination", destination);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/view/TourDashboardView.jsp").forward(request, response);
    }

    private void loadPendingBooking(HttpServletRequest request) {
        Object pendingIdObj = request.getSession().getAttribute(PaymentPageServlet.PENDING_BOOKING_SESSION_KEY);
        if (!(pendingIdObj instanceof Integer)) {
            return;
        }

        int bookingID = (Integer) pendingIdObj;
        BookingDAO bookingDAO = new BookingDAO();
        bookingDAO.markExpiredIfNeeded(bookingID);
        BookingSummary pendingBooking = bookingDAO.getSummaryById(bookingID);

        if (pendingBooking == null
                || !"Chờ thanh toán".equals(pendingBooking.getStatus())
                || bookingDAO.isExpired(pendingBooking)) {
            request.getSession().removeAttribute(PaymentPageServlet.PENDING_BOOKING_SESSION_KEY);
            return;
        }

        request.setAttribute("pendingBooking", pendingBooking);
    }

    private int parsePage(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return 1;
        }
    }
}
