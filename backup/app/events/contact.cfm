<!--- event: contact --->
<cfif structKeyExists(form,'email')>
	<!--- process ajax request --->
	<cfset devLog("#form.email#, #form.yourName#, #form.comments#")>
	<!--- todo: add email function to app --->
<cfelse>
	<!--- include views --->
	<cfset pageTitle = "Get in Touch">
	<cfinclude template="../views/contact.cfm">
</cfif>