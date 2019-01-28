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
<title>MovieDetails</title>
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
ResultSet dir_movie_resultset=null;
ResultSet Actor_movie_resultset=null;
//ResultSet Title_movie_resultset=null;
ResultSet Tags_movie_resultset=null;
ResultSet Final_movie_resultset=null;


try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");
	Statement statementM1 = conn.createStatement() ;
	Statement statementM2 = conn.createStatement() ;
	Statement statementM3 = conn.createStatement() ; 
	Statement statementM4 = conn.createStatement() ; 
	//Statement statementM5 = conn.createStatement() ; 
	Statement statementM6 = conn.createStatement() ; 
	
	
	genre_resultset1 =statementM1.executeQuery("SELECT distinct genre FROM Movies.Genre") ;
	String topMvsParam = request.getParameter("TopMoviesNum");
    System.out.println("Mov Prev:" + topMvsParam);
    if(topMvsParam == null)
    	topMvsParam = "10";
    System.out.println("Mov Now:" + topMvsParam);
    movie_resultset = statementM2.executeQuery("select title,year,rtaudiencescore,spanishtitle,rtallcriticsscore,rtpictureurl,imdbpictureurl from movies order by rtaudiencescore desc limit "+topMvsParam);
    Final_movie_resultset=movie_resultset;
    //Movies By director
    String DirnameParam = request.getParameter("DirName");
    System.out.println("Dirname Prev:" + DirnameParam);
    if(DirnameParam == null)
    DirnameParam = "John Lasseter";
    System.out.println("Dirname Now:" + DirnameParam);
    dir_movie_resultset = statementM3.executeQuery("select title,year,rtaudiencescore,SpanishTitle,rtAllCriticsScore,rtpictureurl,imdbpictureurl from movies m,director d where d.movie_id=m.id and d.directorname like '%"+DirnameParam+"%'");
    Final_movie_resultset=dir_movie_resultset;
    //Movies By Actor
    String ActornameParam = request.getParameter("ActorName");
    System.out.println("ActorName Prev:" + ActornameParam);
    if(ActornameParam == null)
    	ActornameParam = "Annie Potts";
    System.out.println("ActorName Now:" + ActornameParam);
    Actor_movie_resultset = statementM4.executeQuery("select distinct(m.title),year,rtaudiencescore,SpanishTitle,rtAllCriticsScore,rtpictureurl,imdbpictureurl from movies m,actors a where m.id=a.movie_id and a.actorname like '%"+ActornameParam+"%'");
    Final_movie_resultset=Actor_movie_resultset;
    //Movies By Tag
    String TagnameParam = request.getParameter("TagName");
    System.out.println("TagName Prev:" + TagnameParam);
    if(TagnameParam == null)
    	TagnameParam = "earth";
    System.out.println("TagName Now:" + TagnameParam);
    Tags_movie_resultset = statementM6.executeQuery("select title,year,rtaudiencescore,SpanishTitle,rtAllCriticsScore,rtpictureurl,imdbpictureurl from movies m,movie_tags mt,tags t where t.id IN (select tags.id from tags where tags.Value like '%"+TagnameParam+"%') and  t.id=mt.tagid and mt.movie_id=m.id order by m.rtaudiencescore desc");
    Final_movie_resultset=Tags_movie_resultset;
	
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
	  <h4>Search Top Movies</h4>
	  <form action="MovieDetails.jsp" method="post">
	  <div class="input-group">
    	<input type="text" id="myMovieNum" name="TopMoviesNum" class="form-control" placeholder="Number of Movies">
	    <div class="input-group-btn">
	      <button  type="submit" class="btn btn-info" data-toggle="collapse" data-target="#demo">
	        <i class="glyphicon glyphicon-search"></i>
	      </button>
	    </div>
  	  </div>
  	  </form>
	</div>
	<!-- By Director -->
	<div class="genre col-sm-4 col-md-4 col-lg-3">
	<h4>Search By Director</h4>
	 <form action="MovieDetails.jsp" method="post">
	  <div class="input-group">
    	<input type="text" id="myMovieTitle" name="DirName" class="form-control" placeholder="Enter Your Director">
	    <div class="input-group-btn">
	      <button  type="submit" class="btn btn-info" data-toggle="collapse" data-target="#demo1">
	        <i class="glyphicon glyphicon-search"></i>
	      </button>
	    </div>
  	  </div>
  	  </form>
	</div>
	<!-- By Actors -->
	<div class="genre col-sm-4 col-md-4 col-lg-3">
	<h4>Search by Actor</h4>
	 <form action="MovieDetails.jsp" method="post">
	  <div class="input-group">
    	<input type="text" id="myMovieActor" name="ActorName" class="form-control" placeholder="Enter Your Actor">
	    <div class="input-group-btn">
	      <button  type="submit" class="btn btn-info" data-toggle="collapse" data-target="#demo2">
	        <i class="glyphicon glyphicon-search"></i>
	      </button>
	    </div>
  	  </div>
  	  </form>
	</div>
	<!-- By Tags -->
	<div class="genre col-sm-4 col-md-4 col-lg-3">
	<h4>Search by Tags</h4>
	 <form action="MovieDetails.jsp" method="post">
	  <div class="input-group">
    	<input type="text" id="myMovieTag" name="TagName" class="form-control" placeholder="Enter Your Tag">
	    <div class="input-group-btn">
	      <button  type="submit" class="btn btn-info" data-toggle="collapse" data-target="#demo3">
	        <i class="glyphicon glyphicon-search"></i>
	      </button>
	    </div>
  	  </div>
  	  </form>
	</div>
</div>
<div class="container">
<div class="grid-background">
<hr style="border-top: 3px solid #eeeeee; border-color: red;" >

<%  
if ( request.getParameter("TopMoviesNum")!=null)
	Final_movie_resultset=movie_resultset;
else if(request.getParameter("DirName")!=null)
	 Final_movie_resultset=dir_movie_resultset;
else if(request.getParameter("ActorName")!=null)
	 Final_movie_resultset=Actor_movie_resultset;
else if(request.getParameter("TagName")!=null)
	 Final_movie_resultset=Tags_movie_resultset;
else
	Final_movie_resultset=movie_resultset;

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