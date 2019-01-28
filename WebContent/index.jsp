<%@ page import="java.sql.*" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>Movie Pick</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link href="MoviePick.css" rel="stylesheet">
<script>
jQuery(document).ready(function() {
        
	jQuery('.carousel[data-type="multi"] .item').each(function(){
		var next = jQuery(this).next();
		if (!next.length) {
			next = jQuery(this).siblings(':first');
		}
		next.children(':first-child').clone().appendTo(jQuery(this));
	  
		for (var i=0;i<2;i++) {
			next=next.next();
			if (!next.length) {
				next = jQuery(this).siblings(':first');
			}
			next.children(':first-child').clone().appendTo($(this));
		}
	});
        
});
</script>

<style>
.carousel-control.left, .carousel-control.right {
	background-image:none;
}

.img-responsive{
	width:100%;
	height:auto;
}

@media (min-width: 992px ) {
	.carousel-inner .active.left {
		left: -25%;
	}
	.carousel-inner .next {
		left:  25%;
	}
	.carousel-inner .prev {
		left: -25%;
	}
}

@media (min-width: 768px) and (max-width: 991px ) {
	.carousel-inner .active.left {
		left: -33.3%;
	}
	.carousel-inner .next {
		left:  33.3%;
	}
	.carousel-inner .prev {
		left: -33.3%;
	}
	.active > div:first-child {
		display:block;
	}
	.active > div:first-child + div {
		display:block;
	}
	.active > div:last-child {
		display:none;
	}
}

@media (max-width: 767px) {
	.carousel-inner .active.left {
		left: -100%;
	}
	.carousel-inner .next {
		left:  100%;
	}
	.carousel-inner .prev {
		left: -100%;
	}
	.active > div {
		display:none;
	}
	.active > div:first-child {
		display:block;
	}
}
</style>

</head>

<body>
<div class="container">


<%
Connection conn=null;
ResultSet genre_resultset=null;
ResultSet country_resultset=null;
ResultSet director_resultset=null;
ResultSet actor_resultset=null;
ResultSet top4movies_resultset=null;
ResultSet top8movies_resultset=null;
ResultSet top12movies_resultset=null;
ResultSet Title_resultset=null;
ResultSet TitleFirst_resultset=null;

