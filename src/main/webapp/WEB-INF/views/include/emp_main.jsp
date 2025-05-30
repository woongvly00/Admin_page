<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사원 관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.container {
  display: flex;
  min-height: 100vh;
  font-family: 'Noto Sans KR', sans-serif;
}

.sidebar {
  width: 220px;
  background-color: #1a3c6c;
  color: #fff;
  padding: 20px;
  box-shadow: inset -1px 0 0 rgba(0, 0, 0, 0.05);
}

.sidebar h3 {
  font-size: 18px;
  margin-bottom: 16px;
}

.sidebar a {
  display: block;
  color: #edf6ff;
  padding: 10px 12px;
  margin-bottom: 8px;
  border-radius: 6px;
  text-decoration: none;
  transition: background-color 0.2s;
}

.sidebar a:hover {
  background-color: #274b84;
}

.main-content {
  flex-grow: 1;
  padding: 30px;
  background-color: #f9fbfd;
  margin-left:50px;
}

.section {
  display: none;
}

.section.active {
  display: block;
}

fieldset {
  margin-bottom: 20px;
  border: 1px solid #dce9f5;
  padding: 16px;
  border-radius: 8px;
  background: #ffffff;
}

legend {
  font-weight: 600;
  color: #1a3c6c;
}

form {
  max-width: 600px; /* 폼 전체 최대 너비 제한 */
}

input[type="text"], input[type="email"], input[type="date"], select {
  display: block;
  width: 600px; /* 고정 너비로 변경 */
  padding: 10px;
  margin-top: 8px;
  margin-bottom: 12px;
  border: 1px solid #ccc;
  border-radius: 6px;
}



button {
  background-color: #1a3c6c;
  text-align: center;
  color: white;
  border: none;
  padding: 0 20px; /* 상하 패딩은 제거하거나 최소화 */
  font-size: 14px;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s;
  height: 37px;
  line-height: 37px; /* 텍스트를 수직 가운데로 */
}


button:hover {
  background-color: #274b84;
}

table {
  width: 100%;
  border-collapse: collapse;
  background: white;
}

th, td {
  padding: 12px;
  border: 1px solid #dce9f5;
  text-align: center;
}

thead {
  background-color: #f0f4fa;
}

#searchEmp{
width:200px;
}

#empListHeader {
	display: flex;
	justify-content: start;
	align-items: center; /* 세로 중앙 정렬 */
	gap: 12px; 
	height:50px;
	width:100%;
}

#updateModal input[type="text"],
#updateModal select {
  width: 100%;
  max-width: 100%;
  box-sizing: border-box;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  padding: 30px;
  border-radius: 12px;
  width: 400px;
  box-shadow: 0 5px 20px rgba(0,0,0,0.3);
  position: relative;
  animation: fadeIn 0.2s ease-in-out;
}

.close-btn {
  position: absolute;
  top: 10px;
  right: 14px;
  font-size: 24px;
  color: #aaa;
  cursor: pointer;
}

@keyframes fadeIn {
  from { transform: scale(0.95); opacity: 0; }
  to   { transform: scale(1); opacity: 1; }
}
#selectTarget{
width:80px;
height:37px;
}

#searchForm{
width:100%;
}

