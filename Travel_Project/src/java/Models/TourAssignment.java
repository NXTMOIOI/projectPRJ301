package Models;

public class TourAssignment {
    private int assignmentID;
    private int tourID;
    private int guideID;

    public TourAssignment() {
    }

    public TourAssignment(int assignmentID, int tourID, int guideID) {
        this.assignmentID = assignmentID;
        this.tourID = tourID;
        this.guideID = guideID;
    }

    public int getAssignmentID() {
        return assignmentID;
    }

    public void setAssignmentID(int assignmentID) {
        this.assignmentID = assignmentID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getGuideID() {
        return guideID;
    }

    public void setGuideID(int guideID) {
        this.guideID = guideID;
    }
}
