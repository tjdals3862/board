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
	        const keyword = $("#keyword").val(); // �˻��� ��������
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
	                // ���� ó��
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
	    		alert("�ƹ��͵� �������� �ʾҽ��ϴ�")
	    	} else if(selectedValues.length > 1) {
	    		alert("�ϳ��� �����ϼ���")
	    	} else {
	    		console.log(selectedValues[0]) // üũ�ڽ��� ID��
	    		
	    		const board = {
	    			bno: selectedValues[0]
	    		}	    		
	    		
	 	        $.ajax({
		            type: "POST",
		            url: "/board/delete", 
		            data:JSON.stringify(board), // ������ ������
		            contentType: "application/json",
		            success: function(response) {
		                console.log(response); // ����: �ֿܼ� ���� �α� ���
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
	        	alert('�ϳ��� �������ּ���.');
	        }	        	        
	        else {
	            alert('���õ� �׸��� �����ϴ�.');
	        }
	    	
	    	
	    }
	    
	</script>
	
	<div class="container" style="position: relative;">
	    <div class="page-header">
	    </div>
	    <h2 style="margin-top: 30px;">��������</h2>
	    <div class="row">
			<select id="searchOption" class="form-select" aria-label="Default select example">
			  <option selected>Open this select menu</option>
			  <option value="��ü">��ü</option>
			  <option value="���̵�">���̵�</option>
			  <option value="����">����</option>
			  <option value="�ۼ���">�ۼ���</option>
			</select>
	        <div class="col-5">
	            <input type="text" id="keyword" class="form-control" placeholder="�˻�� �Է��ϼ���" 
	                aria-label="�˻�� �Է��ϼ���" aria-describedby="btn_search"  />
	        </div>
	        <div class="col-3">	            	            
	            <button type="button" class="btn btn-primary" onclick="boardSearch();">�˻�</button>	            
	            <button type="button" class="btn btn-primary" onclick="boardmodify()">�����ϱ�</button>	            
	            <button type="button" class="btn btn-primary" onclick="boardDelete()">�����ϱ�</button>	            
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
            	int pageSize = 5; // �� �������� ������ ������ ��
            	int totalSize = boardList.size(); // ��ü ������ ��
            	int totalPages = (int) Math.ceil((double) totalSize / pageSize);// ��ü ������ �� 
            	int currentPage = 1; // ���� ������ (ù ��° �������� �ʱ�ȭ)       
            %>
            
			<% if (request.getParameter("page") != null) { // ������ �Ķ���Ͱ� ���޵Ǿ��� ���, ���� �������� ���� %>
			    <% currentPage = Integer.parseInt(request.getParameter("page")); %>
			<% } %>      
			<% int startIndex = (currentPage - 1) * pageSize; // ���� �ε��� (���� �������� �ش��ϴ� ������ ���� �ε���) %>
			<% int endIndex = Math.min(startIndex + pageSize, totalSize); // ���� �ε��� (���� �������� �ش��ϴ� ������ ���� �ε���) %>       
			
            <% SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); %>
			<% for (int i = startIndex; i < endIndex; i++) { // ���� �������� �ش��ϴ� �����͸� ��� %>
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
		            <li class="page-item"><a class="page-link" href="?page=1">ó��</a></li>
		            <li class="page-item"><a class="page-link" href="?page=<%= currentPage - 1 %>">����</a></li>
		        <% } else { %>
		            <li class="page-item disabled"><a class="page-link" href="#">ó��</a></li>
		            <li class="page-item disabled"><a class="page-link" href="#">����</a></li>
		        <% } %>
		
		        <% int startPage = Math.max(1, currentPage - 2); // ���� ������
		           int endPage = Math.min(startPage + 4, totalPages); // ���� ������
		
		           for (int pageNumber = startPage; pageNumber <= endPage; pageNumber++) { %>
		            <% if (pageNumber == currentPage) { %>
		                <li class="page-item active"><a class="page-link" href="#"><%= pageNumber %></a></li>
		            <% } else { %>
		                <li class="page-item"><a class="page-link" href="?page=<%= pageNumber %>"><%= pageNumber %></a></li>
		            <% } %>
		        <% } %>
		
		        <% if (currentPage < totalPages) { %>
		            <li class="page-item"><a class="page-link" href="?page=<%= currentPage + 1 %>">����</a></li>
		            <li class="page-item"><a class="page-link" href="?page=<%= totalPages %>">������</a></li>
		        <% } else { %>
		            <li class="page-item disabled"><a class="page-link" href="#">����</a></li>
		            <li class="page-item disabled"><a class="page-link" href="#">������</a></li>
		        <% } %>
		    </ul>
		</nav>
			
			
        </tbody>
    </table>
</body>
</html>