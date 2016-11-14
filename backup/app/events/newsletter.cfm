<!--- event: newsletter --->
<cfif structKeyExists(form,'email')>
	<!--- process request --->
	<cfset devLog("#form.email#, newsletter")>
	<!--- todo: add db function to app --->
</cfif>

<!--- include views --->
<cfinclude template="../views/newsletter.cfm">