</style>
</head>
<body>
	<div class="container">
  <div class="sidebar">
    <h3>사원 관리</h3>
    <a href="#" data-target="read" id="readEmpList">사원 조회 및 관리</a>
    <a href="#" data-target="create">사원 등록</a>
  </div>

  <div class="main-content">
  
    <div id="create" class="section">
      <h2>사원 등록</h2>
      <form action="/Employee/insertMember" method="post">
        <fieldset>
          <legend>기본 설정</legend>
          <input type="text" id="id" name="emp_loginId" placeholder="아이디" readonly />
          <input type="text" id="pw" name="emp_pw" placeholder="비밀번호" readonly />
          <input type="date" name="hire_date" placeholder="입사일" />
          <input type="text" name="salary" placeholder="연봉" required />
        </fieldset>

        <fieldset>
          <legend>사원 정보</legend>
          <input type="text" name="emp_name" placeholder="이름" required />
          <input type="text" name="emp_rrn" placeholder="주민등록번호" required />
          <input type="text" name="emp_phone" placeholder="연락처" required />
          <input type="email" name="emp_email" placeholder="이메일" />
          <input type="text" name="postcode" id="postcode" placeholder="우편번호" readonly />
          <button type="button" id="btn">우편번호 찾기</button>
          <input type="text" name="address1" id="address" placeholder="주소" readonly />
          <input type="text" name="address2" placeholder="상세주소" />
        </fieldset>

        <fieldset>
          <legend>부서 및 직급</legend>
          <select name="emp_dept_id" id="select_dept">
            <option value="">부서 선택</option>
          </select>
          <select name="emp_job_id" id="select_job">
            <option value="">직급 선택</option>
          </select>
        </fieldset>

        <button id="addEmp">등록</button>
      </form>
    </div>

    <div id="read" class="section active">
      <h2>사원 목록</h2>
      <form id="searchForm">
      <div id="empListHeader">
      <select id="selectTarget" name="target">
      <option value="name" selected>이름</option>
      <option value="dept">부서</option>
      <option value="job">직급</option>
      </select>
      	<input name="keyword" id="searchEmp" type="text" placeholder="사원 검색하기"/><button>검색</button>
      </div>
      </form>
      <table>
        <thead>
          <tr>
            <th>ID</th><th>이름</th><th>부서</th><th>직급</th><th>이메일</th><th>사원관리</th>
          </tr>
        </thead>
        <tbody id="empboardTable"></tbody>
      </table>
    </div>

   
    
    <div id="updateModal" class="modal" style="display: none;">
  <div class="modal-content">
    <span class="close-btn">&times;</span>
    <h2>사원 정보 수정</h2>
    <form id="updateForm" action="/Employee/update" method="post">
      <input type="text" name="emp_code_id" placeholder="사원 ID" required readonly />
      
      <select name="emp_dept_id" id="emp_dept_id_modal" required>
        <option value="" selected>부서 선택</option>
      </select>
      
      <select name="emp_job_id" id="emp_job_id_modal" required>
        <option value="" selected>직급 선택</option>
      </select>
      
      <input type="text" name="address1" placeholder="새 주소" />
      
      <button type="submit">수정</button>
    </form>
  </div>
</div>



  </div>
</div>


<script>

let isSearching = false;


$(document).ready(function() {
	$("#searchEmp").val("");
	if(!isSearching){
		$.ajax({
	    	url:"/Employee/selectAll"
	    }).done(function(resp){
	    	let html = "";
	    	let defaultId="";
	    	
	    	resp.forEach(function(emp){
	    		html += "<tr><td>" + emp.emp_code_id 
	    				+ "</td><td>" + emp.emp_name 
	    				+ "</td><td>" + (emp.departDTO ? emp.departDTO.dept_name : "직급 없음")
	    				+ "</td><td>" + (emp.jobDTO ? emp.jobDTO.job_name : "직급 없음")
	    				+ "</td><td>" + emp.emp_email 
	    				+ "</td><td><button class='edit-btn' style='margin-right: 8px;'"
	    				+ "data-name='" + emp.emp_name + "' "
	    			    + "data-id='" + emp.emp_code_id + "' "
	    			    + "data-dept='" + emp.emp_dept_id + "' "
	    			    + "data-job='" + emp.emp_job_id + "' "
	    			    + "data-addr='" + emp.address1 + "' "
	    				+ ">정보수정</button><button type='button' class='deleteBtn' data-id='" + emp.emp_code_id + "'>사원삭제</button>"
	    				+ "</td></tr>";
	    		defaultId = "loginID_" + (emp.emp_code_id + 1);
	    	});
	    	 
	    	$("#empboardTable").html(html);
	    	$("#id").val(defaultId);
	    	$("#pw").val(defaultId);
		
	   })
	    
	}
	 
	    
	    
	    $.ajax({
	    	url:"/Depart/selectAllDept"
	    }).done(function(resp){
	    	let deftHtml = "";
	    	resp.forEach(function(dept){
	    		deftHtml += '<option value="'+dept.dept_id+'">'+ dept.dept_name +'</option>';
	    	});
	    	$("#select_dept").html(deftHtml);
	    	$("#emp_dept_id_modal").append(deftHtml);
	    	$("#emp_dept_id").html(deftHtml);
	    })
	    
	    
	    $.ajax({
	    	url:"/Job/selectAllJob"
	    }).done(function(resp){
	    	let jobHtml = "";
	    	resp.forEach(function(e){
	    		jobHtml += '<option value="'+ e.job_id +'">'+ e.job_name +'</option>';
	    	});
	    	$("#select_job").html(jobHtml);
	    	$("#emp_job_id_modal").append(jobHtml);
	    	$("#emp_job_id").html(jobHtml);
	    })
	    
	   
	
    $('.sidebar a').click(function(e) {
        e.preventDefault();
        var target = $(this).data('target');
        $('.section').removeClass('active');
        $('#' + target).addClass('active');
    });
	
	 $("#searchForm").on("submit", function(e) {
		  e.preventDefault();
		  isSearching = true;

		  const target = $("select[name='target']").val();
		  const keyword = $("input[name='keyword']").val();

		  $.ajax({
		    url: "/Employee/searchByTarget",
		    type: "get",
		    data: { target, keyword },
		    success: function(resultList) {
		      let html = "";
		      resultList.forEach(emp => {
		        html += "<tr><td>" + emp.emp_code_id
						+ "</td><td>" + emp.emp_name 
						+ "</td><td>" + (emp.dept_name ? emp.dept_name : "직급 없음")
						+ "</td><td>" + (emp.job_name ? emp.job_name : "직급 없음")
						+ "</td><td>" + emp.emp_email 
						+ "</td><td><button class='edit-btn' style='margin-right: 8px;'"
						+ "data-name='" + emp.emp_name + "' "
					    + "data-id='" + emp.emp_code_id + "' "
					    + "data-dept='" + emp.emp_dept_id + "' "
					    + "data-job='" + emp.emp_job_id + "' "
					    + "data-addr='" + emp.address1 + "' "
						+ ">정보수정</button><button type='button' class='deleteBtn' data-id='" + emp.emp_code_id + "'>사원삭제</button>"
						+ "</td></tr>";
		        	
		      });
		      $("#empboardTable").html(html);
		      
		    }
		  });
		});
	 
	 
	 document.getElementById("btn").onclick = function () {
		    new daum.Postcode({
		        oncomplete: function (data) {
		            document.getElementById("postcode").value = data.zonecode;
		            document.getElementById("address").value = data.roadAddress;
		        }
		    }).open();
		};
		
		$('#addEmp').click(function(e) {
		    if (!$('#select_dept').val()) {
		        alert("부서를 선택해주세요!");
		        e.preventDefault();
		    }
		});
	 

});

