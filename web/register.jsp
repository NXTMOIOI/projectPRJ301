<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng Ký Tài Khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container d-flex justify-content-center align-items-center vh-100">
            <div class="card p-4 shadow" style="width: 28rem;">
                <h3 class="text-center text-success mb-4">ĐĂNG KÝ</h3>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger p-2 text-center" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="register" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Tên đăng nhập (Username)</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <hr>
                    <div class="mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="tel" class="form-control" name="phone" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                    
                    <button type="submit" class="btn btn-success w-100">Đăng ký</button>
                </form>
                
                <div class="text-center mt-3">
                    <span class="small">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></span>
                </div>
            </div>
        </div>
    </body>
</html>