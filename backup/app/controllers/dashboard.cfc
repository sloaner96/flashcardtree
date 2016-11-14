<cfcomponent extends="baseController">
	<cffunction name="process" returntype="void" output="true">
		<!--- get data objects --->
		<cfset usersRecord = getDO("usersRecord")>
		<cfif usersRecord.isAuthenticated()>
			<!--- continue processing this request --->
			<cfset this.super = super>
			<cfset this.super.process(argumentCollection=arguments)>
		<cfelse>
			<!--- force login --->
			<cfset usersRecord.setRedirect(arguments.event)>
			<cfset callEvent("user.login")>
		</cfif>
	</cffunction>
</cfcomponent>