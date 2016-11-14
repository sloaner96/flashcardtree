<html>
<head>
<title>Flashcard Tree, Study with flashcards online for free</title>
<cfoutput>
<link rel="shortcut icon" type="image/png" href="#application.baseURL#public/img/flashcardtree_icon.png" />
</cfoutput> 
<!-- Load Jquery -->
<script src="/public/js/jquery-1.5.2.min.js" type="text/javascript"></script>
<!-- End Load -->

<link rel="stylesheet" type="text/css" href="/public/css/styles.css" />
<link rel="stylesheet" type="text/css" href="/public/css/forms.css" />

<!--- freeow --->
<link rel="stylesheet" type="text/css" href="/public/js/freeow/freeow.css" /> 
<script type="text/javascript" src="/public/js/freeow/jquery.freeow.js"></script> 

<style>

</style>

<cfajaximport tags="cfform,cftextarea,cftooltip,cfgrid">

<script type="text/javascript">
$(document).ready(function() {
    $('#btnSave').click(function() {
        addCheckbox($('#txtName').val());
    });
		
	$(document).keydown(function(e) {
		if (e.which == 27) closeCFWindows();
		//alert(e.which);
		<!--- one key 49 --->
		if (e.which == 49) $('#btnPass').click();
		<!--- zero key 96 --->
		if (e.which == 96) $('#btnFail').click();
	});

});

function closeCFWindows(){
	ColdFusion.Window.hide('editCardWindow');
	ColdFusion.Window.hide('addCardWindow');
	ColdFusion.Window.hide('addDeckWindow');
	ColdFusion.Window.hide('jpDictWindow');
}

</script>



<script type="text/javascript">
function setDashboardDeck(idDeck) {
	if (idDeck < 1) return;
	$('#dashboard_idDeck').val(idDeck);
}

function displayMessage(message) {
	//freeow demo
	title = 'Message';
	
	opts = {};
	opts.classes = ['smokey'];

	container = '#freeow-tr';
	$(container).freeow(title, message, opts);
}

function addCheckbox_add() {
	
	name = $('#addCheckboxName_add').val();
	if (name == '') return;

	//alert(name);
	//return;
	tagExists = 0;
	$('#cblist_add input[type=checkbox]').each(function () {
		//alert(this.next());
		//tval = $("label[for='" + this.id + "']");
		//alert($(this).attr('checked'));
		//alert($(this).val().trim());
		//alert('name=' + name);
		//alert($(this).next().text());
		
		if ($(this).next().text() == name) {
			tagExists = 1;
			if ($(this).attr('checked') == false) $(this).attr('checked',true);
		}
	});
	
	if (tagExists == 1) return;
	
	//tval = $("#cb1").next();
	//alert(tval.text());

	//alert('ok');
	//return;
	
   var container = $('#cblist_add');
   var inputs = container.find('input');
   var id = inputs.length+1;
   var html = '<input type="checkbox" name="tags" id="cb_add'+id+'" value="'+encodeURIComponent(name)+'" checked /> <label for="cb_add'+id+'" class="tags">'+name+'</label><br>';
   container.append($(html));
}
function addCheckbox_edit() {
	name = $('#addCheckboxName_edit').val();
	if (name == '') return;

	//alert(name);
	//return;
	tagExists = 0;
	$('#cblist input[type=checkbox]').each(function () {
		//alert(this.next());
		//tval = $("label[for='" + this.id + "']");
		//alert($(this).attr('checked'));
		//alert($(this).val().trim());
		//alert('name=' + name);
		//alert($(this).next().text());
		
		if ($(this).next().text() == name) {
			tagExists = 1;
			if ($(this).attr('checked') == false) $(this).attr('checked',true);
		}
	});
	
	if (tagExists == 1) return;
	
	//tval = $("#cb1").next();
	//alert(tval.text());

	//alert('ok');
	//return;
	
   var container = $('#cblist');
   var inputs = container.find('input');
   var id = inputs.length+1;
   var html = '<input type="checkbox" name="tags" id="cb_edit'+id+'" value="'+encodeURIComponent(name)+'" checked /> <label for="cb_edit'+id+'" class="tags">'+name+'</label><br>';
   container.append($(html));
}
</script>

