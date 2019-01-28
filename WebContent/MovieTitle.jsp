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
<title>MovieTitle</title>
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link href="MoviePick.css" rel="stylesheet">
</head>
<body>

<%
Connection conn=null;
ResultSet Search_movie_resultset=null;
ResultSet SearchFirst_movie_resultset=null;



try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");
	Statement statementMST1 = conn.createStatement() ;
	Statement statementMST2 = conn.createStatement() ;

	
	//timelines of use
	String SearchMovieParam = request.getParameter("searchMovieTitle");
   // System.out.println("title Prev:" + SearchMovieParam);
    if(SearchMovieParam == null)
    	SearchMovieParam = "ToyStory";
    //System.out.println("titel Now:" + SearchMovieParam);
    SearchFirst_movie_resultset = statementMST2.executeQuery("select distinct(t.value),m.title,m.SpanishTitle,m.year,m.rtaudiencescore,m.rtpictureurl,m.imdbPictureURL,m.rtAudienceNumRating from movies m,movie_tags mt,tags t where t.id=mt.tagid and mt.movie_id=m.id and m.title like '%"+SearchMovieParam+"%' limit 1");
    Search_movie_resultset = statementMST1.executeQuery("select distinct(t.value) from movies m,movie_tags mt,tags t where t.id=mt.tagid and mt.movie_id=m.id and m.title like '%"+SearchMovieParam+"%'");
    //System.out.println(Search_movie_resultset.getString(1));
	
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
<div class="grid-background">
<hr style="border-top: 3px solid #eeeeee; border-color: red;" >

<div class="row">

      <div class="col-md-4"">
      <%  while(SearchFirst_movie_resultset.next()){ %>
	      <img src= <%=SearchFirst_movie_resultset.getString(6)%> alt="rtpictureurl" style="width:150px; height:150px" >
	      <img src= <%=SearchFirst_movie_resultset.getString(7)%> alt="imdbpictureurl" style="width:150px; height:150px">
	      
      </div>
      <div class="col-md-4">
	      <h4>Title: <%=SearchFirst_movie_resultset.getString(2)%></h4>
	      <h4>Spanish Title: <%=SearchFirst_movie_resultset.getString(3)%></h4>
	      <h4>Year: <%=SearchFirst_movie_resultset.getString(4)%></h4>
	      <h4>Audience Score: <%=SearchFirst_movie_resultset.getString(5)%></h4>
	       <h4>Number of Audience Rated: <%=SearchFirst_movie_resultset.getString(8)%></h4>
	      
	  <%} %>
	  </div>
	  <div class="col-md-4">
	      <a href="#" style="color:red"><u><b>MovieTags</b></u></a>
			<ul class="b">
				<ul class="list-inline">
				<%  while(Search_movie_resultset.next()){ %>
			       <li style="color:blue"><i>#<%=Search_movie_resultset.getString(1)%></i></li>
			     <% } %>
				   
				</ul>
			</ul>
	  </div>	
</div>
       <hr style="border-top: 3px solid #eeeeee; border-color: red;" >
   

</div>
</div>

</body>
</html>