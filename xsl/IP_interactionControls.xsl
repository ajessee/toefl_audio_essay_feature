  <!--
  INTERACTION: Media Capture
  -->
  <xsl:template match="mediaCapture">
      <div class="media-capture-container">
        <style>
          .media-capture { border-top: 2px solid #000; padding-top: 10px; margin: 0 60px; }
          .time-table { margin: 0 auto; }
          .time-value { padding-left: 15px; }
          div.timer { width: 195px; margin: 10px auto; border: 1px solid #000;}
          div.timer-label { text-transform: uppercase; background-color: #000; color: #fff; font-weight: bold; font-size: 10pt; text-align: center; padding: 4px; }
          div.timer-countdown { font-size: 11pt; text-align: center; padding: 4px;}
          .media-capture-controls { text-align: center; }
          .media-capture-controls .media-capture-control { margin-top: 20px; display: inline-block; width: 91px; height: 40px; cursor: pointer; }
          .media-capture-controls .stop-recording { background: url('/apps/delivery/UI/AthenaFull/images/toefl-stop-recording-button.png'); }
          .media-capture-disclaimer { font-size: 8pt; margin: 20px 6px 25px; font-style: italic; }
          .inner-center-div {margin: 0 auto; width: 100%;}
        </style>
        <div class="media-capture">
          <xsl:if test="$mode = 'sim' or @hide = 'yes'">
            <xsl:attribute name="style">
              <xsl:value-of select="'display: none;'"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@hide">
            <xsl:attribute name="data-hide">
              <xsl:value-of select="@hide"/>
            </xsl:attribute>
          </xsl:if>
          <table class="time-table" cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td>Preparation Time:</td>
              <td class="time-value"><xsl:value-of select="@prepTime"/> Seconds</td>
            </tr>
            <tr>
              <td>Response Time:</td>
              <td class="time-value"><xsl:value-of select="@recordTime"/> Seconds</td>
            </tr>
          </table>

          <xsl:if test="$mode = 'review'">
            <div>
              <h4 class="media-capture-controls">Review your audio recording:</h4>
              <audio class="inner-center-div" id="s3audioplayer" controls="controls" preload="auto">
              <source id ="srcchgn" src="{$ukS3ProdBucketUrl}" type="audio/mpeg" />
              Your browser does not support the audio element.
              </audio>
            </div>
            <div>
              <h4 class="media-capture-controls">Teacher comments:</h4>

            <xsl:element name="textArea">
              <xsl:attribute name="style">border: solid 1px #000000; width: 99%;min-height:300px; margin-bottom: 30px; </xsl:attribute>
              <xsl:attribute name="readonly" >true</xsl:attribute>
              <xsl:if test="string-length($comments) > 0">
                <xsl:value-of select="$comments"/>
              </xsl:if>
              <xsl:if test="string-length($comments) = 0">
If you're eligible to have your writing and speaking sections graded, comments on your submission will appear here once graded.  You will receive an email notification informing you when your submissions have been scored – approximately 72 hours after the completion of your exam.

If you would like to subscribe to have your submissions graded, please contact your Kaplan representative.

Otherwise, refer to the self-scoring rubric included in your study plan to help you evaluate your performance.
              </xsl:if>

            </xsl:element>
            </div>

            <script type="text/javascript" src="javascript/common/lib/jquery/min/jquery-1.6.1.min.js"></script>
            <script>
              $(window).load(function() {
              var productID = <xsl:value-of select="$productId"/>;
              var historyDBID = <xsl:value-of select="$historyDbId"/>;
              var sequenceID = window.parent.g_seqMgr.sequenceId;
              var contentItemID = "<xsl:value-of select="$contentItemId"/>";
              var position = g_seqMgr.SequenceSession.position;
              var qaBucket = "<xsl:value-of select="$ukS3QABucketUrl"/>";
              var prodBucket = "<xsl:value-of select="$ukS3ProdBucketUrl"/>";
              var testEnv = window.location.href
              testEnv.includes("qa") || testEnv.includes("395") || testEnv.includes("preview") ? testEnv = 0 : testEnv = 1

              $("#srcchgn").attr("src", function(i, origValue){
              testEnv === 0 ? origValue = qaBucket : origValue = prodBucket;

              <!--New File Format = productID.historyDBID.sequenceID.contentItemID.position.mp3-->
              return origValue + productID + "." + historyDBID + "." + sequenceID + "." + contentItemID + "." + position + ".mp3";
              });

              var audioPlayer = $("#s3audioplayer")
              audioPlayer[0].load();
              });
            </script>
          </xsl:if>

          <xsl:if test="$mode = 'sim'">

            <div class="timer">
              <div class="timer-label">preparation time</div>
              <div class="timer-countdown">00 : 00 : 00</div>
            </div>

            <div class="media-capture-controls" style="display: none;">
              <span class="media-capture-control stop-recording"></span>
              <form method="post" action="{$ukAPIProductionURL}" id="audioForm" enctype="multipart/form-data">
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">email</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$userEmail"/>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">kbsEnrollmentID</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$kbsId"/>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">kaptestProductCode</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$kaptestProductCode"/>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">productID</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$productId"/>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">historyDBID</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$historyDbId"/>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">contentItemID</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$contentItemId"/>
                  </xsl:attribute>
                </xsl:element>
                <input type="hidden" name="sequenceID" value="#"/>
                <input type="hidden" name="position" value="#"/>
                <input type="hidden" name="testTitle" value="#"/>
                <input type="hidden" name="contentItemName" value="#"/>
                <input type="hidden" name="testEnv" value="#"/>
              </form>
            </div>
          </xsl:if>
        </div>

        <xsl:if test="$mode = 'sim'">
          <script>
            var mediaCaptureCountdownTimer = {
              timers: [
                        { 'type': 'prepTime', 'label': 'preparation time', 'value': <xsl:value-of select="@prepTime"/> },
                        { 'type': 'respTime', 'label': 'response time', 'value': <xsl:value-of select="@recordTime"/>, 'displayControls': true }
                      ],
              prepTime: <xsl:value-of select="@prepTime"/>,
              respTime: <xsl:value-of select="@recordTime"/>,
            currentTimerIndex: 0,
            countdownCompleted: null,
            countdownTimerStarted: null,
            _stopTimers: false,

            init: function(options){
            var self = this;

            if (typeof(options) != undefined || options != null){
            self.countdownCompleted = options.countdownCompleted || null;
            self.countdownTimerStarted = options.countdownTimerStarted || null;
            }

            return self;
            },

            startCountdown: function(){
            var self = this;
            var timer = self.timers[self.currentTimerIndex];
            var timerValue = timer.value;
            $('.timer-label').html(timer.label);

            if (self.currentTimerIndex == 1) {
            var sequenceID = window.parent.g_seqMgr.sequenceId;
            var contentItemID = "<xsl:value-of select="$contentItemId"/>";
            var position = g_seqMgr.SequenceSession.position;
            var title = g_seqMgr.SequenceSession.title;
            var contentItemName = g_seqMgr.contentItemName;
            var testEnv = window.location.href
            testEnv.includes("qa") || testEnv.includes("395") || testEnv.includes("preview") ? testEnv = 0 : testEnv = 1
            $("form#audioForm").children()[6].value = sequenceID;
            $("form#audioForm").children()[7].value = position;
            $("form#audioForm").children()[8].value = title;
            $("form#audioForm").children()[9].value = contentItemName;
            $("form#audioForm").children()[10].value = testEnv;
            window.parent.startRecording();
            }

            self.updateTimer(timerValue);
            if (self.countdownTimerStarted != null) {
            self.countdownTimerStarted.apply(self, [timer]);
            }
            },

            updateTimer: function(timerValue){
            var self = this;

            if (self._stopTimers == true) return;

            if (timerValue &gt;= 0){
                  var display = self.getCurrentTime(timerValue);
                  $('.timer-countdown').html(display);
                  setTimeout(function(){ self.updateTimer(timerValue); }, 1000);
                }
                else{
                  if ((self.currentTimerIndex + 1) &lt; self.timers.length){
                    self.currentTimerIndex++;
                    self.startCountdown();
                  }
                  else{
                    if (self.countdownCompleted != null)
                      self.countdownCompleted.apply(self);
                  }
                }

                timerValue--;
              },

              stopTimers: function(){
                var self = this;

                self._stopTimers = true;
              },

              getCurrentTime: function(timerValue){
                var hours = '00';
                var mins = '00';
                var secs = timerValue;

                if (secs &lt; 10) secs = '0' + secs.toString();

            return hours + ' : ' + mins + ' : ' + secs;
            }
            };

            g_seqMgr.navControls = window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document)
            g_seqMgr.nextButton = window.parent.parent.$('.navcontrols-container .navcontrol-next', window.parent.parent.g_frameMgr.testModeFrame.document)
            g_seqMgr.suspendButton = window.parent.parent.$('.navcontrols-container .navcontrol-suspend', window.parent.parent.g_frameMgr.testModeFrame.document)
            g_seqMgr.quitButton = window.parent.parent.$('.navcontrols-container .navcontrol-submit', window.parent.parent.g_frameMgr.testModeFrame.document)
            g_seqMgr.windowObject = window.parent

            window.parent.parent.$('.stop-recording', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).on('click', function(){
            window.parent.stopRecording();
            mediaCaptureCountdownTimer.stopTimers(); window.parent.parent.$('.stop-recording', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).hide();
            if (g_seqMgr.audioProcessing === true) {
            g_seqMgr.navControls.show();
            g_seqMgr.suspendButton.hide()
            g_seqMgr.quitButton.hide()
            }
            else {
            g_seqMgr.navControls.show();
            }
            });

            //Hide answer choices if the question stem has audio/video
            var mediaElements = window.parent.parent.$('audio, video', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document);
            if (mediaElements != null &amp;&amp; mediaElements.length > 0)
              window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).hide();

            window.parent.onMediaPlayerErrorCallback = function(errMsg){
              window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).show();
            };

            window.parent.onMediaPlaybackEndedCallback = function(player){
              var mediaCaptureElem = window.parent.parent.$('.media-capture', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document);
              if (mediaCaptureElem.length > 0 &amp;&amp; mediaCaptureElem.css('display') == 'none'){
            var dataHide = mediaCaptureElem.attr('data-hide');
            if (typeof(dataHide) == 'undefined' || dataHide == null || dataHide != 'yes'){
            mediaCaptureElem.show();

            mediaCaptureCountdownTimer.init({
            countdownTimerStarted: function(timer){
            if (timer.displayControls)
            window.parent.parent.$('.media-capture-controls', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).show();
            },
            countdownCompleted: function(){
            if(mediaCaptureCountdownTimer.currentTimerIndex == 1){
            window.parent.parent.$('.stop-recording', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).hide();
            window.parent.stopRecording();
            }
            if (g_seqMgr.audioProcessing === true) {
            g_seqMgr.navControls.show();
            g_seqMgr.suspendButton.hide()
            g_seqMgr.quitButton.hide()
            }
            else {
            g_seqMgr.navControls.show();
            }
            }
            }).startCountdown();
            }
            else{
            if (player.tagName != 'VIDEO'){
            window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).show();
            return;
            }

            //navigate to next item
            var nextButton = window.parent.parent.$('.navControl-nextPosition', window.parent.parent.g_frameMgr.testModeFrame.document);
            if (typeof(nextButton) != 'undefined' &amp;&amp; nextButton.length > 0){
                    var hasNextButton = false;
                    nextButton.each(function(index, element){
                      if (window.parent.parent.$(element).css('display') == 'block'){
                        window.parent.parent.$(element).trigger('click');
                        hasNextButton = true;
                      }
                    });

                    if (!hasNextButton)
                      window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).show();
                  }
                  else
                    window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).show();
                }
              }
            };
          </script>
        </xsl:if>
      </div>
  </xsl:template>
