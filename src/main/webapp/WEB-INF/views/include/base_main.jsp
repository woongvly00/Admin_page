<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기초정보 관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background: #f9f9f9;
        margin: 0;
        color: #333;
    }
    .wrapper {
        display: flex;
        height: 100vh;
    }
    .sidebar {
        width: 200px;
        background-color: #222;
        color: #fff;
        padding: 20px;
        box-sizing: border-box;
    }
    .sidebar h2 {
        font-size: 20px;
        margin-bottom: 20px;
    }
    .sidebar a {
        display: block;
        color: #ccc;
        text-decoration: none;
        margin-bottom: 10px;
    }
    .sidebar a:hover {
        color: #fff;
    }
    .content {
        flex: 1;
        padding: 30px;
        box-sizing: border-box;
        overflow-y: auto;
        background: #fff;
    }
    h2 {
        margin-bottom: 20px;
        font-size: 24px;
    }
    label {
        display: block;
        margin: 15px 0 5px;
        font-weight: bold;
    }
    input[type="text"], input[type="file"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
    }
    button {
        margin-top: 20px;
        padding: 10px;
        width: 100%;
        background: #0066cc;
        border: none;
        color: #fff;
        font-weight: bold;
        border-radius: 6px;
        cursor: pointer;
        transition: 0.2s;
    }
    button:hover {
        background: #004c99;
    }
    .logo-preview {
        display: block;
        max-width: 200px;
        margin-top: 15px;
    }
    .section {
        display: none;
    }
    .section.active {
        display: block;
    }
</style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>기초정보 관리</h2>
        <a href="#" class="menu-btn" data-target="edit">회사 정보 수정</a>
        <a href="#" class="menu-btn" data-target="view">회사 정보 조회</a>
    </div>
    <div class="content">
        <!-- 수정 -->
        <div class="section active" id="edit">
            <h2>회사 정보 수정</h2>
            <form action="/admin/company/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="comId" value="${company.comId}" />

                <label for="comName">회사명</label>
                <input type="text" id="comName" name="comName" value="${company.comName}" required />

                <label for="logoFile">로고 이미지 (선택)</label>
                <input type="file" id="logoFile" name="logoFile" accept="image/*" />

                <c:if test="${not empty company.logoPath}">
                    <img src="${company.logoPath}" alt="회사 로고" class="logo-preview" />
                </c:if>

                <button type="submit">수정하기</button>
            </form>
        </div>

        <!-- 조회 -->
        <div class="section" id="view">
            <h2>회사 정보 조회</h2>
            <table>
                <tr><th>회사명</th><td>${company.comName}</td></tr>
                <tr>
                    <th>로고</th>
                    <td>
                        <c:if test="${not empty company.logoPath}">
							<img src="${company.logoPath}" alt="회사 로고" class="logo-preview" />
                        </c:if>
                        <c:if test="${empty company.logoPath}">
                            등록된 로고가 없습니다.
                        </c:if>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {
        $('.menu-btn').click(function(e) {
            e.preventDefault();
            const target = $(this).data('target');
            $('.section').removeClass('active');
            $('#' + target).addClass('active');
        });
    });
</script>
</body>
</html>
