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