try{
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Movies","root","praveenkr91");
	Statement statementI1 = conn.createStatement() ;
	Statement statementI2 = conn.createStatement() ;
	Statement statementI3 = conn.createStatement() ;
	Statement statementI4 = conn.createStatement() ;
	Statement statementI5 = conn.createStatement() ;
	Statement statementI6 = conn.createStatement() ; 
	Statement statementI7 = conn.createStatement() ; 
	Statement statementI8 = conn.createStatement() ; 
	Statement statementI9 = conn.createStatement() ; 
	
    genre_resultset =statementI1.executeQuery("SELECT distinct genre FROM Movies.Genre") ;
    country_resultset =statementI2.executeQuery("SELECT distinct country FROM Movies.Country") ;
    String directdMvsParam = request.getParameter("DirectedMoviesNum");
    //System.out.println("dir Prev:" + directdMvsParam);
    if(directdMvsParam == null)
    	directdMvsParam = "10";
   // System.out.println("dir Now:" + directdMvsParam);
    director_resultset = statementI3.executeQuery("select d.DirectorName,avg(m.rtAudienceScore) as Avgrating  from director d, movies m where m.Id=d.Movie_Id and d.Director_Id in (select d.Director_Id from director d group by d.Director_Id having count(d.Director_Id)>="+directdMvsParam+") group by d.Director_Id order by Avgrating desc limit 10");
    top4movies_resultset = statementI4.executeQuery("SELECT rtPictureURL FROM Movies.movies order by rtaudiencescore desc limit 4");
    top8movies_resultset = statementI5.executeQuery("SELECT rtPictureURL FROM Movies.movies order by rtaudiencescore desc limit 4 offset 4");
    top12movies_resultset = statementI6.executeQuery("SELECT rtPictureURL FROM Movies.movies order by rtaudiencescore desc limit 4 offset 8");
    
    String actedMvsParam = request.getParameter("ActedMoviesNum");
   // System.out.println("Act Prev:" + actedMvsParam);
    if(actedMvsParam == null)
    	actedMvsParam = "10";
    //System.out.println("Act now:" + actedMvsParam);
    actor_resultset= statementI7.executeQuery("select  a.ActorName, avg(m.rtAudienceScore) as Avgrating from actors a, movies m where m.Id= a.Movie_Id and a.Actor_Id in (select a.Actor_Id from actors a group by a.Actor_Id having count(a.Actor_Id)>=" + actedMvsParam + ") group by a.Actor_Id order by Avgrating desc limit 10");
    String TitleParam = request.getParameter("Movietitle");
    System.out.println("Act Prev:" + TitleParam);
     if(TitleParam == null)
    	 TitleParam = "Toy Story";
     System.out.println("Act now:" + TitleParam);
    Title_resultset= statementI8.executeQuery("select distinct(t.value),m.title,m.year,m.rtaudiencescore,m.rtpictureurl,m.imdbpictureurl from movies m,user_taggedmovies ut,tags t where t.id=ut.tagid and ut.movie_id=m.id and m.title like '%"+TitleParam+"%'");
    TitleFirst_resultset=statementI9.executeQuery("select distinct(t.value),m.title,m.year,m.rtaudiencescore,m.rtpictureurl,m.imdbpictureurl from movies m,user_taggedmovies ut,tags t where t.id=ut.tagid and ut.movie_id=m.id and m.title like '%"+TitleParam+"%' limit 1");
    System.out.println(TitleFirst_resultset);
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

<!--The main div for carousel-->
<div class="container text-center">
	<div class="carousel slide row" data-ride="carousel" data-type="multi" data-interval="2000" id="moviecarousel">

    <div class="carousel-inner">
    
        <div class="item active">
	        <%  while(top4movies_resultset.next()){ %>
	        <div class="col-md-3 col-sm-4 col-xs-12"><a href="MovieDetails.jsp"><img src= <%=top4movies_resultset.getString(1)%> class="img-responsive"></a></div>
	        <% } %></div>
	        <div class="item">
	        <%  while(top8movies_resultset.next()){ %>
	        <div class="col-md-3 col-sm-4 col-xs-12"><a href="MovieDetails.jsp"><img src= <%=top8movies_resultset.getString(1)%> class="img-responsive"></a></div>
	        <% } %>
	        </div>
	        <div class="item">
	        <%  while(top12movies_resultset.next()){ %>
	        <div class="col-md-3 col-sm-4 col-xs-12"><a href="MovieDetails.jsp"><img src= <%=top12movies_resultset.getString(1)%> class="img-responsive"></a></div>
	        <% } %>
        </div>
        
     </div>
   

    <a class="left carousel-control" href="#moviecarousel" data-slide="prev"><i class="glyphicon glyphicon-chevron-left"></i></a>
    <a class="right carousel-control" href="#moviecarousel" data-slide="next"><i class="glyphicon glyphicon-chevron-right"></i></a> 

	</div>
</div>
<hr>
<div class="dircontent" >
	<h2>Top Directors</h2>
	<form action="index.jsp" method="post">
	   <div class="input-group">
		    <input type="text" name="DirectedMoviesNum" id="directedMoviesNum" class="form-control" placeholder="Number of Movies Directed">
		    <div class="input-group-btn">
			      <button class="btn btn-default" onclick="myFunction" type="submit">
			        <i class="glyphicon glyphicon-search"></i>
			      </button>
		    </div>
		</div>
	</form>		
  <ul class="list-group">
    <%  while(director_resultset.next()){ %>
        <li class="list-group-item"><a href="test.html"><%= director_resultset.getString(1)%></a></li>
    <% } %>
  </ul>
</div>
<div class="actorcontent">
	<h2>Top Actors</h2>
	<form action="index.jsp" method="post">
		<div class="input-group">
		    <input type="text" name="ActedMoviesNum" id="ActedMoviesNum" class="form-control" placeholder="Number of Movies Acted">
		    <div class="input-group-btn">
			      <button class="btn btn-default" type="submit">
			        <i class="glyphicon glyphicon-search"></i>
			      </button>
		    </div>
		</div>
	
	</form>
	<ul class="list-group">
	    <%  while(actor_resultset.next()){ %>
	        <li class="list-group-item"><a href="test.html"><%= actor_resultset.getString(1)%></a></li>
	    <% } %>
	 </ul>
		
</div> 
<div class="moviecontent">
	<h2>Know Your Movie</h2>
	<form action="index.jsp" method="post">
		<div class="input-group">
		    <input type="text" name="Movietitle" id="Movietitle" class="form-control" placeholder="Enter Movie Title">
		    <div class="input-group-btn">
			      <button class="btn btn-default" type="submit">
			        <i class="glyphicon glyphicon-search"></i>
			      </button>
		    </div>
		</div>
	
	</form>
	<div class="panel-group">
		<div class="panel panel-info">
			<ul class="list-inline">
				<%  while(TitleFirst_resultset.next()){ %>
			      <li><img src= <%=TitleFirst_resultset.getString(5)%> alt="rtpictureurl" style="width:150px; height:150px" ></li>
	      			<li><img src= <%=TitleFirst_resultset.getString(6)%> alt="imdbpictureurl" style="width:150px; height:150px"></li>
			<hr></hr>
			     <li style="color:blue"><b>Title: <%=TitleFirst_resultset.getString(2)%></b></li>
	             <li style="color:blue"><b>Year: <%=TitleFirst_resultset.getString(3)%></b></li>
	      		 <li style="color:blue"><b>Audience Score: <%=TitleFirst_resultset.getString(4)%></b></li>
	      	  <% } %>
	    	</ul>
			
			<a href="#" style="color:red"><u><b>UserTags</b></u></a>
			<ul class="b">
				<ul class="list-inline">
				<%  while(Title_resultset.next()){ %>
			       <li style="color:#ff8c1a"><i>#<%=Title_resultset.getString(1)%></i></li>
			     <% } %>
				   
				</ul>
			</ul>
		</div>
	</div>	
		
</div> 
   
</div>


</body>
</html>