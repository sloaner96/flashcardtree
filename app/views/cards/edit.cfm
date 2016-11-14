<cfinclude template="../_headerSimple.cfm">
<!---
<h2>Edit Card</h2>
--->
<cfif request.globalMessage NEQ "">
	<cfoutput><p>#request.globalMessage#</p></cfoutput>
</cfif>

<cfif isDefined("commit")>
<script>
try {
	ColdFusion.Grid.refresh('cardGrid',true);
	<cfoutput>
	displayMessage('#request.globalMessage#');
	</cfoutput>
	ColdFusion.Window.hide('editCardWindow');
}
catch(e) {
}
</script>
</cfif>

<br>

<cfform method="post" action="#nav('cards.edit')#" name="fedit">

<div id="form-area">

	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="save" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Grid.refresh('cardGrid',true);ColdFusion.Window.hide('editCardWindow');">
	<br>
	
	<!--- _cardForm must be duplicated for a Chrome quickfix
	      duplicate checkbox ids and labels --->
	<cfinclude template="includes/_cardFormEdit.cfm">
	
	<br>
	<cfinput type="hidden" name="idCard" value="#request.idCard#">
	<cfinput type="hidden" name="commit" value="1">
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="save" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Grid.refresh('cardGrid',true);ColdFusion.Window.hide('editCardWindow');">
	
</div>

</cfform>

<cfinclude template="../_footerSimple.cfm">