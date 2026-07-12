<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thông Tin Cá Nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <nav class="navbar navbar-dark bg-dark mb-4">
            <div class="container">
                <a class="navbar-brand" href="home.jsp">Travel Company</a>
                <span class="navbar-text text-white">
                    Xin chào, <%= session.getAttribute("account") != null ? session.getAttribute("account") : "Khách" %>
                </span>
            </div>
        </nav>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card p-4 shadow">
                        <h3 class="mb-4 text-secondary">Quản lý hồ sơ cá nhân</h3>
                        
                        <% if(request.getAttribute("msg") != null) { %>
                            <div class="alert alert-success p-2 text-center" role="alert">
                                <%= request.getAttribute("msg") %>
                            </div>
                        <% } %>

                        <form action="profile" method="POST">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" name="fullName" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Giới tính</label>
                                    <select class="form-select" name="gender">
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" name="dob">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số CCCD / Passport</label>
                                <input type="text" class="form-control" name="cccd">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Địa chỉ thường trú</label>
                                <textarea class="form-control" name="address" rows="3"></textarea>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="home.jsp" class="btn btn-outline-secondary">Quay lại</a>
                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
