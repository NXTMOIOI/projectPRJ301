package Models;

public class Hotel {
    private int hotelID;
    private String hotelName;
    private String address;
    private String phone;
    private int starRating;

    public Hotel() {
    }

    public Hotel(int hotelID, String hotelName, String address,
                 String phone, int starRating) {
        this.hotelID = hotelID;
        this.hotelName = hotelName;
        this.address = address;
        this.phone = phone;
        this.starRating = starRating;
    }

    public int getHotelID() {
        return hotelID;
    }

    public void setHotelID(int hotelID) {
        this.hotelID = hotelID;
    }

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getStarRating() {
        return starRating;
    }

    public void setStarRating(int starRating) {
        this.starRating = starRating;
    }
}
