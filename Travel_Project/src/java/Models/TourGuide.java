package Models;

public class TourGuide {
    private int guideID;
    private String fullName;
    private String phone;
    private int experience;
    private String language;

    public TourGuide() {
    }

    public TourGuide(int guideID, String fullName, String phone,
                     int experience, String language) {
        this.guideID = guideID;
        this.fullName = fullName;
        this.phone = phone;
        this.experience = experience;
        this.language = language;
    }

    public int getGuideID() {
        return guideID;
    }

    public void setGuideID(int guideID) {
        this.guideID = guideID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getExperience() {
        return experience;
    }

    public void setExperience(int experience) {
        this.experience = experience;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }
}
