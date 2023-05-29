<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<script>
	    function boardSearch() {
	        const keyword = $("#keyword").val(); // 검색어 가져오기
			const type = $("#searchOption").val();				 
    		const board = {
	    		type: type,
	        	keyword: keyword	
	    	}	      

	        
	        $.ajax({
	            type: "GET",
	            url: "/board/search",
	            data: board,
	            success: function(response) {
	                var tableBody = $("#boardTable tbody");
	                tableBody.empty();

	                if (Array.isArray(response)) {
	                    response.forEach(function(board) {
	                        var row = "<tr>" +
	                            "<td><input type='checkbox' name='selectedBoard' value='" + board.bno + "'></td>" +
	                            "<td>" + board.bno + "</td>" +
	                            "<td>" + board.title + "</td>" +
	                            "<td>" + board.writer + "</td>" +
	                            "<td>" + new Date(board.regDate).toLocaleDateString() + "</td>" +
	                            "</tr>";
	                        tableBody.append(row);
	                    });
	                }
	            },
	            error: function(xhr, status, error) {
	                // 에러 처리
	            }
	        });
        }
	    
	    
	    
	    
	    const boardDelete = () => {	    	
	    	const selectedValues = [];
	    	$('input[name="selectedBoard"]:checked').each(function(){
	    		selectedValues.push($(this).val());
	    	})
	    	console.log(selectedValues)
	    	console.log(selectedValues.length)
	    	
	    	if(selectedValues.length === 0) {
	    		alert("아무것도 선택하지 않았습니다")
	    	} else if(selectedValues.length > 1) {
	    		alert("하나만 선택하세요")
	    	} else {
	    		console.log(selectedValues[0]) // 체크박스의 ID값
	    		
	    		const board = {
	    			bno: selectedValues[0]
	    		}	    		
	    		
	 	        $.ajax({
		            type: "POST",
		            url: "/board/delete", 
		            data:JSON.stringify(board), // 전송할 데이터
		            contentType: "application/json",
		            success: function(response) {
		                console.log(response); // 예시: 콘솔에 응답 로그 출력
		                alert(response)
		                location.reload();
		            },
		            error: function(xhr, status, error) {
		            }
		        });   		
	    		
	    	}
	    }
	    
	    const boardmodify = () => {
	    	const selectedBoards = [];
	    	const checkboxes = document.getElementsByName('selectedBoard');
	    	
	        for (let i = 0; i < checkboxes.length; i++) {
	            if (checkboxes[i].checked) {
	                selectedBoards.push(checkboxes[i].value);
	            }
	        }

	        if (selectedBoards.length == 1) {
	            const url = '/board/modify?bno=' + selectedBoards.join(',');
	            window.location.href = url;
	        } else if(selectedBoards.length > 1) {
	        	alert('하나만 선택해주세요.');
	        }	        	        
	        else {
	            alert('선택된 항목이 없습니다.');
	        }
	    	
	    	
	    }
	    
	</script>
	
	<div class="container" style="position: relative;">
	    <div class="page-header">
	    </div>
	    <h2 style="margin-top: 30px;">공지사항</h2>
	    <div class="row">
			<select id="searchOption" class="form-select" aria-label="Default select example">
			  <option selected>Open this select menu</option>
			  <option value="전체">전체</option>
			  <option value="아이디">아이디</option>
			  <option value="제목">제목</option>
			  <option value="작성자">작성자</option>
			</select>
	        <div class="col-5">
	            <input type="text" id="keyword" class="form-control" placeholder="검색어를 입력하세요" 
	                aria-label="검색어를 입력하세요" aria-describedby="btn_search"  />
	        </div>
	        <div class="col-3">	            	            
	            <button type="button" class="btn btn-primary" onclick="boardSearch();">검색</button>	            
	            <button type="button" class="btn btn-primary" onclick="boardmodify()">수정하기</button>	            
	            <button type="button" class="btn btn-primary" onclick="boardDelete()">삭제하기</button>	            
	        </div>
	    </div>	    
	</div>

    <table id="boardTable" class="table">
        <thead>
            <tr>
            	<th></th>
                <th>ID</th>
                <th>Title</th>
                <th>Writer</th>
                <th>Reg Date</th>
            </tr>
        </thead>
        <tbody>
            <%@ page import="com.example.demo.dto.Board" %>
            <%@ page import="java.util.List" %>
            <%@ page import="java.sql.Date" %>
            <%@ page import="java.text.SimpleDateFormat" %>


            <% List<Board> boardList = (List<Board>) request.getAttribute("result"); %>
            <% 
            	int pageSize = 5; // 한 페이지에 보여줄 데이터 수
            	int totalSize = boardList.size(); // 전체 데이터 수
            	int totalPages = (int) Math.ceil((double) totalSize / pageSize);// 전체 페이지 수 
            	int currentPage = 1; // 현재 페이지 (첫 번째 페이지로 초기화)       
            %>
            
			<% if (request.getParameter("page") != null) { // 페이지 파라미터가 전달되었을 경우, 현재 페이지로 설정 %>
			    <% currentPage = Integer.parseInt(request.getParameter("page")); %>
			<% } %>      
			<% int startIndex = (currentPage - 1) * pageSize; // 시작 인덱스 (현재 페이지에 해당하는 데이터 시작 인덱스) %>
			<% int endIndex = Math.min(startIndex + pageSize, totalSize); // 종료 인덱스 (현재 페이지에 해당하는 데이터 종료 인덱스) %>       
			
            <% SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); %>
			<% for (int i = startIndex; i < endIndex; i++) { // 현재 페이지에 해당하는 데이터만 출력 %>
			    <% Board board = boardList.get(i); %>
			    <tr>
			        <td><input type="checkbox" name="selectedBoard" value="<%= board.getBno() %>"></td>
			        <td><%= board.getBno() %></td>
			        <td><%= board.getTitle() %></td>
			        <td><%= board.getWriter() %></td>
			        <td><%= dateFormat.format(board.getRegDate()) %></td>
			    </tr>
			<% } %>
            
		<nav aria-label="Page navigation example">
		    <ul class="pagination">
		        <% if (currentPage > 1) { %>
		            <li class="page-item"><a class="page-link" href="?page=1">처음</a></li>
		            <li class="page-item"><a class="page-link" href="?page=<%= currentPage - 1 %>">이전</a></li>
		        <% } else { %>
		            <li class="page-item disabled"><a class="page-link" href="#">처음</a></li>
		            <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
		        <% } %>
		
		        <% int startPage = Math.max(1, currentPage - 2); // 시작 페이지
		           int endPage = Math.min(startPage + 4, totalPages); // 종료 페이지
		
		           for (int pageNumber = startPage; pageNumber <= endPage; pageNumber++) { %>
		            <% if (pageNumber == currentPage) { %>
		                <li class="page-item active"><a class="page-link" href="#"><%= pageNumber %></a></li>
		            <% } else { %>
		                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber %>"><%= pageNumber %></a></li>
		            <% } %>
		        <% } %>
		
		        <% if (currentPage < totalPages) { %>
		            <li class="page-item"><a class="page-link" href="?page=<%= currentPage + 1 %>">다음</a></li>
		            <li class="page-item"><a class="page-link" href="?page=<%= totalPages %>">마지막</a></li>
		        <% } else { %>
		            <li class="page-item disabled"><a class="page-link" href="#">다음</a></li>
		            <li class="page-item disabled"><a class="page-link" href="#">마지막</a></li>
		        <% } %>
		    </ul>
		</nav>
			
			
        </tbody>
    </table>
</body>
</html>