<script type="text/javascript">
function GetInnerSize () {
	var x,y;
	if (self.innerHeight) // all except Explorer
	{
		x = self.innerWidth;
		y = self.innerHeight;
	}
	else if (document.documentElement && document.documentElement.clientHeight)
		// Explorer 6 Strict Mode
	{
		x = document.documentElement.clientWidth;
		y = document.documentElement.clientHeight;
	}
	else if (document.body) // other Explorers
	{
		x = document.body.clientWidth;
		y = document.body.clientHeight;
	}

	//alert(x);
	//alert(y);
	
	return [x,y];
}
</script>

<script>
function editCard(idCard){
	
	//alert('hi ' + idCard);
	//alert(isNaN(idCard));
	//return;
	if (idCard == null) return;
	ColdFusion.Window.show('editCardWindow');	
	ColdFusion.navigate('/?event=cards.edit&idCard=' + idCard,'editCardWindow',success,fail);
	ColdFusion.objectCache['cardGrid'].selectedRow=-1;
}
function viewDeck(idDeck){
	<cfoutput>
	window.location.href = '#nav("dashboard.home")#&idDeck=' + idDeck + '&tab=stats';
	</cfoutput>
}
function reviewDeck(idDeck){
	selectTab('decksStudy');
	<!---<cfoutput>
	if (idDeck > 0) {
  	window.location.href = '#nav("dashboard.home")#&idDeck=' + idDeck + '&tab=study';
  }
	</cfoutput>--->
}
function fail(){
	//alert('editCardFail');
}
function success(){
	//alert('editCardSuccess');
}
function addCard(id){
	//alert('hi ' + idCard);
	//alert(isNaN(idCard));
	//return;
	//alert($("#idDeck option:selected").val());
	ColdFusion.Window.show('addCardWindow');	
	//ColdFusion.navigate('/?event=cards.add&idDeck=' + $("#idDeck option:selected").val(),'addCardWindow',success,fail);
	ColdFusion.navigate('/?event=cards.add&idDeck=' + id,'addCardWindow',success,fail);
}
function addDeck(id){
	ColdFusion.Window.show('addDeckWindow');	
	ColdFusion.navigate('/?event=decks.add&idDeck=' + id,'addDeckWindow',success,fail);
}
function jpDictionaryWindow() {
	<cfoutput>
	ColdFusion.Window.show('jpDictWindow');	
	ColdFusion.navigate('#nav('jpDictionary.search')#&embedded=1','jpDictWindow',success,fail);
	</cfoutput>
}

init = function() {
    //ColdFusion.Window.show('loginwindow');
		//alert('init');
}
</script>

<script>
// dictionary functions
function addDictionaryCard(id) {
	front = $("#entry" + id + "_front").html();
	back = $("#entry" + id + "_back").html();
	// wrap the card back in a table
	back = '<table align="center"><td>' + back + '</td></table>';
	//alert(encodeURI(back));
	ColdFusion.Window.show('addCardWindow');	
	ColdFusion.navigate('/?event=cards.add&idDeck=' + $("#dashboard_idDeck").val() + '&front=' + encodeURI(front) + '&back=' + encodeURI(back),'addCardWindow',success,fail);
}
</script>

</head>
<body>

<div id="freeow-tr" class="freeow freeow-top-right"></div> 

<!---
<img src="/public/img/logo1.jpg" width="640"><br>
<img src="/public/img/logo2.jpg" width="640"><br>
<img src="/public/img/logo3.jpg" width="640"><br>
<img src="/public/img/logo4.jpg" width="640"><br>
--->
				<!---
<img src="/public/img/logo1.jpg" width="640"><br>
<img src="/public/img/logo2.jpg" width="640"><br>
<img src="/public/img/logo3.jpg" width="640"><br>
<img src="/public/img/logo4.jpg" width="640"><br>
--->
<!---
<img src="/public/img/flashcardtree_icon.jpg" height="100">
<img src="/public/img/logo3.jpg" height="100">
<br>
<img src="/public/img/logo2.jpg" height="75">
<img src="/public/img/logo7.jpg" height="75">
--->
   <!---     
