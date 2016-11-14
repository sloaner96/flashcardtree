
		<cfquery datasource="#application.dsn#" name="getUser">
		select * from USERS
		</cfquery>
		<cfdump var="#getUser#">
