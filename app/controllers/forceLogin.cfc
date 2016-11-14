<cfcomponent extends="baseController">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "forceLogin">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="process" returntype="void" output="true">
		<!--- get data objects --->
		<cfset userRecord = getDO("users")>
		<cfif userRecord.isAuthenticated()>
			<!--- continue processing this request --->
			<cfset this.super = super>
			<cfset this.super.process(argumentCollection=arguments)>
		<cfelse>
			<!--- force login --->
			<!---
			<cfdump var="#cgi#"><cfabort>
			--->
			<cfset userRecord.setRedirect("?#cgi.query_string#")>
			<cfset callEvent("user.login")>
		</cfif>
	</cffunction>
	
</cfcomponent>