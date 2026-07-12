package Models;

public class TourHotel {
    private int tourHotelID;
    private int tourID;
    private int hotelID;

    public TourHotel() {
    }

    public TourHotel(int tourHotelID, int tourID, int hotelID) {
        this.tourHotelID = tourHotelID;
        this.tourID = tourID;
        this.hotelID = hotelID;
    }

    public int getTourHotelID() {
        return tourHotelID;
    }

    public void setTourHotelID(int tourHotelID) {
        this.tourHotelID = tourHotelID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getHotelID() {
        return hotelID;
    }

    public void setHotelID(int hotelID) {
        this.hotelID = hotelID;
    }
}
