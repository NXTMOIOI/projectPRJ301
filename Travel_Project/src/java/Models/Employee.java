package Models;

import java.math.BigDecimal;

public class Employee {
    private int employeeID;
    private String fullName;
    private String position;
    private String phone;
    private String email;
    private BigDecimal salary;

    public Employee() {
    }

    public Employee(int employeeID, String fullName, String position,
                    String phone, String email, BigDecimal salary) {
        this.employeeID = employeeID;
        this.fullName = fullName;
        this.position = position;
        this.phone = phone;
        this.email = email;
        this.salary = salary;
    }

    public int getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(int employeeID) {
        this.employeeID = employeeID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public BigDecimal getSalary() {
        return salary;
    }

    public void setSalary(BigDecimal salary) {
        this.salary = salary;
    }
}
