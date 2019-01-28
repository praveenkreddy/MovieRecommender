<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Recommendation</title>
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link href="MoviePick.css" rel="stylesheet">
</head>
<body>

<%
Connection conn=null;
//ResultSet genre_resultset1=null;
ResultSet movie_resultset=null;

try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");
	Statement statementR1 = conn.createStatement() ;
 
    movie_resultset = statementR1.executeQuery("select id,title,year,rtaudiencescore,spanishtitle,rtallcriticsscore,rtpictureurl,imdbpictureurl from movies order by rtaudiencescore desc limit 50");

	if(conn != null)
	{
		out.print("Connected");
	}	
   
}
catch (Exception e){
	out.print("Not Connected"+ e);
}
%>

<!-- top navigation bar -->

<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" class="active" href="index.jsp">MoviePick</a>
    </div>
    <ul class="nav navbar-nav">
      <li>
      	<a href="Genre.jsp"> Genre</a>
	  </li>
	   <li>
      	<a href=" Timelines.jsp"> TimeLines</a>
	  </li>
     <li>
      	<a href="Recommendation.jsp"> Recommendations</a>
	  </li>
    </ul>
    <form class="navbar-form navbar-right" action="MovieTitle.jsp" method="post">
      <div class="input-group">
    <input type="text" id="searchMovieTitle" name="searchMovieTitle" class="form-control" placeholder="Search your Movie Title">
    <div class="input-group-btn">
      <button class="btn btn-default" type="submit">
        <i class="glyphicon glyphicon-search"></i>
      </button>
    </div>
  </div>
  </form>
  </div>
</nav>
<hr>
<center><h4 ><u>select any 2 Movies and get more recommendations</u></h4></center>



<div class="container">
<div class="grid-background">
<hr style="border-top: 3px solid #eeeeee; border-color: red;" >

<%  


while(movie_resultset.next()){ %>

<form class="form-inline" action="FinalRecomend.jsp" method="post">
<div class="row">
      <div class="col-md-4"">
      	  <input type="checkbox" id="myCheck" name="MoviesNum" value="<%=movie_resultset.getString(1) %>">
	      <img src= <%=movie_resultset.getString(7)%> alt="rtpictureurl" style="width:150px; height:150px" >
	      <img src= <%=movie_resultset.getString(8)%> alt="imdbpictureurl" style="width:150px; height:150px">
      </div>
      <div class="col-md-8">
	      <h4>Title: <%=movie_resultset.getString(2)%></h4>
	      <h4>Spanish Title: <%=movie_resultset.getString(5)%></h4>
	      <h4>Year: <%=movie_resultset.getString(3)%></h4>
	      <h4>Audience Score: <%=movie_resultset.getString(4)%></h4>
	      <h4>Critics Score: <%=movie_resultset.getString(6)%></h4>
	      
	  </div>
</div>
       <hr style="border-top: 3px solid #eeeeee; border-color: red;" >
    <% } %>
<center><button type="submit" class="btn btn-default" style="background-color: #4CAF50">Recommend Me</button></center>
</form>
</div>
</div>

</body>
</html>