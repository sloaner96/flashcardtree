<cfcomponent output="true">
	<cfset variables.instance = structNew()>
	<cffunction name="init" returntype="any">
		<cfset variables.instance = structNew()>
		<cfset variables.instance.record = "">
		<cfset variables.instance.authenticated = 0>
		<cfset variables.instance.redirect = "index.home">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setRecord" returntype="void">
		<cfargument name="record" default="">
		<cfset variables.instance.record = arguments.record>
		<cfset variables.instance.authenticated = 1>
	</cffunction>
	
	<cffunction name="isAuthenticated" returntype="boolean">
		<cfreturn variables.instance.authenticated>
	</cffunction>
	
	<cffunction name="setRedirect" returntype="void">
		<cfargument name="redirect" default="">
		<cfset variables.instance.redirect = arguments.redirect>
	</cffunction>
	
	<cffunction name="getRedirect" returntype="any">
		<cfreturn variables.instance.redirect>
	</cffunction>
	
	<cffunction name="methodExists" output="true">
		<cfargument name="tobj" type="any" required="true">
		<cfargument name="tmethod" type="string" required="false">
		<cfset amethods = getMetaData(arguments.tobj).functions>
		<cfset lmethods = "">
		<cfloop from="1" to="#arrayLen(amethods)#" index="i">
			<cfif amethods[i].name EQ tmethod>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfreturn false>
	</cffunction>

	<cffunction name="process" returntype="any" output="true">
		inside usersRecord process method
		<cfset var dataObjectMethod = listLast(arguments.dataObjectMethod,'.')>
		<cfif methodExists(this,dataObjectMethod)>
			<!--- call local method --->
			<!---
			returning <cfoutput>dataObjectMethod #dataObjectMethod#</cfoutput><br>
			--->
			<cfreturn evaluate("#dataObjectMethod#(argumentCollection=arguments)")>
		</cfif>
	</cffunction>
	
</cfcomponent>