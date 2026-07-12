package Models;

public class Vehicle {
    private int vehicleID;
    private String vehicleType;
    private int capacity;
    private String licensePlate;

    public Vehicle() {
    }

    public Vehicle(int vehicleID, String vehicleType, int capacity, String licensePlate) {
        this.vehicleID = vehicleID;
        this.vehicleType = vehicleType;
        this.capacity = capacity;
        this.licensePlate = licensePlate;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }
}
