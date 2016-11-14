<cfcomponent extends="controllers.baseController">
	<cffunction name="process" access="public" returntype="string" output="true" hint="Writes navigation links">
		<cfargument name="p1" type="string" required="true">
		<cfargument name="p2" type="any" required="false">
		<!--- p1 is the name of the navigation function --->
		<!--- p2 is simply a second parameter of any type --->
		<cfif NOT methodExists(this,"nav#arguments.p1#")>
			<cfreturn "#application.baseURL#?event=#arguments.p1#">
		<cfelseif isDefined("arguments.p2")>
			<cfreturn evaluate("nav#arguments.p1#(arguments.p2)")>
		<cfelse>
			<cfreturn evaluate("nav#arguments.p1#()")>
		</cfif>
	</cffunction>
</cfcomponent>