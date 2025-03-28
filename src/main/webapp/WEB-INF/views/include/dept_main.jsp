<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>부서 관리</title>
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <style>
    body { font-family: 'Segoe UI', sans-serif; background: #f4f4f4; margin: 0; color: #333; }
    .wrapper { display: flex; height: 100vh; }
    .sidebar { width: 200px; background: #222; color: #fff; padding: 20px; box-sizing: border-box; }
    .sidebar h2 { font-size: 20px; margin-bottom: 20px; }
    .sidebar a { display: block; color: #ccc; text-decoration: none; margin-bottom: 10px; }
    .sidebar a:hover { color: #fff; }
    .content { flex: 1; padding: 30px; box-sizing: border-box; overflow-y: auto; }
    h3 { border-bottom: 1px solid #ccc; padding-bottom: 5px; }
    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background: #f4f4f4; }
    input[type="text"], select { padding: 5px; width: 100%; box-sizing: border-box; margin-top: 5px; }
    .form-group { margin-bottom: 10px; }
    .btn { padding: 5px 10px; background: #111; color: white; border: none; cursor: pointer; }
    .btn:hover { background: #333; }
  </style>
</head>
<body>
<div class="wrapper">
  <div class="sidebar">
    <h2>부서 관리</h2>
    <a href="#" class="menu-btn" data-target="dept-section">부서 관리</a>
  </div>
  <div class="content">
    <div class="section active" id="dept-section">
      <h3>부서 등록</h3>
      <form action="/Depart/insertDept" id="deptForm" method="post">
        <div class="form-group">
          <label>부서 이름</label>
          <input type="text" name="dept_name" />
        </div>
        <button type="submit" class="btn">등록</button>
      </form>

      <h3>부서 목록</h3>
      <table>
        <thead>
        <tr><th>부서ID</th><th>부서명</th><th>부서장</th><th>관리</th></tr>
        </thead>
        <tbody id="deptTable"></tbody>
      </table>
    </div>
  </div>
</div>

<script>
  $(document).ready(function () {
    $('.menu-btn').click(function (e) {
      e.preventDefault();
      const target = $(this).data('target');
      $('.section').removeClass('active');
      $('#' + target).addClass('active');
    });

    // 부서 목록 불러오기
    $.ajax({
      url: "/Depart/selectAllDept",
      type: "GET"
    }).done(function (resp) {
      $('#deptTable').empty();
      resp.forEach(function (dept) {
        let row = '<tr>' +
          '<td>' + dept.dept_id + '</td>' +
          '<td class="dept-name" contenteditable="false">' + dept.dept_name + '</td>' +
          '<td class="dept-manager">' + dept.manager + '</td>' +
          '<td>' +
          '<button class="edit-btn">수정</button>' +
          '<button class="confirm-edit-btn" style="display:none;">수정 완료</button>' +
          '<button class="cancel-edit-btn" style="display:none;">취소</button>' +
          '<button class="delete-btn">삭제</button>' +
          '</td>' +
          '</tr>';
        $('#deptTable').append(row);
      });
    });

    function getEmployeeList(callback) {
      $.ajax({
        url: '/Employee/list',
        method: 'GET',
        dataType: 'json',
        success: callback,
        error: function () {
          alert('사원 목록 불러오기 실패');
        }
      });
    }

    $(document).on('click', '.edit-btn', function () {
      const row = $(this).closest('tr');
      const currentManager = row.find('.dept-manager').text().trim();
      row.find('.dept-name').attr('contenteditable', 'true').focus();

      getEmployeeList(function (empList) {
        let selectHTML = `<select class="manager-select">`;
        empList.forEach(emp => {
          const selected = emp.emp_name === currentManager ? 'selected' : '';
          selectHTML += `<option value="${emp.emp_id}" ${selected}>${emp.emp_name}</option>`;
        });
        selectHTML += `</select>`;
        row.find('.dept-manager').html(selectHTML);
      });

      row.find('.edit-btn').hide();
      row.find('.delete-btn').hide();
      row.find('.confirm-edit-btn').show();
      row.find('.cancel-edit-btn').show();
    });

    $(document).on('click', '.confirm-edit-btn', function () {
      const row = $(this).closest('tr');
      const deptId = row.find('td:first').text();
      const updatedName = row.find('.dept-name').text();
      const managerId = row.find('.manager-select').val();

      $.ajax({
        url: '/Depart/updateDept',
        type: 'POST',
        data: {
          dept_id: deptId,
          dept_name: updatedName,
          manager_id: managerId
        }
      }).done(function () {
        row.find('.dept-name').attr('contenteditable', 'false');
        row.find('.edit-btn').show();
        row.find('.delete-btn').show();
        row.find('.confirm-edit-btn').hide();
        row.find('.cancel-edit-btn').hide();

        row.find('.dept-manager').text(row.find('.manager-select option:selected').text());
      });
    });

    $(document).on('click', '.cancel-edit-btn', function () {
      location.reload();
    });

    $(document).on('click', '.delete-btn', function () {
      const row = $(this).closest('tr');
      const deptid = row.find('td:first').text();

      $.ajax({
        url: '/Depart/deleteDept',
        type: 'POST',
        data: { dept_id: deptid }
      }).done(function () {
        row.remove();
      });
    });
  });
</script>
</body>
</html>