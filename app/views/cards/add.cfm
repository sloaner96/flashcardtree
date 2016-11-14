<cfinclude template="../_headerSimple.cfm">
<!---
<h2>Create a New Card</h2>
--->
<cfif request.globalMessage NEQ "">
	<cfoutput><p>#request.globalMessage#</p></cfoutput>
</cfif>

<cfset request.front = trim(request.front)>
<cfset request.back = trim(request.back)>

<cfif ((isDefined("commit")) AND (request.globalMessage NEQ ""))>
<script>
try {
	ColdFusion.Grid.refresh('cardGrid',true);
}
catch(e) {
}
<cfoutput>
displayMessage('#request.globalMessage#');
</cfoutput>
ColdFusion.Window.hide('addCardWindow');
</script>
</cfif>

<br>

<cfform method="post" action="#nav('cards.add')#" name="fadd">

<div id="form-area">

	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="create" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Window.hide('addCardWindow');">
	<br>

	<cfinclude template="includes/_cardFormAdd.cfm">
	
	<br>
	<cfinput type="hidden" name="commit" value="1">
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="create" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Window.hide('addCardWindow');">
	
</div>

</cfform>

<cfinclude template="../_footerSimple.cfm">