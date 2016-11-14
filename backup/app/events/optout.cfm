<!--- event: optout --->
<cfif structKeyExists(form,'email')>
	<!--- process request --->
	<cfset devLog("#form.email#, optout")>
	<!--- todo: add db function to app --->
</cfif>

<!--- include views --->
<cfinclude template="../views/optout.cfm">