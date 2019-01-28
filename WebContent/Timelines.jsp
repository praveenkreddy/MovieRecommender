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
<title>Timelines</title>
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link href="MoviePick.css" rel="stylesheet">
</head>
<body>

<%
Connection conn=null;
ResultSet UserID_movie_resultset=null;
ResultSet UserID_GenreBreake_resultset=null;



try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");
	Statement statementTL1 = conn.createStatement() ;
	Statement statementTL2 = conn.createStatement() ;

	
	//timelines of use
	String userIDParam = request.getParameter("myuserID");
    System.out.println("title Prev:" + userIDParam);
    if(userIDParam == null)
    	userIDParam = "78";
    System.out.println("titel Now:" + userIDParam);
    UserID_movie_resultset = statementTL1.executeQuery("select distinct(m.Title)user_ratedmovies, u.Rating, concat(Date_year,'-',Date_Month,'-',Date_day,' ',Date_hour,':',Date_minute,':',Date_second) as RatedTime from user_ratedmovies u, movies m where m.id=u.Movie_Id and u.User_Id=" + userIDParam + " order by Date_year desc, Date_Month desc, Date_day desc, Date_hour desc, Date_minute desc, Date_second desc");
    UserID_GenreBreake_resultset = statementTL2.executeQuery("select (count(g.genre)*100/(select count(*) from genre g where g.Movie_Id in (select u.Movie_Id from user_ratedmovies u where  u.User_Id=" + userIDParam + " ))) as Percentage, g.genre from genre g where g.Movie_Id in (select u.Movie_Id from user_ratedmovies u where  u.User_Id=78)group by g.Genre");
	
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
<div class="container">
	<div class="genre col-sm-4 col-md-4 col-lg-3">
	  <h4>Search by userID</h4>
	  <form action="Timelines.jsp" method="post">
	  <div class="input-group">
    	<input type="text" id="myuserID" name="myuserID" class="form-control" placeholder="Enter UserID">
	    <div class="input-group-btn">
	      <button  type="submit" class="btn btn-info" data-toggle="collapse" data-target="#demo">
	        <i class="glyphicon glyphicon-search"></i>
	      </button>
	    </div>
  	  </div>
  	  </form>
	</div>
</div>
<hr></hr>
<div class="Moviesdetailelistcontent" >
	<h4><i>Movies Detailed List</i></h4>
<table>
  <tr>
    <th style="background-color:#ff9933">Title</th>
     <th style="background-color:#ff9933">Rating</th>
     <th style="background-color:#ff9933">Date-TimeStamp</th>
  </tr>
  <%  while(UserID_movie_resultset.next()){ %>
  <tr>
    <td><%= UserID_movie_resultset.getString(1)%></td>
    <td><%= UserID_movie_resultset.getString(2)%></td>
    <td><%= UserID_movie_resultset.getString(3)%></td>
 <%} %>
  </tr>
</table>
</div>
<div class="GenreBreakDowncontent">
	<h4><i>Genre BreakDown</i></h4>
	<table>
  <tr>
     <th style="background-color:#ff9933">Genre</th>
     <th style="background-color:#ff9933">Percetage</th>
  </tr>
  <%  while(UserID_GenreBreake_resultset.next()){ %>
  <tr>
    <td><%= UserID_GenreBreake_resultset.getString(2)%></td>
    <td><%= UserID_GenreBreake_resultset.getString(1)%></td>
 <%} %>
  </tr>
</table>

		
</div> 

</body>
</html>