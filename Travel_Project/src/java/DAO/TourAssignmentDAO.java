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
import Models.TourAssignment;
import Utils.DBContext;

public class TourAssignmentDAO extends DBContext {

    public List<TourAssignment> getAll() {
        List<TourAssignment> assignments = new ArrayList<>();
        String sql = "SELECT AssignmentID, TourID, GuideID FROM TourAssignments";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                assignments.add(mapAssignment(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour assignments", ex);
        }

        return assignments;
    }

    public TourAssignment getById(int assignmentID) {
        String sql = "SELECT AssignmentID, TourID, GuideID FROM TourAssignments WHERE AssignmentID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAssignment(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour assignment by id", ex);
        }

        return null;
    }

    public List<TourAssignment> getByTourId(int tourID) {
        List<TourAssignment> assignments = new ArrayList<>();
        String sql = "SELECT AssignmentID, TourID, GuideID FROM TourAssignments WHERE TourID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, tourID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    assignments.add(mapAssignment(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour assignments by tour id", ex);
        }

        return assignments;
    }

    public List<TourAssignment> getByGuideId(int guideID) {
        List<TourAssignment> assignments = new ArrayList<>();
        String sql = "SELECT AssignmentID, TourID, GuideID FROM TourAssignments WHERE GuideID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, guideID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    assignments.add(mapAssignment(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot get tour assignments by guide id", ex);
        }

        return assignments;
    }

    public boolean insert(TourAssignment assignment) {
        String sql = "INSERT INTO TourAssignments(TourID, GuideID) VALUES (?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignment.getTourID());
            ps.setInt(2, assignment.getGuideID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot insert tour assignment", ex);
        }
    }

    public boolean update(TourAssignment assignment) {
        String sql = "UPDATE TourAssignments SET TourID = ?, GuideID = ? WHERE AssignmentID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignment.getTourID());
            ps.setInt(2, assignment.getGuideID());
            ps.setInt(3, assignment.getAssignmentID());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot update tour assignment", ex);
        }
    }

    public boolean delete(int assignmentID) {
        String sql = "DELETE FROM TourAssignments WHERE AssignmentID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Cannot delete tour assignment", ex);
        }
    }

    private TourAssignment mapAssignment(ResultSet rs) throws SQLException {
        return new TourAssignment(
                rs.getInt("AssignmentID"),
                rs.getInt("TourID"),
                rs.getInt("GuideID")
        );
    }
}
