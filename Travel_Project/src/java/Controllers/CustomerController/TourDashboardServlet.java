package Controllers.CustomerController;

import DAO.TourDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import Models.Tour;

@WebServlet(name = "TourDashboardServlet", urlPatterns = {"/tours"})
public class TourDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String destination = request.getParameter("destination");
        TourDAO toursDAO = new TourDAO();
        List<Tour> allTours = toursDAO.getAll();
        List<Tour> tours;

        if (destination != null && !destination.trim().isEmpty()) {
            destination = destination.trim();
            tours = toursDAO.searchByDestination(destination);
        } else {
            destination = "";
            tours = allTours;
        }

        request.setAttribute("tours", tours);
        request.setAttribute("destinations", getDestinations(allTours));
        request.setAttribute("selectedDestination", destination);
        request.getRequestDispatcher("view/TourDashboardView.jsp").forward(request, response);
    }

    private List<String> getDestinations(List<Tour> tours) {
        Set<String> destinations = new LinkedHashSet<>();
        for (Tour tour : tours) {
            if (tour.getDestination() != null && !tour.getDestination().trim().isEmpty()) {
                destinations.add(tour.getDestination().trim());
            }
        }
        return new ArrayList<>(destinations);
    }
}
