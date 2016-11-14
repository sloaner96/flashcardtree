<cfset pageTitle = "Newsletter">
<cfset pageSubTitle = "">
<cfinclude template="_header.cfm">

<div class="main-content">
	<div class="containit">
		<div class="full-width clearfix pt0">
			<div class="pt20">
				<h1>Monthly Newsletter</h1>
				Sign-up for our monthly newsletter to receive updates when we release new content.
				
				<cfif isDefined("form.email")>
					<cfoutput>
					<p class="success"><strong>Thanks!</strong> You are now subscribed to our monthly newsletter.  <a href="#Nav('optout')#">Click here to be removed.</a></p>
					</cfoutput>
				<cfelse>
				
              <div class="full-width pt20">
                 <div class="padright">
                 
								 		<cfoutput>
                  		<form action="#Nav('newsletter')#" id="newsletterForm" method="post">
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

                            <div class="form-button-left"><button type="submit" class="form-button"><span>Subscribe</span></button></div>
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