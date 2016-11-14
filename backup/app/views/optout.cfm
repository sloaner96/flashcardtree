<cfset pageTitle = "Opt-out">
<cfset pageSubTitle = "">
<cfinclude template="_header.cfm">

<div class="main-content">
	<div class="containit">
		<div class="full-width clearfix pt0">
			<div class="pt20">
				<h1>E-mail Opt-out</h1>
				If you no longer wish to be contacted by us please complete the form below.
				
				<cfif isDefined("form.email")>
					<cfoutput>
					<p class="notification">Your email address has been removed from our mailing list.  <a href="#Nav('newsletter')#">Click here to re-join.</a></p>
					</cfoutput>
				<cfelse>
				
              <div class="full-width pt20">
                 <div class="padright">
                 
								 		<cfoutput>
                  		<form action="#Nav('optout')#" id="newsletterForm" method="post">
                 		</cfoutput>
								 
								  			<ol class="forms">
                  				<li>
                                    <label for="email">Email <span class="required">*</span></label>
                  					<input type="text" name="email" id="email" value="" class="requiredField email" style="width:430px;"/>
                                </li>

                  				<li class="screenReader">
                                    <label for="checking" class="screenReader">If you want to submit this form, do not enter anything in this field</label>
                                    <input type="text" name="checking" id="checking" class="screenReader" value="" />
                                </li>
                            </ol>
                            <div class="clear"></div>
                            <div><input type="hidden" name="submitted" id="submitted" value="true"/></div>

                            <div class="form-button-left"><button type="submit" class="form-button"><span>Unsubscribe</span></button></div>
                  		</form>

                        <!--<p class="success"><strong>Thanks!</strong> Your email was successfully sent.  We should be in touch soon.</p>
                        <p class="errors"><strong>Ooops!</strong> There was an error somewhere. Please retry or mail the geeks.</p>
                        <p class="notification"><strong>Please note!</strong> You should lorem <a href="#">Mauris</a> dictum libero id justo.</p>-->
                </div>
              </div>
				</cfif>

			</div>
		</div>
	</div>
</div>

<cfinclude template="_footer.cfm">