<a href="#nav('index.home')#">
<img src="/public/img/logo1.jpg" width="400" border="0">
</a>      
<ul> 
<li><a href="#nav('dashboard.home')#">Flashard Decks</a></li> 
<li><a href="#nav('cards.browse')#">Browse / edit cards</a></li> 
<li><a href="#nav('decks.add')#">Add a new deck</a></li> 
<li class="last"><a href="javascript:addCard();">Add a new card</a></li>

<cfif getDO("users").isAuthenticated()> 
<li class="last"><a href="#nav('user.logout')#">Logout</a></li>
</cfif>
 
</ul>   	
--->

<cfset isAuthenticated = getDO("users").isAuthenticated()>
<cfif isAuthenticated>
	<cfset userDecks = getDO("decks")>
	<cfset decks = userDecks.getRecord()>
</cfif>

<div style="width:100%;padding:0px;background-color:white;">

	<!---
	<cfoutput>
	<a href="#nav('dashboard.home')#"><img src="/public/img/icon.png" height="20" style="padding:10px;" border="0"></a>
	</cfoutput>
	<br>

<cfset tval = '<img src="/public/img/icon.png" height="20" style="padding:10px;" border="0">'>
<cfmenu childstyle="height:32px" bgcolor="a0a0a0" fontcolor="282828" selectedfontcolor="9dd31f" selecteditemcolor="555554" font="Verdana" fontsize="16" menustyle="background:url('/public/img/menubg3.png');height:32px;padding-top:5px;font-size:100%;">
--->
<cfmenu childstyle="height:35px" bgcolor="a0a0a0" fontcolor="282828" selectedfontcolor="9dd31f" selecteditemcolor="555554" font="Verdana" fontsize="16" menustyle="background:url('/public/img/menubg3.png');height:32px;padding:5px;">
	
	<cfif isAuthenticated>
		<cfmenuitem display="&nbsp;" image="/public/img/flashcardtree_icon.png" href="#nav('dashboard.home')#" childstyle="width:400px;">
		</cfmenuitem>
	</cfif>	
		
	<cfmenuitem display="Flashcard Decks" href="#nav('dashboard.home')#" childstyle="width:400px;">
		<cfif isAuthenticated>
			<cfloop query="decks">
				<cfmenuitem display="#decks.deckName#" href="#navDeck('dashboard.home',decks.idDeck)#" />
			</cfloop>
		</cfif>
	</cfmenuitem>
	
		<cfif isAuthenticated>
		<cfmenuitem display="Browse Cards" href="#nav('cards.browse')#" />
		<cfmenuitem display="Add Cards" href="javascript:addCard($('##dashboard_idDeck').val());" />
	</cfif>
	
	<cfmenuitem display="Dictionary" childstyle="width:400px;">
		<cfif event EQ 'decks.study'>
		<cfelse>
		</cfif> 
		<cfmenuitem display="Japanese-English Dictionary" href="#nav('jpDictionary.search')#" />
		<cfmenuitem display="Japanese-English Dictionary" href="javascript:jpDictionaryWindow();" />
	</cfmenuitem>
	
	<cfif isAuthenticated>
		<cfmenuitem display="Settings" />
		<cfmenuitem display="Logout" href="#nav('user.logout')#" />
	<cfelse>
		<cfmenuitem display="Login" href="#nav('user.login')#" />
	</cfif>
	<cfmenuitem display="cfc refresh" href="#nav('index.appRefresh')#&refresh" />
</cfmenu>

<cfif NOT isAuthenticated>
	<cfoutput>
	<a href="#nav('dashboard.home')#"><img src="/public/img/logo.png" style="padding:10px;" border="0"></a>
	</cfoutput>
	<br>
</cfif>

</div>

<div style="margin:10px;clear:both;padding:10px;">
