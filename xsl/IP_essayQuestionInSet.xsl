<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="../shared/gmatGLEssayQuestion.xsl" />
  <xsl:import href="IP_interactionControls.xsl" />
  <xsl:import href="mediaElements.xsl"/>

  <xsl:output method="html" version="4.0" encoding="UTF-8" indent="no"/>

  <xsl:param name="highlightSelection"/>
  <xsl:param name="mediaPrefix"/>
  <xsl:variable name="choiceHighlightColor">B3B3EF</xsl:variable>
  <xsl:param name="choiceIdStyle"/>
  <xsl:param name="choiceDisplayStyle"/>

  <xsl:template match="essayQuestion">
    <xsl:variable name="subitem" select="count(../preceding-sibling::question-set-member)+1"/>
    <xsl:call-template name="gen-head-scripts" />
    <style type="text/css">
      html,body,div,span,p,ul,textarea{font-family: Verdana; font-size: 11pt;}
      .box { border: 1px solid #000; padding: 10px 15px; }
      div.subitem { padding: 0; }
      span.word-count { float: right; font-size: 7pt; font-weight: bold; vertical-align: middle; margin-right: 10px; margin-top: 4px; }
    </style>
    <div class="subitem" style="overflow: auto; height: 100%; width: 100%; vertical-align: middle; text-align: center;">
      <xsl:attribute name="name"><xsl:value-of select="$subitem"/></xsl:attribute>
      <xsl:attribute name="id">subitem<xsl:value-of select="@subitem"/></xsl:attribute>
      <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;">
        <tr>
          <td valign="top" align="center" height="30%">
            <table border="0"  cellpadding="0" cellspacing="0" style="background-color: #ffffff; width: 100%;">
              <xsl:choose>
                <xsl:when test="count(essayTopic) &gt; 1">
                  <xsl:call-template name="outputEssayTopicDecisionControl">
                    <xsl:with-param name="subitem" select="$subitem" />
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="essayTopic">
                    <xsl:with-param name="subitem" select="$subitem"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </table>
          </td>
        </tr>
        <xsl:if test="$mode = 'sim'">
          <tr>
            <td height="3%" style="background-color: #ffffff;">
              <img src="media/spacer.gif" height="100%" width="5px"></img></td>
          </tr>
        </xsl:if>
        <tr>
          <td height="60%" valign="top" class="interaction" name="essayQuestion" align="center">
            <div class="essayQuestion-container">
            <table border="0"  cellpadding="0" cellspacing="0" style="background-color: #ffffff; width: 100%; height:100%">
              <xsl:if test="$mode = 'sim'">
                <xsl:call-template name="clipboardBar">
                  <xsl:with-param name="subitem" select="$subitem" />
                  <xsl:with-param name="interactionType">essayQuestion</xsl:with-param>
                </xsl:call-template>
              </xsl:if>
              <xsl:call-template name="outputEssayControl">
                <xsl:with-param name="show">
                  <xsl:if test="count(essayTopic) &gt; 1 and $mode='review'">no</xsl:if>
                </xsl:with-param>
                <xsl:with-param name="subitem" select="$subitem" />
                <xsl:with-param name="hide" select="@hide" />
              </xsl:call-template>
              <xsl:element name="input">
                <xsl:attribute name="type">hidden</xsl:attribute>
                <xsl:attribute name="id">eqx<xsl:value-of select="$subitem"/>.essayQuestion</xsl:attribute>
                <xsl:attribute name="name">eqx<xsl:value-of select="$subitem"/>.essayQuestion</xsl:attribute>
              </xsl:element>
              <tr>
                <td align="left" nowrap="true">
                  <table cellspacing="0" cellpadding="0" border="0" style="width: 100%;">
                    <tr>
                      <td align="left">
                        <xsl:call-template name="outputMarkControl"/>
                      </td>
                      <td align="right">
                        <xsl:element name="span">
                          <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.essayQuestion.em</xsl:attribute>
                          <xsl:attribute name="style">font-size: 11pt; color: red;</xsl:attribute>
                        </xsl:element>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
                          <tr>
                <td style="text-align: center; vertical-align: center;">
                  <xsl:apply-templates select="explanation">
                    <xsl:with-param name="subitem" select="$subitem"/>
                  </xsl:apply-templates>
                </td>
              </tr>
            </table>
            </div>
          </td>
        </tr>
      </table>

      <script>
        var stimulus = window.parent.parent.$('#divQuestions .stimulus', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document);
        if (stimulus.length > 0 &amp;&amp; stimulus.html() != ''){
          window.parent.parent.$('.splitRightLeft-top-row', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).show();
          var topPane =  window.parent.parent.$('.splitRightLeft-top-pane', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document)
          topPane.html("");
          stimulus.appendTo(topPane);
        }
      </script>

      <xsl:if test="descendant::mediaExhibit">
        <xsl:call-template name="gen-body-scripts" />
        <xsl:call-template name="gen-styles" />
      </xsl:if>

      <script>
        <xsl:if test="$mode = 'sim'">


          //Hide the essay control if the question stem has an audio/video

          var mediaElements = window.parent.parent.$('audio, video', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document);

          if (mediaElements != null &amp;&amp; mediaElements.length > 0){
            window.parent.parent.$('.essayQuestion-container', document).hide();
            window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).hide();
          }

          window.parent.onMediaPlayerErrorCallback = function(errMsg){
              window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).show();
          };

          window.parent.onMediaPlaybackEndedCallback = function(){
            window.parent.parent.$('.essayQuestion-container', document).show();
            window.parent.parent.$('.navcontrols-container', window.parent.parent.g_frameMgr.testModeFrame.document).show();
          };

          var textAreaElem = window.parent.parent.$('textarea', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document);

          if (textAreaElem.length > 0){
            var getWordCount = function(target){
              var count = 0;
              try{
                var matches = window.parent.parent.$(target).val().match(/\b/g);
                if (matches)
                  count = matches.length / 2;
              }
              catch(e){
                count = 0;
              }

              return count;
            };

            if (textAreaElem.parent().css('display') != 'none'){

            window.parent.parent.$('.control-set', document).prepend('<span class="word-count">Word Count: 0</span>');

          window.parent.essayTextBoxValueSetCallback = function(){
          window.parent.parent.$('span.word-count', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).text('Word Count: ' + getWordCount(textAreaElem));
          };

          textAreaElem.on('keyup', function(e){
          var wordCount = getWordCount(e.currentTarget);

          window.parent.parent.$('span.word-count', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).text('Word Count: ' + wordCount);
          }).on('change', function(e){
          var wordCount = getWordCount(e.currentTarget);

          window.parent.parent.$('span.word-count', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).text('Word Count: ' + wordCount);
          });

          window.parent.parent.$('div.control-set span',  window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).on('click', function(e){
          var wordCount = getWordCount(window.parent.parent.$('textarea', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document));

          window.parent.parent.$('span.word-count', window.parent.parent.g_frameMgr.testModeFrame.frames[0].document).text('Word Count: ' + wordCount);
          });

          }

          }
        </xsl:if>
      </script>
    </div>
  </xsl:template>

  <xsl:template name="clipboardBar">
    <xsl:param name="subitem" />
    <xsl:param name="interactionType"/>
    <tr>
      <td style="background-color: #ffffff; padding: 5px 0 0;">
        <div class="control-set">
          <xsl:apply-templates select="controlSets">
            <xsl:with-param name="subitem" select="$subitem" />
            <xsl:with-param name="interactionType" select="$interactionType"/>
          </xsl:apply-templates>
        </div>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="essayTopic">
    <xsl:param name="subitem"/>
    <tr>
      <xsl:element name="td">
        <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.essayQuestion.et</xsl:attribute>
        <xsl:attribute name="style">font-size: 11pt; text-align: left;</xsl:attribute>
        <xsl:attribute name="onfocus">g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'essayQuestion').appClipboard.SelectText(this);</xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </tr>
  </xsl:template>

  <xsl:template name="outputEssayTopicDecisionControl">
    <tr>
      <td id="essayQuestion"  style="text-align: center; vertical-align: center;">
        This essay contains more than 2 topics.
      </td>
    </tr>

  </xsl:template>

  <xsl:template name="outputEssayControl">
  <xsl:param name="subitem"/>
  <xsl:param name="show"/>
    <xsl:param name="hide" select="'no'"/>

    <tr style ="height:100%">
     <td style="text-align: center; vertical-align: top;">
      <div id="essayControlDiv">
        <xsl:attribute name="style">
                <xsl:choose>
                  <xsl:when test="$hide='yes'">display: none;</xsl:when>
                  <xsl:otherwise>height:100%;text-align:center;overflow:visible;</xsl:otherwise>
               </xsl:choose>
              </xsl:attribute>
        <div style="height:300px;width:0px;float:right;padding:0px;margin:0px;border:0px;"></div>
        <!--<xsl:element name="textArea">
          <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.essayQuestion.input</xsl:attribute>
          <xsl:attribute name="onfocus">g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'essayQuestion').appClipboard.SelectText(this);</xsl:attribute>
                  <xsl:attribute name="style">border: solid 1px #000000; width: 99%;min-height:300px; height: 99%;</xsl:attribute>
                  <xsl:attribute name="wrap">virtual</xsl:attribute>
          <xsl:attribute name="PRINTMGRPOSTFORMID">xmlPost</xsl:attribute>
          <xsl:attribute name="PRINTMGRSTYLE">Essay</xsl:attribute>
          <xsl:attribute name="PRINTMGRHIDDENTAGID">eqx<xsl:value-of select="$subitem"/>.essayQuestion</xsl:attribute>
          <xsl:attribute name="PRINTMGRPOSTVARIABLENAME">essayQuestionXml</xsl:attribute>
          <xsl:if test="@responseRequired">
            <xsl:attribute name="RESPONSEREQUIRED"><xsl:value-of select="@responseRequired"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$mode='review'">
            <xsl:attribute name="readonly" >true</xsl:attribute>
          </xsl:if>
        </xsl:element>-->

          <xsl:element name="textArea">

            <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.essayQuestion.input</xsl:attribute>
            <xsl:attribute name="onfocus">g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'essayQuestion').appClipboard.SelectText(this);</xsl:attribute>

            <xsl:if test="$mode='review'">
              <xsl:attribute name="style">border: solid 1px #000000; width: 99%;min-height:300px;max-height:300px;</xsl:attribute>
            </xsl:if>

            <xsl:if test="$mode='sim'">
              <xsl:attribute name="style">border: solid 1px #000000; width: 99%;min-height:300px; height: 99%;</xsl:attribute>
            </xsl:if>

            <xsl:attribute name="wrap">virtual</xsl:attribute>
            <xsl:attribute name="PRINTMGRPOSTFORMID">xmlPost</xsl:attribute>
            <xsl:attribute name="PRINTMGRSTYLE">Essay</xsl:attribute>
            <xsl:attribute name="PRINTMGRHIDDENTAGID">
              eqx<xsl:value-of select="$subitem"/>.essayQuestion
            </xsl:attribute>
            <xsl:attribute name="PRINTMGRPOSTVARIABLENAME">essayQuestionXml</xsl:attribute>

            <xsl:if test="@responseRequired">
              <xsl:attribute name="RESPONSEREQUIRED">
                <xsl:value-of select="@responseRequired"/>
              </xsl:attribute>
            </xsl:if>

            <xsl:if test="$mode='review'">
              <xsl:attribute name="readonly" >true</xsl:attribute>
            </xsl:if>

          </xsl:element>

          <xsl:if test="$mode='review'">
            <div>
              <h4>Teacher comments:</h4>
            </div>
            <xsl:element name="textArea">
              <xsl:attribute name="style">border: solid 1px #000000; width: 99%;min-height:300px; </xsl:attribute>
              <xsl:if test="$mode='review'">
                <xsl:attribute name="readonly" >true</xsl:attribute>
                <xsl:if test="string-length($comments) > 0">
                  <xsl:value-of select="$comments"/>
                </xsl:if>
                <xsl:if test="string-length($comments) = 0">
