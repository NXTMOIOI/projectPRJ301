package Controllers.AdminController;

import DAO.TourDAO;
import Models.Tour;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "TourManagementServlet", urlPatterns = {"/admin/tours"})
public class TourManagementServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        TourDAO tourDAO = new TourDAO();
        String keyword = safe(request.getParameter("keyword"));
        String destination = safe(request.getParameter("destination"));
        int page = Math.max(parseInt(request.getParameter("page")), 1);
        int offset = (page - 1) * PAGE_SIZE;

        int totalItems = tourDAO.countTours(keyword, destination);
        int totalPages = Math.max(1, (int) Math.ceil(totalItems / (double) PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
            offset = (page - 1) * PAGE_SIZE;
        }

        List<Tour> tours = tourDAO.searchTours(keyword, destination, offset, PAGE_SIZE);
        List<Tour> allTours = new ArrayList<>(tourDAO.getAll());

        request.setAttribute("tours", tours);
        request.setAttribute("destinations", tourDAO.getDestinations());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedDestination", destination);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("upcomingCount", countUpcomingTours(allTours));
        request.setAttribute("destinationCount", tourDAO.getDestinations().size());
        request.setAttribute("allTourCount", allTours.size());
        request.getRequestDispatcher("/view/AdminTourManagement.jsp").forward(request, response);
    }

    private int countUpcomingTours(List<Tour> tours) {
        Date today = new Date(System.currentTimeMillis());
        int count = 0;
        for (Tour tour : tours) {
            if (tour.getStartDate() != null && !tour.getStartDate().before(today)) {
                count++;
            }
        }
        return count;
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
