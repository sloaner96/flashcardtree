<cfform name="fdashboard">
	<!---<cfinput type="text" name="idDeck" id="dashboard_idDeck" value="#request.idDeck#">--->
	<cfinput type="hidden" name="idDeck" id="dashboard_idDeck" value="#request.idDeck#">
</cfform>
<!---
<cfdump var="#form#">
<cfdump var="#variables.rc#">
<form name="fStudy" id="fStudy" method="post" action="/?event=index.test">
--->
<!---
<cfoutput>
<form name="fStudy" id="fStudy">
<input type="text" name="idDeck" value="#request.currentDeck.idDeck#">
<input type="text" name="idCard" value="#request.card.idCard#">
<input type="text" name="rating" id="rating" value="">
</form>
</cfoutput>
--->
<script type="text/javascript">
<cfoutput>
var idDeck = #request.idDeck#;
var idCard = #request.card.idCard#;
var newCardOrder = #request.newCardOrder#;
var newCardTiming = #request.newCardTiming#;
var reviewOrder = #request.reviewOrder#;
var reviewFailed = #request.reviewFailed#;
var newCardMax = #request.newCardMax#;
var waiting = 0;
</cfoutput>

$(document).ready(function(){
	//alert('ready');
	//display flashcard front
	$('#cardFront').show(0);
	
	// set screen size
	var inner = GetInnerSize();
	// viewable screen size
	screenWidth = inner[0];
	screenHeight = inner[1];
	screenRatio = screenWidth / screenHeight;
	
	// adjust position of review controls
	var newpos = screenHeight - $("#txtcontainer").height();
	$("#txtcontainer").animate({top:newpos,left:0},0);
	
	// bind review control buttons
	$('#btnFlip').click(function() {
	  //alert('Handler for .click() called.');
		//display flashcard back
		if ($("#cardFront").is(":visible")) {
			$('#cardBack').show(0);
			$('#cardFront').hide(0);
		}
		else {
			$('#cardFront').show(0);
			$('#cardBack').hide(0);
		}	
	});
	
	$('#btnPass').click(function() {
		if ($("#cardBack").is(":visible")) {
			//alert('pass');
			//$("#rating").val(1);
			rateCard(1);
			//$('#fStudy').submit();
		}
		else {
			// force the user to flip the card
			$('#btnFlip').click();
		}	
	});
	
	$('#btnFail').click(function() {
		if ($("#cardBack").is(":visible")) {
			//alert('pass');
			//$("#rating").val(0);
			rateCard(0);
			//$('#fStudy').submit();
		}
		else {
			// force the user to flip the card
			$('#btnFlip').click();
		}	
	});
	
});

$(document).keydown(function(e) {
	if (e.which == 32) $('#btnFlip').click();
});

function rateCard(rating) {
	
	//hide card
	//$('#cardBack').hide(0);
	if (waiting) return;
	waiting = 1;
	
	//alert('rateCard');
	<cfoutput>
	turl = "#application.baseURL#app/services/cards.cfc?method=rateCard&idCard=" + idCard + "&rating=" + rating;
	//turl = "http://127.0.0.1/app/services/cards.cfc?method=rateCard&idCard=43&rating=1";
	//alert(turl);
	//return;
	//getNextCard();
	/*
    */
	$.getJSON(turl,
  	function(data){
			getNextCard();
    });
	</cfoutput>
}

function getNextCard() {
	//alert('getNextCard');
	<cfoutput>
	turl = "#application.baseURL#app/services/cards.cfc?method=getNextCard&idDeck=" + idDeck + "&newCardOrder=" + newCardOrder + "&newCardTiming=" + newCardTiming + "&reviewOrder=" + reviewOrder + "&reviewFailed=" + reviewFailed + "&newCardMax=" + newCardMax;
	turl = "#application.baseURL#app/services/cards.cfc?method=getNextCard&idDeck=#idDeck#&newCardOrder=#newCardOrder#&newCardTiming=#newCardTiming#&reviewOrder=#reviewOrder#&reviewFailed=#reviewFailed#&newCardMax=#newCardMax#";
	</cfoutput>
	$.getJSON(turl,
  	function(data){
			//id alert(data[0]);
			if (data[0] == "") {
	  		resultsPage();
	  	}
			else {
				//alert(data[0]);
				//f  alert(data[1]);
				//b  alert(data[2]);
				// update form idCard
				idCard = data[0];
				// hide card
				$('#cardBack').hide(0);
				// update card and form data
				$("#cardFront").attr('innerHTML',data[1]);
				$("#cardBack").attr('innerHTML',data[2]);
				// show card
				$('#cardFront').show(0);
				waiting = 0;
			}
    });
}

function resultsPage() {
	<cfoutput>
	window.location.href = '#navDeckStats('dashboard.home',request.idDeck)#';
	</cfoutput>
}
</script>

<cfoutput>

<!--- strip span and p tags --->
<!---
<cfset tval = REReplaceNoCase( tval, "<(((span|p))|(\/+(span|p)))[^>]*>", "", "ALL" )>

<cfset tfront = replace(request.currentDeck.layoutFront,"{front}",frontFormatted)>
<cfset tfront = replace(tfront,"{back}",backFormatted)>

<cfset tback = replace(request.currentDeck.layoutBack,"{front}",frontFormatted)>
<cfset tback = replace(tback,"{back}",backFormatted)>
--->
<!---
<div id="cardFront" class="flashCard">
	#tfront#
</div>

<div id="cardBack" class="flashCard">
	#tback#
</div>

<cfdump var="#request#">
--->

<div id="cardFront" class="flashCard">
	#request.frontFormatted#
</div>

<div id="cardBack" class="flashCard">
	#request.backFormatted#
</div>


</cfoutput>


<!--- main menu --->
<!---
<div id="mainMenu" style="overflow:hidden;position:absolute;left:0px;top:0px;width:100%;height:50px;">
	<div style="overflow:auto;position:absolute;left:0px;top:0px;width:100%;height:50px;background-color:black;padding:3px;padding-left:20px;padding-top:0px;padding-right:14px;opacity:.9;filter:alpha(opacity=90);text-align:left;">
		
		<!---
		<img src="/public/img/flashcardtree_icon.jpg" height="50">
		--->
<ul>
<li><a href="#nav('dashboard.home')#">Flashard Decks</a></li> 
<li><a href="#nav('cards.browse')#">Browse / edit cards</a></li> 
<li><a href="#nav('decks.add')#">Add a new deck</a></li> 
<li class="last"><a href="javascript:addCard();">Add a new card</a></li>

<cfif getDO("users").isAuthenticated()> 
<li class="last"><a href="#nav('user.logout')#">Logout</a></li>
</cfif>
 
</ul>
		<div>
</div>

		
	</div>
</div>
--->


<!--- card review controls --->
<div id="txtcontainer" style="overflow:hidden;position:absolute;left:0px;top:0px;width:100%;height:100px;">
	<div style="overflow:auto;position:absolute;left:0px;top:24px;width:100%;height:100px;padding:3px;padding-left:0px;padding-top:12px;padding-right:14px;font-size:200%;text-transform:uppercase;font-weight:bold;font-family:Courier New, MS Mincho;opacity:.9;filter:alpha(opacity=90);text-align:center;">

		<input type="button" id="btnFail" value="Fail" class="red awesome" style="width:20%;">
		<input type="button" id="btnFlip" value="Flip" class="blue awesome" style="width:50%;">
		<input type="button" id="btnPass" value="Pass" class="green awesome" style="width:20%;">
		
	</div>
</div>