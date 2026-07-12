/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;
import java.sql.Date;
/**
 *
 * @author NXT
 */
public class Promotion {
    private int promotionID;
    private String promotionName;
    private String description;
    private int discountPercent;
    private Date startDate;
    private Date endDate;
    private String status;

    public Promotion() {
    }

    public Promotion(int promotionID, String promotionName, String description, int discountPercent, Date startDate, Date endDate, String status) {
        this.promotionID = promotionID;
        this.promotionName = promotionName;
        this.description = description;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(int promotionID) {
        this.promotionID = promotionID;
    }

    public String getPromotionName() {
        return promotionName;
    }

    public void setPromotionName(String promotionName) {
        this.promotionName = promotionName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }



    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Promotion{" + "promotionID=" + promotionID + ", promotionName=" + promotionName + ", description=" + description + ", discountPercent=" + discountPercent + ", startDate=" + startDate + ", endDate=" + endDate + ", status=" + status + '}';
    }


    
}
