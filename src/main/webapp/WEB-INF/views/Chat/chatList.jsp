<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chat List</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.3.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<style>
	/* COMMON */
	*{
		box-sizing: border-box;
		padding: 0px;
		margin: 0px;
	}
 	div{
		/* border: 1px solid black; */
	} 
	.container{
		padding: 50px;
	}
	.row{
		--bs-gutter-x: 0rem;
	}
	/* ROOMLIST */
	.enter{
		cursor: pointer;
	}
	.roomName{
	  	overflow: hidden;
  		text-overflow: ellipsis;
  		white-space: nowrap;
  		width: 200px;
  		/* height: 20px; */
		display: block; 
	}
	img{
		margin-right: 10px;
	}
	.detail{
		width: 100%;
	}
</style>
</head>
<body>
	<div class="container">
		<div class="row">채팅방</div>
		<div class="row list">
			<c:choose>
				<c:when test="${roomList != null }">
					<c:forEach var="dto" items="${roomList}">
						<div class="row p-2 enter">
							<input type="hidden" class="roomNumber" value="${dto.getRoomNumber() }">
							<div class="col-12 d-flex roomInfo">
								<c:choose>
									<c:when test="${dto.getRoomName() == '' or dto.getRoomName() == null}">
										<img src="/img/chat2.png" class="col-2">
										<c:forEach var="Jdto" items="${roomJoinList}">
											<c:if test="${dto.getRoomNumber() == Jdto.getRoomNumber() and user.getUserName() != Jdto.getUserName()}">	
												<div class="row detail">
													<div class="row">${Jdto.getUserName() }</div>
													<c:if test="${list != null }">
														<c:forEach var="cDto" items="${list}" varStatus="status">
															<c:forEach var="uDto" items="${stateList }">
																<c:if test="${stateList != null }">
																	<c:if test="${cDto.getRoomNumber() == dto.getRoomNumber() == uDto.getRoomNumber()}">
																		<c:if test="${cDto.getUploadDate() > uDto.getOutTime() }">
																			<div class="col-10 message">${cDto.getMessage() }</div>
																			<div class="col-2 count">${status.count }</div>
																		</c:if>
																	</c:if>
																</c:if>
															</c:forEach>
														</c:forEach>
													</c:if>
												</div>
											</c:if>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<img src="/img/chat4.png" class="col-2">
										<div class="row detail">
											<div class="row">${dto.getRoomName() }</div>
											<div class="col-10 message"></div>
											<div class="col-2 count"></div>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>채팅방이 없습니다.</c:otherwise>
			</c:choose>
		</div>
		<div class="row">
			<input type="button" id="roomCreate" value="방 생성">
		</div>
		<div class="row">
			<input type="button" id="goChatHome" value="채팅 홈">
		</div>
	</div>
	
	<script>
		var socket = new SockJS("/wechat"); // 엔드포인트 주소 넣기
		var client = Stomp.over(socket); // 연결 이후 작업 처리하는 코드
		
		client.connect({},function(resp){ // {}는 헤더정보 없으면  빈 칸
			var count = 0;
			
			client.subscribe("/topic/chatList",function(msg){
				var result = JSON.parse(msg.body);
				
				$(".enter").each(function(i){
					   var roomNumber = $(this).children(".roomNumber").val();
					   
					   if(result.roomNumber == roomNumber){
						   var parent = $(this).children(".roomInfo").children(".detail");
						   /* var detail = roomInfo.children(".detail"); */
				
						   count += 1;
						   parent.children(".count").text(count);
						   parent.children(".message").text(result.message);
					   }
					});
				
				/* count += 1;			
				$(".list").append("<div class='row'>"+result.roomNumber+":"+count+"</div>"); */
			});
		});
		
		$(document).on("click",".enter",function(){
			var roomNumber = $(this).children(".roomNumber").val();
			location.href="/chatting/chatDetail?roomNumber="+roomNumber;
			//$("#main").load("chatDetail?roomNumber="+roomNumber);
		});
		$("#roomCreate").on("click",function(){
			var url = "/chatting/chatRoomCreatePage";
			var name = "roomCreate";
            var option = "width = 500, height = 500, top = 100, left = 200";
			window.open(url,name,option);
		});
		// 채팅홈으로 가기
		$("#goChatHome").on("click",function(){
			location.href="/chatting/chatHome";
		});
	</script>
</body>
</html>