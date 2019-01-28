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
<title>YourRecommendation</title>
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
ResultSet director_resultset1=null;
ResultSet dir_movie_resultset=null;

try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");
	Statement statementRD1 = conn.createStatement() ;
	Statement statementRD3 = conn.createStatement() ;

	
String[] MvsNoParam = request.getParameterValues("MoviesNum");
for(int i=0;i<MvsNoParam.length;i++){
	System.out.println(i);
	System.out.println(" Mov# :" + MvsNoParam[i]);
	
}

genre_resultset1 = statementRD1.executeQuery("select distinct genre from genre where movie_id IN ("+MvsNoParam[0]+","+MvsNoParam[1]+")");
director_resultset1 = statementRD3.executeQuery("select directorname from director where movie_id IN ("+MvsNoParam[0]+","+MvsNoParam[1]+")");



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
<hr></hr>
<div class="dircontent">
<ul class="list-group">
<h2 style="color:blue"><u>Top 5 In Each Genre</u></h2>
<%  while(genre_resultset1.next()){ %>

	<h4 style="color:red">Top 5 In <%=genre_resultset1.getString(1) %></h4>
	<% 
		String CombinedGenre=genre_resultset1.getString(1);
		Statement statementRD2 = conn.createStatement() ;
		movie_resultset=statementRD2.executeQuery("select m.title from genre g,movies m where m.id=g.movie_id and g.genre like '%"+CombinedGenre+"%' order by m.rtaudiencescore desc limit 5");
while(movie_resultset.next()){ %>
	        <li class="list-group-item"><a href="test.html"><%=movie_resultset.getString(1)%></a></li>
	    <% } %>
	 </ul>	
	
<% 
}

%>
 </div>	
<div class="actorcontent">
<ul class="list-group">
<h2 style="color:blue"><u>Top 5 Of Each Director</u></h2>
<%  while(director_resultset1.next()){ %>

	<h4 style="color:red">Top 5 of <%=director_resultset1.getString(1) %></h4>
	<% 
		String combinedDirectors=director_resultset1.getString(1);
		Statement statementRD4 = conn.createStatement() ;
		dir_movie_resultset=statementRD4.executeQuery("select m.title from director d,movies m where m.id=d.movie_id and directorname like '%"+combinedDirectors+"%' order by m.rtaudiencescore desc limit 5");
while(dir_movie_resultset.next()){ %>
	        <li class="list-group-item"><a href="test.html"><%=dir_movie_resultset.getString(1)%></a></li>
	    <% } %>
	 </ul>	
	
<% 
}

%>
 </div>	

</body>
</html>