$(document).on("click", ".deleteBtn", function(){
	const empId = $(this).data("id");


	  if (confirm("정말 삭제하시겠습니까?")) {
	    $.ajax({
	      url: "/Employee/delete",
	      type: "POST",
	      data: { emp_code_id: empId },
	      success: function () {
	        alert("삭제되었습니다.");
	        location.reload();
	      },
	      error: function () {
	        alert("삭제 중 오류가 발생했습니다.");
	      }
	    });
	  }
});

$(document).on("click", ".edit-btn", function () {
	  const empId = $(this).data("id");
	  const deptId = $(this).data("dept");
	  const jobId = $(this).data("job");
	  const addr = $(this).data("addr");

	  // 값 채우기
	  $('#updateForm [name="emp_code_id"]').val(empId);
	  $('#emp_dept_id_modal').val(deptId);
	  $('#emp_job_id_modal').val(jobId);
	  $('#updateForm [name="address1"]').val(addr || '');

	  // 모달 열기
	  $('#updateModal').show();
	});
	
$(".close-btn").click(() => {
	  $("#updateModal").hide();
	});

$(window).click((e) => {
	  if (e.target.id === "updateModal") {
	    $("#updateModal").hide();
	  }
	});

$("update")

document.getElementById("addEmp").addEventListener("click", function(e) {
    e.preventDefault(); 

    const name = document.querySelector("[name='emp_name']").value.trim();
    const rrn = document.querySelector("[name='emp_rrn']").value.trim();
    const phone = document.querySelector("[name='emp_phone']").value.trim();
    const email = document.querySelector("[name='emp_email']").value.trim();
    const dept = document.querySelector("#select_dept").value;
    const job = document.querySelector("#select_job").value;

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const phoneRegex = /^01[0-9]-?\d{3,4}-?\d{4}$/;
    const rrnRegex = /^\d{13}$/;

    if (!name) {
      alert("이름을 입력해주세요.");
      return;
    }

    if (!rrnRegex.test(rrn)) {
      alert("주민등록번호는 숫자 13자리여야 합니다.");
      return;
    }

    if (!phoneRegex.test(phone)) {
      alert("연락처 형식이 올바르지 않습니다. 예: 010-1234-5678");
      return;
    }

    if (email && !emailRegex.test(email)) {
      alert("이메일 형식이 올바르지 않습니다.");
      return;
    }

    if (!dept) {
      alert("부서를 선택해주세요.");
      return;
    }

    if (!job) {
      alert("직급을 선택해주세요.");
      return;
    }

    // 통과 시 폼 전송
    document.querySelector("form").submit();
    
    
    
  });

</script>
</body>
</html>