If you're eligible to have your writing and speaking sections graded, comments on your submission will appear here once graded.  You will receive an email notification informing you when your submissions have been scored – approximately 72 hours after the completion of your exam.

If you would like to subscribe to have your submissions graded, please contact your Kaplan representative.

Otherwise, refer to the self-scoring rubric included in your study plan to help you evaluate your performance.
                </xsl:if>
              </xsl:if>
            </xsl:element>
          </xsl:if>

          <form method="post" action="{$ukAPIProductionURL}" id="essayForm" enctype="multipart/form-data">
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
            <input type="hidden" name="essayText" value="#"/>
          </form>
        <div style="position:relative;clear:both;"></div>
      </div>
    </td>
  </tr>
  </xsl:template>

  <xsl:template name="controlSpanAttributes">
    <xsl:param name="subitem"/>
    <xsl:param name="interactionType" />
    <xsl:param name="controlType" />
    <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.<xsl:value-of select="$interactionType"/>.<xsl:value-of select="$controlType"/></xsl:attribute>
    <xsl:attribute name="style">padding: 2px;</xsl:attribute>
    <xsl:attribute name="AK"><xsl:value-of select="@accessKey" /></xsl:attribute>
    <xsl:call-template name="controlImage" />
  </xsl:template>

  <xsl:template match="control-autoSave">
    <xsl:param name="subitem"/>
    <xsl:param name="interactionType"/>
    <xsl:if test="$mode != 'review'">
      <span>
        <xsl:attribute name="AUTOSAVE">True</xsl:attribute>
        <xsl:attribute name="AUTOSAVETIMERID">-1</xsl:attribute>
        <xsl:attribute name="AUTOSAVEINTERVAL"><xsl:value-of select="@timeInterval"/></xsl:attribute>
        <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.<xsl:value-of select="$interactionType"/>.autoSave</xsl:attribute>
        <xsl:attribute name="style">display: block; padding: 2px; font-size: 7pt; color: #666666;</xsl:attribute>
      </span>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
