package Models;

import java.math.BigDecimal;
import java.sql.Date;

public class Tour {
    private int tourID;
    private String tourName;
    private String destination;
    private int duration;
    private BigDecimal price;
    private int maxPeople;
    private Date startDate;
    private Date endDate;
    private String imageURL;

    public Tour() {
    }

    public Tour(int tourID, String tourName, String destination, int duration,
                BigDecimal price, int maxPeople, Date startDate, Date endDate,
                String imageURL) {
        this.tourID = tourID;
        this.tourName = tourName;
        this.destination = destination;
        this.duration = duration;
        this.price = price;
        this.maxPeople = maxPeople;
        this.startDate = startDate;
        this.endDate = endDate;
        this.imageURL = imageURL;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getMaxPeople() {
        return maxPeople;
    }

    public void setMaxPeople(int maxPeople) {
        this.maxPeople = maxPeople;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }
}
