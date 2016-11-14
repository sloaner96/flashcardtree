<cfcomponent output="true">
	<cffunction name="init" returntype="any">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getUserRecord" returntype="query">
		<cfargument name="email" required="true">
		<cfargument name="password" required="true">
		<cfquery datasource="#application.dsn#" name="getUser">
		select idUser, email, password from users 
		where email = <cfqueryparam value="#arguments.email#"> and password = <cfqueryparam value="#arguments.password#">
		</cfquery>
		<cfreturn getUser>
	</cffunction>
	
</cfcomponent>