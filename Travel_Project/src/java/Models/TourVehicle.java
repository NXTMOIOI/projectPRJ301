package Models;

public class TourVehicle {
    private int tourVehicleID;
    private int tourID;
    private int vehicleID;

    public TourVehicle() {
    }

    public TourVehicle(int tourVehicleID, int tourID, int vehicleID) {
        this.tourVehicleID = tourVehicleID;
        this.tourID = tourID;
        this.vehicleID = vehicleID;
    }

    public int getTourVehicleID() {
        return tourVehicleID;
    }

    public void setTourVehicleID(int tourVehicleID) {
        this.tourVehicleID = tourVehicleID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }
}
