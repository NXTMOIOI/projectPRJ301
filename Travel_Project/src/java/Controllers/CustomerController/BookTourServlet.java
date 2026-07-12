package Controllers.CustomerController;

import DAO.BookingDAO;
import DAO.IniteraryDAO;
import DAO.TourDAO;
import Models.Customer;
import Models.Tour;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "BookTourServlet", urlPatterns = {"/book-tour"})
public class BookTourServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int tourID = parseInt(request.getParameter("tourID"));
        TourDAO tourDAO = new TourDAO();
        Tour tour = tourDAO.getById(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/tours");
            return;
        }

        Map<String, String> form = collectForm(request);
        Map<String, String> errors = validateForm(form, tour);

        int numberOfPeople = parseInt(form.get("numberOfPeople"));
        if (errors.isEmpty()) {
            int reservedPeople = new BookingDAO().getReservedPeopleByTour(tourID);
            if (reservedPeople + numberOfPeople > tour.getMaxPeople()) {
                errors.put("numberOfPeople", "So cho con lai cua tour khong du cho yeu cau nay.");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("tour", tour);
            request.setAttribute("itineraries", new IniteraryDAO().getByTourId(tourID));
            request.setAttribute("bookingForm", form);
            request.setAttribute("bookingErrors", errors);
            request.getRequestDispatcher("/view/TourDetails.jsp").forward(request, response);
            return;
        }

        Customer customer = buildCustomer(form);
        int bookingID = new BookingDAO().createBooking(customer, tourID, numberOfPeople, tour.getPrice());
        response.sendRedirect(request.getContextPath() + "/booking-success?id=" + bookingID);
    }

    private Map<String, String> collectForm(HttpServletRequest request) {
        Map<String, String> form = new LinkedHashMap<>();
        form.put("tourID", safe(request.getParameter("tourID")));
        form.put("fullName", safe(request.getParameter("fullName")));
        form.put("dateOfBirth", safe(request.getParameter("dateOfBirth")));
        form.put("phone", safe(request.getParameter("phone")));
        form.put("email", safe(request.getParameter("email")));
        form.put("address", safe(request.getParameter("address")));
        form.put("cccd", safe(request.getParameter("cccd")));
        form.put("numberOfPeople", safe(request.getParameter("numberOfPeople")));
        return form;
    }

    private Map<String, String> validateForm(Map<String, String> form, Tour tour) {
        Map<String, String> errors = new LinkedHashMap<>();

        if (form.get("fullName").isEmpty()) {
            errors.put("fullName", "Vui long nhap ho ten.");
        }
        if (form.get("phone").isEmpty()) {
            errors.put("phone", "Vui long nhap so dien thoai.");
        } else if (!form.get("phone").matches("^(0|\\+84)\\d{9,10}$")) {
            errors.put("phone", "So dien thoai chua dung dinh dang.");
        }
        if (form.get("email").isEmpty()) {
            errors.put("email", "Vui long nhap email.");
        } else if (!form.get("email").matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            errors.put("email", "Email chua dung dinh dang.");
        }

        int numberOfPeople = parseInt(form.get("numberOfPeople"));
        if (numberOfPeople <= 0) {
            errors.put("numberOfPeople", "So luong khach phai lon hon 0.");
        } else if (tour != null && numberOfPeople > tour.getMaxPeople()) {
            errors.put("numberOfPeople", "So luong khach vuot qua suc chua toi da cua tour.");
        }

        String dateOfBirth = form.get("dateOfBirth");
        if (!dateOfBirth.isEmpty()) {
            try {
                Date.valueOf(dateOfBirth);
            } catch (IllegalArgumentException ex) {
                errors.put("dateOfBirth", "Ngay sinh khong hop le.");
            }
        }

        return errors;
    }

    private Customer buildCustomer(Map<String, String> form) {
        Customer customer = new Customer();
        customer.setFullName(form.get("fullName"));
        customer.setGender(null);
        customer.setDateOfBirth(form.get("dateOfBirth").isEmpty() ? null : Date.valueOf(form.get("dateOfBirth")));
        customer.setPhone(form.get("phone"));
        customer.setEmail(form.get("email"));
        customer.setAddress(form.get("address").isEmpty() ? null : form.get("address"));
        customer.setCccd(form.get("cccd").isEmpty() ? null : form.get("cccd"));
        return customer;
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
