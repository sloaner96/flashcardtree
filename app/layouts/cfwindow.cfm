<html>
<head>
    <!-- Load Jquery -->
    <script src="/public/js/jquery-1.5.2.min.js" type="text/javascript"></script>
    <!-- End Load -->
</head>
<body>

<!--- cfwindow layout --->
<cfif isDefined("panel1")>
	<cfif fileExists(expandPath('./') & 'app\views\' & panel1 & '.cfm')>
		<cfinclude template="../views/#panel1#.cfm">
	</cfif>
</cfif>

</body>
</html>