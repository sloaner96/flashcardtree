<cfparam name="loginMessage" default="">

<h2>Log In</h2>

<cfif request.globalMessage NEQ "">
	<cfoutput><p>#request.globalMessage#</p></cfoutput>
</cfif>

<br>

<div id="form-area">
<cfform method="post" action="#nav('user.login')#" name="flogin">
	<label for="email">E-Mail:</label>  <cfinput type="text" name="email"> <br>
	<label for="password">Password:</label>  <cfinput type="password" name="password"> <br>
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="log in" class="submit-button">
</cfform>
</div>

<!---
dumping app 
<cfoutput>#usersRecord.getRedirect()#</cfoutput>
		<div id="form-area"> 
			
			<form method="post" action="contactengine.php"> 
				<label for="Name">Name:</label> 
				<input type="text" name="Name" id="Name" /> 
				
				<label for="City">City:</label> 
				<input type="text" name="City" id="City" /> 
	
				<label for="Email">Email:</label> 
				<input type="text" name="Email" id="Email" /> 
				
				<label for="Message">Message:</label><br /> 
				<textarea name="Message" rows="20" cols="20" id="Message"></textarea> 
 
				<input type="submit" name="submit" value="Submit" class="submit-button" /> 
			</form> 
			
			<div style="clear: both;"></div> 
			
			<p>Check out a <a href="http://css-tricks.com/examples/NiceSimpleContactForm2">version of this</a> with SPAM protection.</p> 
		
		</div> 
--->