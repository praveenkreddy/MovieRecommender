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
<title>Genre</title>
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link href="MoviePick.css" rel="stylesheet">
</head>
<body>

<%
Connection conn=null;
ResultSet genre_resultset1=null;
ResultSet movie_resultset=null;
ResultSet Final_movie_resultset=null;




try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");

	Statement statementG1 = conn.createStatement() ;
	
	
	//Top k-Movies
	String topMvsParam = request.getParameter("TopMoviesNum");
    System.out.println("Mov Prev:" + topMvsParam);
    if(topMvsParam == null)
    	topMvsParam = "10";
    System.out.println("Mov Now:" + topMvsParam);
    //Movies by Genre
    String GenrenameParam = request.getParameter("GenreName");
    System.out.println("Genrename Prev:" + GenrenameParam);
    if(GenrenameParam == null)
    	GenrenameParam = "Adventure";
    System.out.println("Genrename Now:" + GenrenameParam);
    movie_resultset = statementG1.executeQuery("select m.title,m.year,m.rtaudiencescore,m.SpanishTitle,m.rtAllCriticsScore,m.rtpictureurl,m.imdbpictureurl from movies m,genre g where m.id=g.movie_id and g.genre like '%"+GenrenameParam+"%' order by m.rtaudiencescore desc limit "+topMvsParam);
    Final_movie_resultset = movie_resultset;
    
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
<!-- By Genre -->
<form class="form-inline" action="Genre.jsp" method="post">
  <div class="form-group">
    <label for="Genre">Enter Genre</label>
    <input type="text" class="form-control" id="myMovieGenre" name="GenreName" placeholder="Movie Genre Type">
  </div>
  <!-- Top-k Genre Movies -->
  <div class="form-group">
    <label for="MovieNumber">Enter Top k-Number</label>
    <input type="text" class="form-control" id="myMovieNum" name="TopMoviesNum" placeholder="Positive Integer Value" >
  </div>
  <button type="submit" class="btn btn-default">Submit</button>
</form>

</div>
<div class="container">
<div class="grid-background">
<hr style="border-top: 3px solid #eeeeee; border-color: red;" >

<!-- div id ="demo" class="collapse"> -->

<% 
while(Final_movie_resultset.next()){ %>

<div class="row">
      <div class="col-md-4"">
	      <img src= <%=Final_movie_resultset.getString(6)%> alt="rtpictureurl" style="width:150px; height:150px" >
	      <img src= <%=Final_movie_resultset.getString(7)%> alt="imdbpictureurl" style="width:150px; height:150px">
      </div>
      <div class="col-md-8">
	      <h4>Title: <%=Final_movie_resultset.getString(1)%></h4>
	      <h4>Spanish Title: <%=Final_movie_resultset.getString(4)%></h4>
	      <h4>Year: <%=Final_movie_resultset.getString(2)%></h4>
	      <h4>Audience Score: <%=Final_movie_resultset.getString(3)%></h4>
	      <h4>Critics Score: <%=Final_movie_resultset.getString(5)%></h4>
	  </div>
</div>
       <hr style="border-top: 3px solid #eeeeee; border-color: red;" >
    <% } %>

</div>
</div>

</body>
</html>