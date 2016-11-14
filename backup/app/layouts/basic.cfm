<!---basic layout
<br>--->
<cfinclude template="../views/_header.cfm">
<cfif isDefined("panel1")>
	<cfif fileExists(expandPath('./') & 'app\views\' & panel1 & '.cfm')>
		<cfinclude template="../views/#panel1#.cfm">
	</cfif>
</cfif>
<cfinclude template="../views/_footer.cfm">