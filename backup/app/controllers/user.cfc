<cfcomponent extends="baseController">
	<cffunction name="init" returntype="any">
		<cfreturn this>
	</cffunction>
	<cffunction name="login" returntype="void">
		<cfargument name="email" type="string" required="false" default="">
		<cfargument name="password" type="string" required="false" default="">
		<!--- get data objects --->
		<cfset usersRecord = getDO("usersRecord")>
		<cfif usersRecord.isAuthenticated()>
			<cfset callEvent(usersRecord.getRedirect())>
		<cfelseif arguments.password NEQ "">
			<cfquery datasource="#application.dsn#" name="getUser">
			select idusers, email, password from users 
			where email = <cfqueryparam value="#arguments.email#"> and password = <cfqueryparam value="#arguments.password#">
			</cfquery>
			<cfif getUser.recordCount EQ 1>
				<!--- success --->
				<!--- set user record --->
				<cfset usersRecord.setRecord(getUser)>
				<!--- call redirect --->
				<cfset callEvent(usersRecord.getRedirect())>
			<cfelse>
				<!--- failed login attempt --->
				<cfset loginMessage = "We weren't able to match the combination entered.  Please try again.">
				<cfset basicLayout("login")>
			</cfif>
		<cfelse>
			<cfset basicLayout("login")>
		</cfif>
	</cffunction>
</cfcomponent>