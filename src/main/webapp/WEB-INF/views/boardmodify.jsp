<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>수정하기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<script>
		const back = () => {
			window.location.href = "/board/list";
		}
		
		const upload = () => {
			
		    const bno = $("#bno").val();
		    const title = $("#title").val();
		    const writer = $("#writer").val();
			
			const board = {
				bno: bno,
				title: title,
				writer: writer,
			}
			
 	        $.ajax({
	            type: "POST",
	            url: "/board/upload", 
	            data:JSON.stringify(board), // 전송할 데이터
	            contentType: "application/json",
	            success: function(response) {
	                console.log(response); // 예시: 콘솔에 응답 로그 출력
	                window.location.href = "/board/list";
	            },
	            error: function(xhr, status, error) {
	            }
	        }); 			
		}
	</script>	
	    <div class="container">
        <h1>수정하기 페이지</h1>
		<%@ page import="com.example.demo.dto.Board" %>
		<%@ page import="java.util.List" %>
		
		<% List<Board> modifyList = (List<Board>) request.getAttribute("modifyList"); %>
	    <% if (modifyList != null && !modifyList.isEmpty()) { %>
	        <% Board board = modifyList.get(0); %>
	        <div class="form-group">
	            <label for="bno">아이디</label>
	            <input type="text" class="form-control" id="bno" name="bno" value="<%= board.getBno() %>">
	        </div>
	        <div class="form-group">
	            <label for="title">제목</label>
	            <input type="text" class="form-control" id="title" name="title" value="<%= board.getTitle() %>">
	        </div>
	        <div class="form-group">
	            <label for="writer">작성자</label>
	            <input type="text" class="form-control" id="writer" name="writer" value="<%= board.getWriter() %>">
	        </div>
	        <div class="mb-3">
	            <label for="formFile" class="form-label">사진업로드</label>
	            <input class="form-control" type="file" id="formFile">
	        </div>
	        <!-- 기타 필드들을 여기에 추가할 수 있습니다 -->
	    <% } %>
	    <button type="button" class="btn btn-primary" onclick="upload()">수정</button>
	    <button type="button" class="btn btn-primary" onclick="back()">뒤로가기</button>	
    </div>

</body>
</html>