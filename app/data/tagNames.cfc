<cfcomponent output="true">
	<cfset variables.instance = structNew()>
	<cffunction name="init" returntype="any">
		<cfset variables.instance = structNew()>
		<cfset variables.instance.record = "">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setRecord" returntype="void">
		<cfargument name="record" default="">
		<cfset variables.instance.record = arguments.record>
	</cffunction>
	
	<cffunction name="getRecord" returntype="query">
		<cfreturn variables.instance.record>
	</cffunction>
	
</cfcomponent>