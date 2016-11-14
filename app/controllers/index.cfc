<cfcomponent extends="baseController">

	<cffunction name="init" returntype="any" output="true">
		<cfset this.name = "index">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="appRefresh" returntype="void">
		<!--- application handles the cfc refresh so simply redirect and we're done --->
		<cflocation url="#cgi.http_referer#" addtoken="false">
	</cffunction>
	
</cfcomponent>