<!---
<cfquery name="languageCodes" datasource="#application.dsn#">
select * from languageCodes order by langName_en
</cfquery>
--->
<cfinclude template="../_headerSimple.cfm">
<!---
<h2>Create a New Deck</h2>
<cinput type="button" name="fsubmit" value="test" class="submit-button" onclick="javascript:displayMessage('test');">
--->

<cfif isDefined("commit")>
<script>
try {
	ColdFusion.Grid.refresh('deckGrid',true);
	<cfoutput>
	displayMessage('#request.globalMessage#');
	</cfoutput>
	ColdFusion.Window.hide('addDeckWindow');
}
catch(e) {
}
</script>
</cfif>

<br>
<cfform method="post">

<div id="form-area">
<!---
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="create" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Window.hide('addDeckWindow');">
	<br>
--->
	<cfinclude template="includes/deckFormAdd.cfm">
	
	<br>
	<cfinput type="hidden" name="commit" value="1">
	<label for="fsubmit"></label>  <cfinput type="submit" name="fsubmit" value="create" class="submit-button">
	<cfinput type="button" name="fsubmit" value="cancel" class="submit-button" onclick="javascript:ColdFusion.Window.hide('addDeckWindow');">
</div>
</cfform>

<!--- <p>create a new deck</p>

<cfform method="post" action="#nav('decks.add')#" name="flogin">
	name <cfinput type="text" name="deckName"> <br>
	<cfinput type="submit" name="fsubmit" value="save">
</cfform>
 --->
 
<cfinclude template="../_footerSimple.cfm">