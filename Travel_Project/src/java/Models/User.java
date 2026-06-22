package Models;

public class User {
    private int userID;
    private String username;
    private String password;
    private String role;
    private Integer customerID;
    private Integer employeeID;

    public User() {
    }

    public User(int userID, String username, String password, String role,
                Integer customerID, Integer employeeID) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.role = role;
        this.customerID = customerID;
        this.employeeID = employeeID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getCustomerID() {
        return customerID;
    }

    public void setCustomerID(Integer customerID) {
        this.customerID = customerID;
    }

    public Integer getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(Integer employeeID) {
        this.employeeID = employeeID;
    }
}
