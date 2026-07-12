package Models;

public class Itinerary {
    private int itineraryID;
    private int tourID;
    private int dayNumber;
    private String activities;

    public Itinerary() {
    }

    public Itinerary(int itineraryID, int tourID, int dayNumber, String activities) {
        this.itineraryID = itineraryID;
        this.tourID = tourID;
        this.dayNumber = dayNumber;
        this.activities = activities;
    }

    public int getItineraryID() {
        return itineraryID;
    }

    public void setItineraryID(int itineraryID) {
        this.itineraryID = itineraryID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getActivities() {
        return activities;
    }

    public void setActivities(String activities) {
        this.activities = activities;
    }
}
