/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Models.Itinerary;
import Utils.DBContext;

public class IniteraryDAO extends DBContext {

    public List<Itinerary> getAll() {
        List<Itinerary> itineraries = new ArrayList<>();
        String sql = "SELECT ItineraryID, TourID, DayNumber, Activities FROM Itineraries";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                itineraries.add(mapItinerary(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get itineraries", ex);
        }

        return itineraries;
    }

    public Itinerary getById(int itineraryID) {
        String sql = "SELECT ItineraryID, TourID, DayNumber, Activities FROM Itineraries WHERE ItineraryID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itineraryID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapItinerary(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get itinerary by id", ex);
        }

        return null;
    }

    public List<Itinerary> getByTourId(int tourID) {
        List<Itinerary> itineraries = new ArrayList<>();
        String sql = "SELECT ItineraryID, TourID, DayNumber, Activities FROM Itineraries WHERE TourID = ? ORDER BY DayNumber";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    itineraries.add(mapItinerary(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get itineraries by tour id", ex);
        }

        return itineraries;
    }

    public boolean insert(Itinerary itinerary) {
        String sql = "INSERT INTO Itineraries(TourID, DayNumber, Activities) VALUES (?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itinerary.getTourID());
            ps.setInt(2, itinerary.getDayNumber());
            ps.setString(3, itinerary.getActivities());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot insert itinerary", ex);
        }
    }

    public boolean update(Itinerary itinerary) {
        String sql = "UPDATE Itineraries SET TourID = ?, DayNumber = ?, Activities = ? WHERE ItineraryID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itinerary.getTourID());
            ps.setInt(2, itinerary.getDayNumber());
            ps.setString(3, itinerary.getActivities());
            ps.setInt(4, itinerary.getItineraryID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot update itinerary", ex);
        }
    }

    public boolean delete(int itineraryID) {
        String sql = "DELETE FROM Itineraries WHERE ItineraryID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, itineraryID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot delete itinerary", ex);
        }
    }

    private Itinerary mapItinerary(ResultSet rs) throws SQLException {
        return new Itinerary(
                rs.getInt("ItineraryID"),
                rs.getInt("TourID"),
                rs.getInt("DayNumber"),
                rs.getString("Activities")
        );
    }
}
