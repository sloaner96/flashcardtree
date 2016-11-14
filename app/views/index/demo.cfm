regex demo<br>

<cfoutput>

<cfset tval = '<strong><p><span style="font-size: 14px; "><span style="font-family: ''Courier New''; "><div>b</div></span></span></p></strong>'>
<cfsavecontent variable="tval">
<div style="background-color: rgb(255, 255, 255); padding-top: 5px; padding-right: 5px; padding-bottom: 5px; padding-left: 5px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><p style="font-family: Arial, Verdana, sans-serif; "><span style="font-family: Arial; "><span style="font-size: 122px; "><span style="color: rgb(255, 102, 0); ">{front}</span></span></span></p></div>
</cfsavecontent>

<textarea rows="10" cols="80">#tval#</textarea>

<!--- strip span and p tags --->
<cfset tval = REReplaceNoCase( tval, "<(((span|p|div))|(\/+(span|p|div)))[^>]*>", "", "ALL" )>

<textarea rows="10" cols="80">#tval#</textarea>

</cfoutput>

<!---<cfset updatedCard = structNew()>
<cfset updatedCard.idCard = 49>
<cfset updatedCard.idUser = 4>
<cfset updatedCard.rating = 0>

<cfinvoke component="gateways.cards" 
          method="updateStats" 
					updatedCard="#updatedCard#">
--->
<!---json demo

<script>
function getNextCard() {
	
	//alert('getNextCard');
	$.getJSON("http://127.0.0.1/app/services/cards.cfc?method=getNextCard&idDeck=20",
  	function(data){
			alert('all good');
    });
		/*
	$.getJSON("http://127.0.0.1/app/services/cards.cfc?method=getNextCard&idDeck=20",
  	function(data){
			alert(data[0]);
			alert(data[1]);
			alert(data[2]);
    });
    */
				
}
</script>

<input type="button" onclick="getNextCard()" value="getNextCard">

<cfinvoke component="services.cards" 
          method="getNextCard" 
					idUser="4"
					idDeck="18" 
					returnvariable="tval" 
					newcardorder="0"
					newcardtiming="0"
					reviewOrder="2"
					reviewfailed="0"
					newcardmax="50">
					
<cfdump var="#tval#">--->