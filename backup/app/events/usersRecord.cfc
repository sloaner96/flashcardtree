<cfcomponent output="true">
	<cfset variables.instance = structNew()>
	<cffunction name="init" returntype="any">
		<cfset variables.instance = structNew()>
		<cfset variables.instance.authenticated = 0>
		<cfreturn this>
	</cffunction>
	<cffunction name="dump" returntype="void">
		<cfdump var="#variables#">
		<cfreturn>
	</cffunction>
	<cffunction name="isAuthenticated" returntype="boolean">
		<cfreturn variables.instance.authenticated>
	</cffunction>
</cfcomponent>