<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng Nhập - Travel Company</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container d-flex justify-content-center align-items-center vh-100">
            <div class="card p-4 shadow" style="width: 24rem;">
                <h3 class="text-center text-primary mb-4">ĐĂNG NHẬP</h3>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger p-2 text-center" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <% if("registered".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success p-2 text-center" role="alert">
                        Đăng ký thành công! Mời đăng nhập.
                    </div>
                <% } %>
                
                <% if("login_required".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-warning p-2 text-center" role="alert">
                        Vui lòng đăng nhập để thực hiện chức năng!
                    </div>
                <% } %>

                <form action="login" method="POST">
                    <div class="mb-3">
                        <label for="username" class="form-label">Tài khoản</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
                </form>
                
                <div class="text-center mt-3">
                    <span class="small">Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></span>
                </div>
            </div>
        </div>
    </body>
</html>