<cfparam name="loginMessage" default="">

<p>please log in to view this page</p>

<cfif loginMessage NEQ "">
	<cfoutput>#loginMessage#</cfoutput>
</cfif>

<cfform method="post" action="#nav('user.login')#" name="flogin">
	username <cfinput type="text" name="email"> <br>
	password <cfinput type="password" name="password"> <br>
	<cfinput type="submit" name="fsubmit" value="log in">
</cfform>
<!---
dumping app 
<cfoutput>#usersRecord.getRedirect()#</cfoutput>
--->