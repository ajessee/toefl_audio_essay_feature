<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="mediaElements.xsl"/>

  <xsl:param name="explanations"/>
  <xsl:param name="enrollmentEmail"/>
  <xsl:param name="ukAPIProductionURL"/>
  <xsl:param name="ukAPIqaURL"/>
  <xsl:param name="ukS3ProdBucketUrl"/>
  <xsl:param name="ukS3QABucketUrl"/>
  <xsl:param name="userEmail"/>
  <xsl:param name="productId" />
  <xsl:param name="historyDbId" />
  <xsl:param name="kbsId"/>
  <xsl:param name="enrollmentId" />
  <xsl:param name="contentItemId" />
  <xsl:param name="kaptestProductCode" />
  <xsl:param name="comments" />
  <xsl:param name="mode" />
  <xsl:param name="explanationState.revMode" />
  <xsl:variable name="fontFamily" select="serif"/>
  <xsl:variable name="fontSize" select="'12pt'"/>

  <xsl:template name="para">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="explanation">
    <style>
      .correct-answer-indicator{
        width: 25px;
        height: 24px;
      }

      .singleAnswerMultipleChoice-correct-answer{
        background: url('/apps/delivery/UI/AthenaFull/images/toefl-singleAnswerChoice-correct-answer.png') no-repeat;
      }

      .explanation-container{
        margin: 15px 0;
      }

      .explanationView{
        border: 0 none;
        padding: 0 15px;
      }

      .highlighted {
        border: 1px solid #ffffff !important;
      }

      .notHighlighted {
        border: 2px solid #fbc463 !important;
      }
    </style>
    <xsl:if test="$mode='review' or $explanations='True'">
      <xsl:variable name="exp-id" select="generate-id()"></xsl:variable>

      <div class="explanation-container">
        <xsl:if test="@hide = 'yes'">
          <xsl:attribute name="style">
            <xsl:value-of select="'display: none;'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:element name="span">
          <xsl:attribute name="id">span-<xsl:value-of select="$exp-id"/></xsl:attribute>
          <xsl:attribute name="style">text-decoration: none; color: purple; font-family: arial; cursor: pointer; cursor: hand;</xsl:attribute>
          <xsl:attribute name="onClick">
            //window.parent.g_seqUtil.ToggleCorrectAns(<xsl:value-of select="count(preceding-sibling::node()[name()='explanation'])+1"/>);
            window.parent.parent.g_seqUtil.ToggleExplainDivVisibilityWithImage(this,'<xsl:value-of select="$exp-id"/>')
          </xsl:attribute>
          <img name="btnExplanation" src="media/hide-explanationsbutton.png" title="Show/hide explanation" style="border-style: none;" />
        </xsl:element>
        <div>
          <xsl:choose>
            <xsl:when test="$mode='review' and $explanationState.revMode='collapsed'">
              <xsl:attribute name="style">display: none;</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="style">display: block;</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:attribute name="id">
            <xsl:value-of select="$exp-id"/>
          </xsl:attribute>
          <div id="container2">
            <xsl:attribute name="class">explanationView</xsl:attribute>
            <div id="container1">
              <div id="container-left">
                <xsl:choose>
                  <xsl:when test="count(preceding-sibling::answer-choice-set[@studentResponses]) != '1'">
                    <xsl:attribute name="style">width: 99%;margin:5px</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="style">width: 57.5%;margin:5px;</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
              </div>
              <xsl:choose>
                <xsl:when test="count(preceding-sibling::answer-choice-set[@studentResponses]) = '1'">
                  <div id="container-right">
                    <div style="border-left: solid gray 1px;height: 100%;border-bottom: solid gray 1px;">
                      <div style="text-align:left">
                        <br>
                          <img name="statHelp" id="statHelp" src="media/info_icon.png"  style="border-style: none;" onClick="javascript:modalWin();" />
                        </br>
                        <b style="vertical-align: top;padding: 5px;color: slateblue">Question Statistics:</b>
                      </div>
                      <div>
                        <table style="width:100%">
                          <xsl:for-each select="preceding-sibling::answer-choice-set/answer-choice">
                            <xsl:if test="@percentResponse != ''">
                              <tr style="font-size: 11pt;color: slategrey;">
                                <td width="125px" align="left" valign="top">
                                  <b>
                                    <xsl:value-of select="@percentResponse"/>
                                  </b>% Choose (<xsl:number value="position()" format="A" />)
                                </td>
                              </tr>
                            </xsl:if>
                          </xsl:for-each>
                          <tr style="color: slategrey">
                            <td valign="top" colspan="1" align="left">
                              <br></br>
                              <xsl:value-of select="preceding-sibling::answer-choice-set[@studentResponses]/@percentCorrect"/> % of test takers answer correctly
                            </td>
                          </tr>
                          <tr style="font-size: 10pt;color: slategrey">
                            <td valign="top" colspan="1" align="left">
                              <br></br>
                              Sample size = <xsl:value-of select="preceding-sibling::answer-choice-set[@studentResponses]/@studentResponses"/>
                            </td>
                          </tr>
                        </table>
                      </div>
                    </div>
                  </div>
                </xsl:when>
              </xsl:choose>

            </div>
          </div>
        </div>
        <script language="javascript">
          function modalWin() {
            window.showModalDialog("contentItem.aspx?page=statHelp","statHelp","dialogWidth:555px;dialogHeight:550px");
          }
          <xsl:if test="$mode='review' and $explanationState.revMode='collapsed'">

            if(typeof(g_seqMgr.frameWin.$)!='undefined'){g_seqMgr.frameWin.$(window.document).ready(function(){
               window.parent.g_seqUtil.ToggleCorrectAns(<xsl:value-of select="count(preceding-sibling::node()[name()='explanation'])+1"/>);
               window.parent.g_seqUtil.ToggleExplainDivVisibilityWithImage(g_seqMgr.frameWin.$("#span-" + '<xsl:value-of select="$exp-id"/>',window.document) ,'<xsl:value-of select="$exp-id"/>');
            });}
          </xsl:if>
        </script>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mediaExhibit">
    <xsl:choose>
      <xsl:when test="$mode='review'">
        <xsl:call-template name="gen-media-element">
          <xsl:with-param name="frameType" select="@frameType" />
          <xsl:with-param name="mediaRef" select="@mediaRef" />
          <xsl:with-param name="hideProgressBar" select="@hideProgressBar" />
          <xsl:with-param name="height">
            <xsl:choose>
              <xsl:when test="@height">
                <xsl:value-of select="@height"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="446"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="width">
            <xsl:choose>
              <xsl:when test="@width">
                <xsl:value-of select="@width"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="594"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gen-media-element">
          <xsl:with-param name="frameType" select="@frameType" />
          <xsl:with-param name="mediaRef" select="@mediaRef" />
          <xsl:with-param name="hideProgressBar" select="@hideProgressBar" />
          <xsl:with-param name="height">
            <xsl:choose>
              <xsl:when test="@height">
                <xsl:value-of select="@height"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="446"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="width">
            <xsl:choose>
              <xsl:when test="@width">
                <xsl:value-of select="@width"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="594"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="categoryRefs">
    <xsl:param name="categoryName"/>
    <xsl:call-template name="question-direction"/>
  </xsl:template>

  <xsl:template name="question-direction">
    <xsl:choose>
      <xsl:when test="catRef-GRAD-UQType/@categoryName ='set.rc.allthatapply'">
        <div style="border:solid 1px;width: 98%;height: 40px;margin-top: 7px;text-align:center;overflow:auto;">
          <div style="margin-top:10px;">Consider each of the choices separately and select all that apply.</div>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
  INTERACTION: Single/Multi-Answer Multiple Choice
  -->
  <xsl:template match="answer-choice-set">
    <xsl:variable name="typeName">
      <xsl:choose>
        <xsl:when test="@multipleAnswer='yes'">multipleAnswerMultipleChoice</xsl:when>
        <xsl:otherwise>singleAnswerMultipleChoice</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="categoryName">
      <xsl:choose>
        <xsl:when test="count(//question-set-member) &gt; 0">
          <xsl:value-of select="//question-set-member/categoryRefs/catRef-GRAD-UQType/@categoryName"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="//question/categoryRefs/catRef-GRAD-UQType/@categoryName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <style type="text/css">
      .choiceContent
      {
        padding-top:5px;
        padding-bottom:5px;
      }
      .choiceContentReview
      {
        padding-top:0px;
        padding-bottom:0px;
      }

      .selectedansstyle.incorrectansstyle{
        background-image:url('/apps/delivery/media/responseInCorrect.gif');
        background-repeat: no-repeat;
        background-position: left center;
        vertical-align: bottom;
      }
      .selectedansstyle.correctansstyle{
        background-image:url('/apps/delivery/media/responseCorrect.gif');
        background-repeat: no-repeat;
        background-position: left center;
        vertical-align: bottom;
      }
    </style>

    <!--
    <xsl:if test="/question/categoryRefs/catRef-GRAD-UQType/@categoryName='discfixed.qc'">
      <style type="text/css">
        .normal td{
           width:50%
        }
      </style>
    </xsl:if>
    -->

    <div class="answer-choice-set" style="width:100%;display:table;">
      <xsl:if test="@hide = 'yes'">
        <xsl:attribute name="style">
          <xsl:value-of select="'width:100%;display:none;'"/>
        </xsl:attribute>
        <xsl:attribute name="data-hidden">
          <xsl:value-of select="'yes'"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@multipleAnswer = 'yes' and (@draggable = 'no' or not(@draggable))">
        <xsl:if test="@correctAnswerChoiceCount">
          <div align="center">
            <p>
              <span style="padding: 6px; background-color: #dbdde8; min-width: 235px; display: inline-block;">
                <xsl:value-of select="concat('Click on ', @correctAnswerChoiceCount, ' answers.')"/>
              </span>
            </p>
          </div>
        </xsl:if>
      </xsl:if>

      <!--
      <xsl:if test="/question/categoryRefs/catRef-GRAD-UQType/@categoryName='discfixed.qc'">
        <xsl:attribute name="style">width:100%;display:table;</xsl:attribute>
      </xsl:if>
      -->
      <div>
        <xsl:if test="$categoryName='set.rc.multiplechoice' or $categoryName='set.di.multiplechoice'">
          <!--<xsl:attribute name="style">float:left;</xsl:attribute>-->
        </xsl:if>
        <!--
        <xsl:if test="/question/categoryRefs/catRef-GRAD-UQType/@categoryName='discfixed.qc'">
          <xsl:attribute name="style">width:65%;float:right;display:table;</xsl:attribute>
        </xsl:if>
        -->
        <div style="width:100%">
          <!--
          <xsl:if test="/question/categoryRefs/catRef-GRAD-UQType/@categoryName='discfixed.qc'">
            <xsl:attribute name="style">float:left;</xsl:attribute>
          </xsl:if>
          -->
          <style type="text/css">
            input[type=checkbox].css-checkbox {
              display:none;
            }
            input[type=checkbox].css-checkbox + label.css-label {
              padding-left:20px;
              height:18px;
              display:inline-block;
              line-height:18px;
              background-repeat:no-repeat;
              background-position: 0 0;
              font-size:18px;
              vertical-align:middle;
              cursor:pointer;
            }
            input[type=checkbox].css-checkbox:checked + label.css-label {
              background-position: 0 -18px;
            }
            .css-label{ background-image:url('media/checkbox_sprites.png');
          </style>

          <xsl:choose>
            <xsl:when test="$typeName='multipleAnswerMultipleChoice' and @draggable and @draggable = 'yes'">
              <xsl:variable name="draggableHeight">
                <xsl:choose>
                  <xsl:when test="@draggableHeight">
                    <xsl:value-of select="@draggableHeight"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="50"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <xsl:variable name="draggableWidth">
                <xsl:choose>
                  <xsl:when test="@draggableWidth">
                    <xsl:value-of select="@draggableWidth"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="475"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <style>
                .draggable.correct-answer{
                  background-color: #fec15d;
                  padding: 0 8px;
                }

                .mamc-dragdrop {

                }

                .mamc-dragdrop .droptarget-container {
                  width: <xsl:value-of select="$draggableWidth + 100" />px;
                  border: 1px solid #000;
                  margin: 20px auto;
                  -ms-user-select: none;
                  -moz-user-select: none;
                  -webkit-user-select: none;
                }

                .mamc-dragdrop ul {
                  padding: 0;
                  margin: 0;
                }

                .mamc-dragdrop li {
                  list-style: none outside;
                }

                .mamc-dragdrop .list-item-bullet {
                  float: left;
                  display: block;
                  height: 50px;
                  width: 8px;
                  margin-left: 12px;
                  margin-right: 30px;
                  background: url('/apps/delivery/media/list-bullet.png') no-repeat 50%;
                }

                .mamc-dragdrop .list-item-container {
                  margin: 10px 0;
                  width: <xsl:value-of select="$draggableWidth"/>;
                }

                .mamc-dragdrop .list-item-wrap {
                  height: <xsl:value-of select="$draggableHeight"/>px;
                  width: <xsl:value-of select="$draggableWidth"/>px;
                  padding-left: 50px;
                }

                .mamc-dragdrop .item-container {
                  display: table;
                }

                .mamc-dragdrop .item {
                  display: table-cell;
                  vertical-align: middle;
                  height: <xsl:value-of select="$draggableHeight"/>px;
                }

                .mamc-dragdrop .draggables-container {
                  margin: 20px auto;
                  width: 80%;
                }

                .mamc-dragdrop .draggable-home {
                  height: <xsl:value-of select="$draggableHeight" />px;
                  width: <xsl:value-of select="$draggableWidth" />px;
                  float: left;
                  padding-left: 20px;
                }

                .mamc-dragdrop .draggable, .mamc-dragdrop .draggables-container, .mamc-dragdrop .draggable-home {
                  cursor: default;
                  -ms-user-select: none;
                  -moz-user-select: none;
                  -webkit-user-select: none;
                }
              </style>

              <div class="mamc-dragdrop interaction">
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('subitem', ancestor::*[@subitem][1]/@subitem, '.', $typeName)"/>
                </xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:value-of select="$typeName"/>
                </xsl:attribute>
                <xsl:attribute name="answerChoiceCount">
                  <xsl:value-of select="count(answer-choice)" />
                </xsl:attribute>

                <div class="droptarget-container">
                  <ul>
                    <!--<xsl:choose>
                      <xsl:when test="$mode = 'review' or $explanations = 'True'">

                        <xsl:for-each select="answer-choice">
                          <xsl:if test="@correct = 'yes'">
                            <li>
                              <div class="list-item-container">
                                <span class="list-item-bullet"></span>
                                <div class="list-item-wrap draggable-target">
                                  <div class="draggable">
                                    <xsl:attribute name="id">
                                      <xsl:value-of select="concat('draggable-', position())"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="data-index">
                                      <xsl:value-of select="position()"/>
                                    </xsl:attribute>

                                    <div class="item-container">
                                      <div class="item">
                                        <xsl:apply-templates>
                                          <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                                          <xsl:with-param name="elementName" select="'div'" />
                                        </xsl:apply-templates>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </li>
                          </xsl:if>
                        </xsl:for-each>

                      </xsl:when>
                      <xsl:otherwise>-->
                        <xsl:call-template name="gen-draggable-target">
                          <xsl:with-param name="counter" select="1" />
                          <xsl:with-param name="targetCount" select="@correctAnswerChoiceCount" />
                        </xsl:call-template>
                      <!--</xsl:otherwise>
                    </xsl:choose>-->
                  </ul>
                </div>

                <div class="draggables-container">
                  <xsl:apply-templates>
                    <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                    <xsl:with-param name="elementName" select="'div'" />
                  </xsl:apply-templates>
                </div>
                <script type="text/javascript" src="/apps/delivery/javascript/common/lib/jquery/min/jquery-1.7.2.min.js"/>
                <script type="text/javascript" src="/apps/delivery/javascript/common/lib/jquery.ui/jquery-ui-1.8.17.custom.min.js"/>
                <script type="text/javascript" src="/apps/delivery/javascript/common/lib/jquery.ui/plugin/jquery.ui.touch-punch-0.2.2.min.js"/>
                <script type="text/javascript" src="/apps/delivery/javascript/toeflDragDropMgr.js"/>
                <xsl:if test="$mode = 'sim'">
                  <script>
                    $(document).ready(function(){
                      toeflDragDropMgr.init();
                    });
                  </script>
                </xsl:if>
              </div>
            </xsl:when>

            <xsl:otherwise>
              <table cellpadding="0" cellspacing="0" border="0" class="interaction">
                <xsl:attribute name="id">subitem<xsl:value-of select="ancestor::*[@subitem][1]/@subitem"/>.<xsl:value-of select="$typeName"/></xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:value-of select="$typeName"/>
                </xsl:attribute>
                <xsl:attribute name="answerChoiceCount">
                  <xsl:value-of select="count(answer-choice)" />
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="@itemLayout = 'vertical' and $typeName='multipleAnswerMultipleChoice' and $categoryName=''">
                    <xsl:attribute name="style">margin:auto;float:left;</xsl:attribute>
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$categoryName='discmc.ps.multiplechoice' and @itemLayout='horizontal' ">
                    <xsl:attribute name="style">margin:auto;</xsl:attribute>
                    <tr>
                      <xsl:apply-templates>
                        <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                        <xsl:with-param name="elementName" select="'td'"></xsl:with-param>
                      </xsl:apply-templates>
                    </tr>
                  </xsl:when>
                  <xsl:when test="$categoryName='discmc.ps.multiplechoice' and @itemLayout='vertical'">
                    <xsl:attribute name="style">margin: auto;</xsl:attribute>
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$categoryName='set.di.multiplechoice' and @itemLayout='vertical'">
                    <xsl:attribute name="style">margin:auto;float:left;</xsl:attribute>

                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$categoryName='set.di.multiplechoice' and @itemLayout='horizontal'">
                    <xsl:attribute name="style">margin:auto;</xsl:attribute>
                    <tr>
                      <xsl:apply-templates>
                        <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                        <xsl:with-param name="elementName" select="'td'"></xsl:with-param>
                      </xsl:apply-templates>
                    </tr>
                  </xsl:when>
                  <xsl:when test="$categoryName='discfixed.qc' and @itemLayout='horizontal'">
                    <xsl:attribute name="style">margin: auto;float:left;</xsl:attribute>
                    <tr>
                      <xsl:apply-templates>
                        <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                        <xsl:with-param name="elementName" select="'td'"></xsl:with-param>
                      </xsl:apply-templates>
                    </tr>
                  </xsl:when>
                  <xsl:when test="$categoryName='discfixed.qc' and  @itemLayout='vertical' ">
                    <xsl:attribute name="style">float:right;width:65%;display:table;</xsl:attribute>
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$categoryName='discfixed.qc' and string-length(@itemLayout)=0">
                    <xsl:attribute name="style">float:right;width:65%;display:table;</xsl:attribute>
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$categoryName='set.rc.multiplechoice' and @itemLayout='vertical'">
                    <xsl:attribute name="style">margin:auto;float:left;</xsl:attribute>
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:when test="$categoryName='set.rc.multiplechoice' and string-length(@itemLayout)=0">
                    <xsl:attribute name="style">margin:auto;float:left;</xsl:attribute>
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:when>
                  <xsl:otherwise>
                    <!--<xsl:attribute name="style">margin:auto;</xsl:attribute>-->
                    <xsl:apply-templates>
                      <xsl:with-param name="multiSelect" select="@multipleAnswer"/>
                      <xsl:with-param name="elementName" select="'tr'"></xsl:with-param>
                    </xsl:apply-templates>
                  </xsl:otherwise>
                </xsl:choose>
              </table>

              <xsl:if test="$mode = 'sim'">
                <script>
                  //Hide answer choices if the question stem has audio/video
                  var mediaElements = window.parent.$('audio, video', window.parent.g_frameMgr.testModeFrame.frames[0].document);
                  if (mediaElements != null &amp;&amp; mediaElements.length > 0){
                    window.parent.$('.answer-choice-set', document).hide();
                    window.parent.$('.navcontrols-container', window.parent.g_frameMgr.testModeFrame.document).hide();
                  }

                  window.parent.onMediaPlayerErrorCallback = function(errMsg){
                     window.parent.$('.navcontrols-container', window.parent.g_frameMgr.testModeFrame.document).show();
                  };

                  window.parent.onMediaPlaybackEndedCallback = function(player){
                    var answerChoiceSet = $('.answer-choice-set');
                    if (answerChoiceSet.length > 0 &amp;&amp; answerChoiceSet.css('display') == 'none'){
                      if (answerChoiceSet.attr('data-hidden') != null &amp;&amp; answerChoiceSet.attr('data-hidden') == 'yes' &amp;&amp; player.tagName == 'VIDEO'){
                        //navigate to next item
                        var nextButton = window.parent.$('.navControl-nextPosition', window.parent.g_frameMgr.testModeFrame.document);
                        if (nextButton.length > 0){
                          var hasNextButton = false;
                          nextButton.each(function(index, element){
                            if (window.parent.$(element).css('display') == 'block'){
                              setTimeout(function(){
                                window.parent.$(element).trigger('click');
                              }, 1000);
                              hasNextButton = true;
                            }
                          });

                          if (!hasNextButton)
                            window.parent.$('.navcontrols-container', window.parent.g_frameMgr.testModeFrame.document).show();
                        }
                        else
                          window.parent.$('.navcontrols-container', window.parent.g_frameMgr.testModeFrame.document).show();
                      }
                      else{
                        answerChoiceSet.show();
                        window.parent.$('.navcontrols-container', window.parent.g_frameMgr.testModeFrame.document).show();
                      }
                    }
                  };
                </script>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="gen-draggable-target">
    <xsl:param name="counter"/>
    <xsl:param name="targetCount"/>

    <xsl:if test="$counter &lt;= $targetCount">
      <li>
        <div class="list-item-container">
          <span class="list-item-bullet"></span>
          <div class="list-item-wrap draggable-target">
          </div>
        </div>
      </li>

      <xsl:call-template name="gen-draggable-target">
        <xsl:with-param name="counter" select="$counter + 1"/>
        <xsl:with-param name="targetCount" select="$targetCount" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

<!-- single/multi answer multiple choice -->
<xsl:template match="answer-choice">
<xsl:param name="multiSelect"/>
<xsl:param name="elementName"/>
<xsl:variable name="typeName"><xsl:choose><xsl:when test="$multiSelect='yes'">multiple</xsl:when><xsl:otherwise>single</xsl:otherwise></xsl:choose>AnswerMultipleChoice</xsl:variable>
<xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
<xsl:variable name="rowId">subitem<xsl:value-of select="$subitem"/>.<xsl:value-of select="$typeName"/>.answerChoiceRow<xsl:value-of select="position()"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$elementName='td'">
      <xsl:element name="td">
        <xsl:attribute name="class">answerChoiceRow</xsl:attribute>
        <xsl:attribute name="style">padding: 2px 0px 2px 0px;text-align:left;</xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="position()"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="$rowId"/></xsl:attribute>
        <xsl:element name="table">
          <tr>
          <!-- output the bubble -->
          <td style="padding-right: 3px;">
          <span class="parentindicator">
            <xsl:if test="$mode='review'">
              <xsl:attribute name="class">parentindicator incorrectansstyle</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='review' and @correct='yes'">
              <xsl:attribute name="class">parentindicator correctansstyle</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="style">padding:0 0px 0 20px;</xsl:attribute>
          <span>
        <xsl:choose>
          <xsl:when test="($multiSelect='no' or not($multiSelect)) and $choiceDisplayStyle='alpha-image'">
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
              <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_lo.gif</xsl:attribute>
            </xsl:element>
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
              <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_hi.gif</xsl:attribute>
              <xsl:attribute name="style">display: none;</xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:when test="($multiSelect='no' or not($multiSelect)) and $choiceDisplayStyle='alternating-alpha-a-f'">
            <xsl:choose>
              <xsl:when test="count(ancestor::*/@displaySeq) = 1">
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="ancestor::*/@displaySeq mod 2 = 1">
                      <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_lo.gif</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="position() &gt; 3">
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 6" format="A" />_lo.gif</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 5" format="A" />_lo.gif</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="ancestor::*/@displaySeq mod 2 = 1">
                      <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_hi.gif</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="position() &gt; 3">
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 6" format="A" />_hi.gif</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 5" format="A" />_hi.gif</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:attribute name="style">display: none;</xsl:attribute>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
                  <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_lo.gif</xsl:attribute>
                </xsl:element>
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
                  <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_hi.gif</xsl:attribute>
                  <xsl:attribute name="style">display: none;</xsl:attribute>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="($multiSelect='no' or not($multiSelect)) and $choiceDisplayStyle='radio-button'">
            <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:when test="$multiSelect='yes'">
            <xsl:attribute name="style">padding:2px</xsl:attribute>
            <xsl:if test="($mode='review' or $explanations='True') and @correct='yes'">
              <xsl:attribute name="class">correctanswerhighlight1 notHighlighted</xsl:attribute>
              <xsl:attribute name="style">border:solid 1px #fff;padding-bottom:4px;padding-top:1px;padding-right:1px;width:23px;float:right;</xsl:attribute>
            </xsl:if>
            <xsl:element name="input">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.input</xsl:attribute>
              <xsl:attribute name="type">checkbox</xsl:attribute>
              <xsl:if test="$mode='review'">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
                <xsl:attribute name="style">border:solid 1px #ffffff;</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="class">css-checkbox</xsl:attribute>
            </xsl:element>

               <xsl:element name="label">
                <xsl:attribute name="name">lbl_chk</xsl:attribute>
                <xsl:attribute name="for"><xsl:value-of select="$rowId"/>.input</xsl:attribute>
                <xsl:attribute name="class">css-label</xsl:attribute>
                <xsl:attribute name="style">vertical-align:top;margin-bottom:1px;margin-right:2px;</xsl:attribute>
                <xsl:attribute name="onclick">AnswerTextClick('<xsl:value-of select="$rowId"/>.input', 'Label');</xsl:attribute>
              </xsl:element>

          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
              <xsl:attribute name="src">media/radio_btn.png</xsl:attribute>
              <xsl:if test="($mode='review' or $explanations='True') and @correct='yes'">
                <xsl:attribute name="class">correctanswerhighlight1 highlighted</xsl:attribute>
                <xsl:attribute name="style">border:solid 1px #fff</xsl:attribute>
              </xsl:if>
            </xsl:element>
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
              <xsl:attribute name="src">media/radio_btn_selected.png</xsl:attribute>
              <xsl:attribute name="style">display: none;</xsl:attribute>
              <xsl:if test="($mode='review' or $explanations='True') and @correct='yes'">
                <xsl:attribute name="class">correctanswerhighlight1 highlighted</xsl:attribute>
                <xsl:attribute name="style">display: none;border:solid 1px #fff</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
          </span>
          </span>
        </td>

          <!-- output the choice content -->
          <xsl:element name="td">
          <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.content</xsl:attribute>
          <xsl:attribute name="class">choiceContent<xsl:if test="$mode='review'">Review</xsl:if></xsl:attribute>
            <xsl:attribute name="onclick">
              <xsl:choose>
                <xsl:when test="$typeName='singleAnswerMultipleChoice'">AnswerTextClick('<xsl:value-of select="$rowId"/>.state0', 'Text');</xsl:when>
                <xsl:otherwise>AnswerTextClick('<xsl:value-of select="$rowId"/>.input', 'Text');</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="style">
            <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>; </xsl:if>
            <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>
            <xsl:if test="$mode!='review'">cursor:hand;cursor:pointer;</xsl:if>
            <xsl:if test="$typeName='singleAnswerMultipleChoice'">padding-left: 5px;</xsl:if>
          </xsl:attribute>
          <xsl:apply-templates />
        </xsl:element>
          </tr>
        </xsl:element>
      </xsl:element>
    </xsl:when>
    <xsl:when test="$elementName='div' and $multiSelect='yes'">
      <div class="draggable-home">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('draggable-home-', position())"/>
        </xsl:attribute>
        <div class="draggable">
          <xsl:attribute name="id">
            <xsl:value-of select="concat('draggable-', position())"/>
          </xsl:attribute>
          <xsl:attribute name="data-index">
            <xsl:value-of select="position()"/>
          </xsl:attribute>
          <xsl:if test="$mode = 'review' or $explanations = 'True'">
            <xsl:if test="@correct = 'yes'">
              <xsl:attribute name="class">
                <xsl:value-of select="'draggable correct-answer'"/>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>

          <div class="item-container">
            <div class="item">
              <!--<xsl:choose>
                <xsl:when test="$mode = 'review' or $explanations = 'True'">
                  <xsl:if test="@correct != 'yes' or not(@correct)">
                    <xsl:apply-templates />
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>-->
                  <xsl:apply-templates />
                <!--</xsl:otherwise>
              </xsl:choose>-->
            </div>
          </div>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="tr">
        <xsl:attribute name="class">answerChoiceRow</xsl:attribute>
        <xsl:attribute name="style">padding: 2px 0px 2px 0px;text-align:left;</xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="position()"/></xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="$rowId"/></xsl:attribute>

        <!-- output the bubble -->
        <xsl:if test="$mode='review' and ($multiSelect='no' or not($multiSelect))">
          <td>
            <xsl:choose>
              <xsl:when test="@correct='yes'">
                <div class="correct-answer-indicator singleAnswerMultipleChoice-correct-answer"></div>
              </xsl:when>
              <xsl:otherwise>
                <div class="correct-answer-indicator"></div>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:if>

        <td style="padding-right: 2px;vertical-align:top;padding-top:2px;text-align:right;*text-align:left">
          <div class="parentindicator">
          <xsl:if test="$mode='review'">
            <xsl:attribute name="class">parentindicator incorrectansstyle</xsl:attribute>
          </xsl:if>
          <xsl:if test="$mode='review' and @correct='yes'">
            <xsl:attribute name="class">parentindicator correctansstyle</xsl:attribute>
          </xsl:if>
          <div>
        <xsl:choose>
          <xsl:when test="($multiSelect='no' or not($multiSelect)) and $choiceDisplayStyle='alpha-image'">
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
              <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_lo.gif</xsl:attribute>
            </xsl:element>
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
              <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_hi.gif</xsl:attribute>
              <xsl:attribute name="style">display: none;</xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:when test="($multiSelect='no' or not($multiSelect)) and $choiceDisplayStyle='alternating-alpha-a-f'">
            <xsl:choose>
              <xsl:when test="count(ancestor::*/@displaySeq) = 1">
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="ancestor::*/@displaySeq mod 2 = 1">
                      <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_lo.gif</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="position() &gt; 3">
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 6" format="A" />_lo.gif</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 5" format="A" />_lo.gif</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="ancestor::*/@displaySeq mod 2 = 1">
                      <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_hi.gif</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="position() &gt; 3">
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 6" format="A" />_hi.gif</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="src">media/imgChoice<xsl:number value="position() + 5" format="A" />_hi.gif</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:attribute name="style">display: none;</xsl:attribute>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
                  <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_lo.gif</xsl:attribute>
                </xsl:element>
                <xsl:element name="img">
                  <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
                  <xsl:attribute name="src">media/imgChoice<xsl:number value="position()" format="A" />_hi.gif</xsl:attribute>
                  <xsl:attribute name="style">display: none;</xsl:attribute>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="($multiSelect='no' or not($multiSelect)) and $choiceDisplayStyle='radio-button'">
            <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:when test="$multiSelect='yes'">
            <xsl:attribute name="style">padding:2px</xsl:attribute>
            <xsl:if test="($mode='review' or $explanations='True') and @correct='yes'">
              <xsl:attribute name="class">correctanswerhighlight1 notHighlighted</xsl:attribute>
              <xsl:attribute name="style">border:solid 1px #fff;padding-bottom:3px;padding-top:1px;padding-right:1px;width:23px;float:right;</xsl:attribute>
            </xsl:if>
            <xsl:element name="input">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.input</xsl:attribute>
              <xsl:attribute name="type">checkbox</xsl:attribute>
                <xsl:if test="$mode='review'">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
                <xsl:attribute name="style">border:solid 1px #ffffff;</xsl:attribute>
                </xsl:if>
              <xsl:attribute name="class">css-checkbox</xsl:attribute>
            </xsl:element>
               <xsl:element name="label">
                <xsl:attribute name="name">lbl_chk</xsl:attribute>
                <xsl:attribute name="for"><xsl:value-of select="$rowId"/>.input</xsl:attribute>
                <xsl:attribute name="class">css-label</xsl:attribute>
                <xsl:attribute name="style">vertical-align:top;margin-bottom:1px;margin-right:2px;</xsl:attribute>
                <xsl:attribute name="onclick">AnswerTextClick('<xsl:value-of select="$rowId"/>.input', 'Label');</xsl:attribute>
              </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state0</xsl:attribute>
              <xsl:attribute name="src">media/radio_btn.png</xsl:attribute>
              <xsl:if test="($mode='review' or $explanations='True') and @correct='yes'">
                <xsl:attribute name="class">correctanswerhighlight1 highlighted</xsl:attribute>
                <xsl:attribute name="style">border:solid 1px #fff</xsl:attribute>
              </xsl:if>
            </xsl:element>
            <xsl:element name="img">
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.state1</xsl:attribute>
              <xsl:attribute name="src">media/radio_btn_selected.png</xsl:attribute>
              <xsl:attribute name="style">display: none;</xsl:attribute>
              <xsl:if test="($mode='review' or $explanations='True') and @correct='yes'">
                <xsl:attribute name="class">correctanswerhighlight1 highlighted</xsl:attribute>
                <xsl:attribute name="style">display: none;border:solid 1px #fff</xsl:attribute>
              </xsl:if>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
          </div>
          </div>
        </td>

        <!-- output the choice content -->
        <xsl:element name="td">
          <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.content</xsl:attribute>
          <xsl:attribute name="class">choiceContent<xsl:if test="$mode='review'">Review</xsl:if></xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:choose>
              <xsl:when test="$typeName='singleAnswerMultipleChoice'">AnswerTextClick('<xsl:value-of select="$rowId"/>.state0', 'Text');</xsl:when>
              <xsl:otherwise>AnswerTextClick('<xsl:value-of select="$rowId"/>.input', 'Text');</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="style">
            <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>; </xsl:if>
            <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>vertical-align:bottom;padding-top:5px;
            <xsl:if test="$mode!='review'">cursor:hand;cursor:pointer;</xsl:if>
            <xsl:if test="$typeName='singleAnswerMultipleChoice'">padding-left: 5px;</xsl:if>
          </xsl:attribute>
          <xsl:apply-templates />
        </xsl:element>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
INTERACTION: Answer Blank
-->
<xsl:template match="answerBlank[@correctValue]">
<xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
<xsl:call-template name="answerBlank" >
<xsl:with-param name="subitem" >subitem<xsl:value-of select="$subitem" /></xsl:with-param>
</xsl:call-template>
</xsl:template>

<xsl:template name="answerBlank">

    <xsl:param name="subitem"/>
  <style type="text/css">

    .choiceContent
    {
    padding-top:5px;
    <!--padding-bottom:5px;-->
    }
    .choiceContentReview
    {
    padding-top:5px;
    padding-bottom:5px;
    }

  </style><xsl:choose>
<xsl:when test="$mode='review'">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
<td>Your Response:</td>
<td style="padding: 0px 3px 0px 3px;">
  <xsl:element name="input">
    <xsl:attribute name="type">text</xsl:attribute>
    <xsl:attribute name="style">border-style:none;</xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.answerBlank</xsl:attribute>
    <xsl:attribute name="disabled">true</xsl:attribute>
  </xsl:element>
</td>
</tr>
<tr>
<td>Correct Response:</td>
<td><xsl:value-of select="@correctValue"/></td>
</tr>
</table>
</xsl:when>
<xsl:otherwise>
  <xsl:element name="input">
  <xsl:attribute name="type">text</xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.answerBlank</xsl:attribute>
  </xsl:element>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--
INTERACTION: Pick List
-->
  <xsl:template match="pickListInteraction">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
    <xsl:element name="select">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.pickList.input</xsl:attribute>
      <xsl:attribute name="style">margin-left: 8px; border: solid 1px #999999; width: auto; margin-right: 5px;</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@responseRequired = 'yes'">
          <xsl:attribute name="RESPONSEREQUIRED">true</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="RESPONSEREQUIRED">false</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="pickListOptionList/pickListOption"/>
    </xsl:element>
    <xsl:element name="span">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.pickList.em</xsl:attribute>
      <xsl:attribute name="style">font-size: 10pt; color: red;</xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="pickListOption">
    <xsl:element name="option">
      <xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
      <xsl:value-of select="@title"/>
    </xsl:element>
  </xsl:template>


<!--
INTERACTION: Date Time
-->
  <xsl:template match="dateInteraction">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
    <span class="interaction" name="dateTime">
    <xsl:element name="input">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.dateTime.input</xsl:attribute>
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="maxLength">11</xsl:attribute>
      <xsl:attribute name="style">margin-left: 8px; border: solid 1px #999999; width: 80px; margin-right: 5px;</xsl:attribute>
      <xsl:attribute name="value">mm/dd/yyyy</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@responseRequired = 'yes'">
          <xsl:attribute name="RESPONSEREQUIRED">true</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="RESPONSEREQUIRED">false</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:element name="input">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.dateTime.clear</xsl:attribute>
      <xsl:attribute name="type">button</xsl:attribute>
      <xsl:attribute name="value">Clear</xsl:attribute>
      <xsl:attribute name="style">font-size: 9pt; color: #ffffff; background-color: #336699;</xsl:attribute>
      <xsl:attribute name="onclick">document.getElementById('subitem<xsl:value-of select="$subitem"/>.dateTime.input').value = 'mm/dd/yyyy';</xsl:attribute>
    </xsl:element>
    <xsl:element name="span">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.dateTime.em</xsl:attribute>
      <xsl:attribute name="style">font-size: 10pt; color: red;</xsl:attribute>
    </xsl:element>
    <xsl:element name="div">
      <xsl:attribute name="style">display: none; position: absolute; background-color: #ffffff; border: solid 2px #336699;</xsl:attribute>
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.dateTime.div</xsl:attribute>
    </xsl:element>
    </span>
  </xsl:template>

<!--
INTERACTION: Number
-->
  <xsl:template match="numberInteraction">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name="value" select="/*/interactionState/contentItem[@subitem=$subitem]/number/@value" />
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
    <xsl:element name="input">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.number.input</xsl:attribute>
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="maxLength">11</xsl:attribute>
      <xsl:attribute name="style">margin-left: 8px; border: solid 1px #999999; width: 80px; margin-right: 5px;</xsl:attribute>
      <xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
      <xsl:if test="@minimum">
        <xsl:attribute name="minimum"><xsl:value-of select="@minimum" /></xsl:attribute>
      </xsl:if>
      <xsl:if test="@maximum">
        <xsl:attribute name="maximum"><xsl:value-of select="@maximum" /></xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@responseRequired = 'yes'">
          <xsl:attribute name="RESPONSEREQUIRED">true</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="RESPONSEREQUIRED">false</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <xsl:element name="span">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.number.em</xsl:attribute>
      <xsl:attribute name="style">font-size: 10pt; color: red;</xsl:attribute>
    </xsl:element>
  </xsl:template>


<!--
INTERACTION: Phone Number
-->
  <xsl:template match="phoneNumberInteraction">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name="value" select="/*/interactionState/contentItem[@subitem=$subitem]/phoneNumber/@value" />
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
    <!-- output field #1 -->
    <xsl:call-template name="outputPhoneNumberField">
      <xsl:with-param name="index">1</xsl:with-param>
      <xsl:with-param name="value" select="substring($value, 1, 3)"/>
      <xsl:with-param name="maxLength">3</xsl:with-param>
    </xsl:call-template>

    <!-- output field #2 -->
    <xsl:call-template name="outputPhoneNumberField">
      <xsl:with-param name="index">2</xsl:with-param>
      <xsl:with-param name="value" select="substring($value, 4, 3)"/>
      <xsl:with-param name="maxLength">3</xsl:with-param>
    </xsl:call-template>

    <!-- output field #3 -->
    <xsl:call-template name="outputPhoneNumberField">
      <xsl:with-param name="index">3</xsl:with-param>
      <xsl:with-param name="value" select="substring($value, 7, 4)"/>
      <xsl:with-param name="maxLength">4</xsl:with-param>
    </xsl:call-template>

    <!-- output error message field -->
    <xsl:element name="span">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.phoneNumber.em</xsl:attribute>
      <xsl:attribute name="style">font-size: 10pt; color: red;</xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- subroutine for phone number -->
  <xsl:template name="outputPhoneNumberField">
    <!-- disabled because not used and $subitem is not defined
    <xsl:param name="index"/>
    <xsl:param name="value"/>
    <xsl:param name="maxLength"/>

    <xsl:element name="input">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.phoneNumber.input<xsl:value-of select="$index"/></xsl:attribute>
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="maxLength"><xsl:value-of select="$maxLength"/></xsl:attribute>
      <xsl:attribute name="style">border: solid 1px #999999; width: 40px; margin-right: 5px;</xsl:attribute>
      <xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
      <xsl:attribute name="onkeyup">g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'phoneNumber').HandleNumberEntered(this);</xsl:attribute>
      <xsl:choose>
        <xsl:when test="@responseRequired = 'yes'">
          <xsl:attribute name="RESPONSEREQUIRED">true</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="RESPONSEREQUIRED">false</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    -->
  </xsl:template>

<!--
INTERACTION: Numeric Blank
-->
  <xsl:template match="numEntryAnswerInput">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name="value" select="/*/interactionState/contentItem[@subitem=$subitem]/numEntryAnswerInput/@value" />
    <style type="text/css">

      .selectedansstyle.incorrectansstyle{
      background-image:url('/apps/delivery/media/responseInCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
      .selectedansstyle.correctansstyle{
      background-image:url('/apps/delivery/media/responseCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
    </style>
    <table cellspacing="0" cellpadding="0" style="margin:auto;">
    <xsl:choose>
      <xsl:when test="@type = 'fraction'">
        <tr>
          <xsl:call-template name="numEntryInput">
            <xsl:with-param name="subitem" select="$subitem"/>
            <xsl:with-param name="inputNum">1</xsl:with-param>
            <xsl:with-param name="value" select="substring-before($value, ':')"/>
            <xsl:with-param name="type" select="@type"/>
            <xsl:with-param name="correctValue" select="substring-before(@correctValue, ':')"/>
          </xsl:call-template>
        </tr>
        <tr>
          <td><div style="width:160px;border-bottom:solid 1px black;margin: 5px auto;"></div></td>
        </tr>
        <tr>
          <xsl:call-template name="numEntryInput">
            <xsl:with-param name="subitem" select="$subitem"/>
            <xsl:with-param name="inputNum">2</xsl:with-param>
            <xsl:with-param name="value" select="substring-after($value, ':')"/>
            <xsl:with-param name="type" select="@type"/>
            <xsl:with-param name="correctValue" select="substring-after(@correctValue, ':')"/>
          </xsl:call-template>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
        <xsl:call-template name="numEntryInput">
          <xsl:with-param name="subitem" select="$subitem"/>
          <xsl:with-param name="inputNum">1</xsl:with-param>
          <xsl:with-param name="value" select="$value"/>
          <xsl:with-param name="type" select="@type"/>
          <xsl:with-param name="correctValue" select="@correctValue"/>
        </xsl:call-template>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
    </table>
  </xsl:template>

<!--
  Subroutiune for inputs for Numeric Blank
-->
  <xsl:template name="numEntryInput">
    <xsl:param name="subitem" />
    <xsl:param name="inputNum"/>
    <xsl:param name="value" />
    <xsl:param name="type"/>
    <xsl:param name="correctValue"/>
        <td style="margin:auto;width:160px">
      <div style="width:190px;">
        <div style="padding-left:2px;">
        <xsl:element name="input"><xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.numericBlank.input<xsl:value-of select="$inputNum"/></xsl:attribute>
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="maxLength">10</xsl:attribute>
          <xsl:attribute name="onkeypress">if (window["g_seqMgr"] != null) return g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'numericBlank').HandleKeyPress(event, this);</xsl:attribute>
          <xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
          <xsl:attribute name="style">margin:auto;text-align:center;</xsl:attribute>
          <xsl:if test="$mode='review'">
            <xsl:attribute name="class">target</xsl:attribute>
            <xsl:attribute name="disabled">true</xsl:attribute>
          </xsl:if>
        </xsl:element>
        </div>
      </div>
        </td>
      <xsl:if test="($mode='review' or $explanations='True')">
          <td>
          <xsl:element name="input">
        <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.numericBlank.input.correctans<xsl:value-of select="$inputNum"></xsl:value-of></xsl:attribute>
        <xsl:attribute name="type">text</xsl:attribute>
        <xsl:attribute name="maxLength">10</xsl:attribute>
        <xsl:attribute name="disabled">true</xsl:attribute>
        <xsl:attribute name="value">
        <xsl:value-of  select="$correctValue"></xsl:value-of>
        </xsl:attribute>
        <xsl:attribute name="style">border:solid 1px #fff;display:none;text-align:center;</xsl:attribute>
        <xsl:attribute name="class">correctanswerhighlight highlighted</xsl:attribute>
            <script language="javascript">
        function ToggleCorrectAnsVisibility(position){
          var corAns = window.g_seqMgr.frameWin.$(".correctanswerhighlight", window.g_seqMgr.contentWin.document);
          if (corAns.attr('id').indexOf('multipleAnswerMultipleChoice') >= 0){
            if (corAns.hasClass('notHighlighted') ) {
              corAns.removeClass('notHighlighted');
              corAns.css("border-color", "#009933");
              corAns.css("display", "inline");
              corAns.css("margin", "auto");
              corAns.css("margin-top", "2px");
            } else {
              corAns.addClass('notHighlighted');
              corAns.css("border-color", "#ffffff");
              corAns.css("display", "none");
            }
          }
        };

        setTimeout(setResponseMarkers,200);

        function setResponseMarkers(){
        <xsl:choose>
          <xsl:when test="@type = 'fraction'">
            var fractionTextBox = document.getElementById('subitem<xsl:value-of select="$subitem"/>.numericBlank.input<xsl:value-of select="$inputNum"/>');
            if(fractionTextBox.value == <xsl:value-of  select="$correctValue"/>){
              fractionTextBox.parentNode.parentNode.className="selectedansstyle correctansstyle";
             }
            else{
              if(fractionTextBox.value != "")
              fractionTextBox.parentNode.parentNode.className="selectedansstyle incorrectansstyle";
            }


            <!--var fractionTextBox = document.getElementById('subitem<xsl:value-of select="$subitem"/>.numericBlank.input<xsl:value-of select="$inputNum"/>');
            var textbox = window.g_seqMgr.frameWin.$('#sequenceContentFrame').contents().find('.target')[0];
            if(fractionTextBox.value == <xsl:value-of  select="$correctValue"/>){
              textbox.parentNode.parentNode.className="selectedansstyle correctansstyle";
            }
            else{
              if(fractionTextBox.value != "")
              textbox.parentNode.parentNode.className="selectedansstyle incorrectansstyle";
            }-->
          </xsl:when>
          <xsl:otherwise>
            var textbox = window.g_seqMgr.frameWin.$('#sequenceContentFrame').contents().find('.target')[0];
            if(textbox){
            if(textbox.value == <xsl:value-of  select="$correctValue"></xsl:value-of>){
              textbox.parentNode.parentNode.className="selectedansstyle correctansstyle";
            }
            else{
              if(textbox.value != "")
              textbox.parentNode.parentNode.className="selectedansstyle incorrectansstyle";
            }
            }
          </xsl:otherwise>
        </xsl:choose>
        }

          </script>
        </xsl:element>
          </td>
      </xsl:if>
  </xsl:template>

<!--
  INTERACTION: Highlight Blank
-->
  <xsl:template match="highlightResponseChoiceSet">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name="totalChoices" select="count(highlightResponseChoice)"/>
      <style type="text/css">
        .selected{
           background-color:#000 !Important;
           color:#FFF !Important;
        }
        .selected.review{
           background-color:#444 !Important;
           color:#777 !Important;
        }

    </style>
    <table>
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.highlightBlank</xsl:attribute>
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="cellpadding">4</xsl:attribute>
      <xsl:attribute name="style">color:#000;width:auto;margin:auto;</xsl:attribute>
      <tr>
        <xsl:apply-templates select="highlightResponseChoice">
          <xsl:with-param name="subitem" select="$subitem"/>
          <xsl:with-param name="totalChoices" select="$totalChoices"/>
        </xsl:apply-templates>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="highlightResponseChoice">
    <xsl:param name="subitem"/>
    <xsl:param name="totalChoices"/>
    <xsl:variable name="col" select="position()- 1" />
    <td>
      <table border="0">
        <xsl:attribute name="id">
          subitem<xsl:value-of select="$subitem"/>.highlightBlank.<xsl:value-of select="$col"/>
        </xsl:attribute>
        <xsl:attribute name="cellPadding">0</xsl:attribute>
        <xsl:attribute name="cellspacing">0</xsl:attribute>
        <!-- header for column-->
        <tr>
          <td style="text-align: center; color: #ffffff;">
            <xsl:attribute name="style">text-align: center; font-weight:bold; color: #003162;padding-bottom:10px;</xsl:attribute>
            <xsl:choose>
              <xsl:when test="count(//highlightResponseChoice) &gt; 1">
                Blank (<xsl:number value="@id" format="i" />)
              </xsl:when>
            </xsl:choose>
          </td>

        </tr>
        <xsl:apply-templates select="highlightResponse">
          <xsl:with-param name="subitem" select="$subitem"/>
          <xsl:with-param name="col" select="$col"/>
        </xsl:apply-templates>
        <tr>
          <td style="height:2px;border:1px solid;"></td>
        </tr>
      </table>
      </td>
  </xsl:template>

  <xsl:template match="highlightResponse">
    <xsl:param name="subitem"/>
    <xsl:param name="col"/>

    <tr>
      <td>
        <xsl:attribute name="id">
          subitem<xsl:value-of select="$subitem"/>.highlightBlank.<xsl:value-of select="$col"/>.<xsl:value-of select="position()"/>
        </xsl:attribute>
        <xsl:attribute name="onclick">
          if (window["g_seqMgr"] != null)g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'highlightBlank').HandleResponseSelect(this, null);
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:if test="$mode = 'sim'">cursor: hand; cursor: pointer; </xsl:if>background-color: #FFF; color: #000000;border:1px solid #000; width:200px;
        </xsl:attribute>
        <table style="width: 100%;">
          <xsl:attribute name="align">center</xsl:attribute>
          <xsl:attribute name="border">0</xsl:attribute>
          <tr>
            <td>
              <xsl:attribute name="style">text-align: center;</xsl:attribute>
              <span style="padding-left: 20px; padding-right: 20px;">
                <xsl:value-of select="@value"/>
              </span>
            </td>
            <xsl:if test="$mode = 'review'">
              <td style="text-align: right;">
                <img>
                  <xsl:choose>
                    <xsl:when test="@correct = 'yes'">
                      <xsl:attribute name="src">media/responseCorrect.gif</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="src">media/responseInCorrect.gif</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                </img>
              </td>
            </xsl:if>
          </tr>
        </table>
      </td>
      <xsl:if test="$mode = 'review'">
        <td>

        </td>
      </xsl:if>
    </tr>
  </xsl:template>


  <!--
  INTERACTION: Scrambled Paragraph
  -->

  <xsl:template match="scrambled-paragraph">

    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>


    <!-- output the hidden fields for this interaction type -->
    <xsl:apply-templates select="/*/interactionState/contentItem/*" mode="outputInteractionTypeFields"/>

    <html>
      <body>
        <style type="text/css">

          .choiceContent
          {
          padding-top:5px;
          padding-bottom:5px;
          }
          .choiceContentReview
          {
          padding-top:0px;
          padding-bottom:0px;
          }

        </style>
        <table>
          <xsl:for-each select="scrambled-paragraph-phrase">
            <tr>
              <td>
                <xsl:choose>
                  <xsl:when test="$mode='review'">
                    <xsl:element name="input">
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="id">lblCorrectSeq<xsl:value-of select="position()"/></xsl:attribute>
                      <xsl:attribute name="readonly"></xsl:attribute>
                      <xsl:attribute name="style">width: 20; border: 0; text-decoration: underline;</xsl:attribute>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="select">
                      <xsl:attribute name="name">ddlCorrectSeq<xsl:value-of select="position()"/></xsl:attribute>
                      <option value="0"></option>
                      <option value="1">1</option>
                      <option value="2">2</option>
                      <option value="3">3</option>
                      <option value="4">4</option>
                      <option value="5">5</option>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <b>
                  <xsl:number value="position()+16" format="A" />.
                </b>
              </td>
              <td>
                <xsl:value-of select="."/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="scrambledParagraph" mode="outputInteractionTypeFields">
    <!-- output a hidden field for the question type -->
    <xsl:element name="input">
      <xsl:attribute name="type">hidden</xsl:attribute>
      <xsl:attribute name="id">
        subitem<xsl:value-of select="parent::contentItem/@subitem"/>.interactionType<xsl:value-of select="count(preceding-sibling::*)"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
    </xsl:element>

    <!-- output a hidden field for the item Index -->
    <xsl:element name="input">
      <xsl:attribute name="type">hidden</xsl:attribute>
      <xsl:attribute name="id">itemIndex</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="parent::contentItem/@subitem"/>
      </xsl:attribute>
    </xsl:element>

    <!-- output a hidden field for the previous selected Index -->
    <xsl:element name="input">
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="id">
        previousSelectedIndex<xsl:value-of select="parent::contentItem/@subitem"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="@previousAnswer"/>
      </xsl:attribute>
    </xsl:element>

    <!-- output a hidden field for the selected Index -->
    <xsl:element name="input">
      <xsl:attribute name="type">text</xsl:attribute>
      <xsl:attribute name="id">
        selectedIndex<xsl:value-of select="parent::contentItem/@subitem"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="@selectedAnswer"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!--
  INTERACTION: Grid In
  -->

  <xsl:template match="gridInAnswerInput">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
    <xsl:if test="$mode='review'">
      <span style="color: #009900; font-weight: bold;">
        CORRECT:<br/>
        <xsl:choose>
          <xsl:when test="count(exactAnswer) = 1">
            <xsl:value-of select="exactAnswer/@value"/>
          </xsl:when>
          <xsl:when test="count(exactAnswer) &gt; 1">
            X = <xsl:for-each select="exactAnswer"><xsl:if test="position() > 1"> or </xsl:if><xsl:value-of select="@value"/></xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="rangeAnswer/@type='exclusive'">
                <xsl:value-of select="rangeAnswer/@loValue"/> &lt; X &lt; <xsl:value-of select="rangeAnswer/@hiValue"/>
              </xsl:when>
              <xsl:when test="rangeAnswer/@type='inclusiveHi'">
                <xsl:value-of select="rangeAnswer/@loValue"/> &lt; X &lt;= <xsl:value-of select="rangeAnswer/@hiValue"/>
              </xsl:when>
              <xsl:when test="rangeAnswer/@type='inclusiveLo'">
                <xsl:value-of select="rangeAnswer/@loValue"/> &lt;= X &lt; <xsl:value-of select="rangeAnswer/@hiValue"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="rangeAnswer/@loValue"/> &lt;= X &lt;= <xsl:value-of select="rangeAnswer/@hiValue"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <br/>
      <br/>
    </xsl:if>

    <table cellpadding="0" cellspacing="0" style="border-style: double; border-width: 3px; border-color: #000000; margin-left: 20px;">
      <xsl:attribute name="id">subitem<xsl:value-of select="$subitem"/>.gridIn</xsl:attribute>
      <tr>
        <xsl:element name="td">
          <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.gridInLed1</xsl:attribute>
          <xsl:attribute name="style">border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;</xsl:attribute>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.gridInLed2</xsl:attribute>
          <xsl:attribute name="style">border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;</xsl:attribute>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.gridInLed3</xsl:attribute>
          <xsl:attribute name="style">border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;</xsl:attribute>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.gridInLed4</xsl:attribute>
          <xsl:attribute name="style">border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;</xsl:attribute>
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </xsl:element>
      </tr>
      <tr>
        <td id="gridInLed1" style="border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;">

        </td>
        <td id="gridInLed2" style="border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;">

        </td>
        <td id="gridInLed3" style="border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;">

        </td>
        <td id="gridInLed4" style="border-style: solid; border-width: 1px; border-color: #000000; text-align: center; font-weight: bold;">

        </td>
      </tr>
      <tr>
        <td style="background-color: #cccccc;"></td>
        <xsl:call-template name="outputGridInCell">
          <xsl:with-param name="col" select="2"/>
          <xsl:with-param name="num">/</xsl:with-param>
          <xsl:with-param name="background-color">cccccc</xsl:with-param>
          <xsl:with-param name="subitem" select="$subitem" />
        </xsl:call-template>
        <xsl:call-template name="outputGridInCell">
          <xsl:with-param name="col" select="3"/>
          <xsl:with-param name="num">/</xsl:with-param>
          <xsl:with-param name="background-color">cccccc</xsl:with-param>
          <xsl:with-param name="subitem" select="$subitem" />
        </xsl:call-template>
        <td style="background-color: #cccccc;"></td>
      </tr>
      <tr>
        <xsl:call-template name="outputGridInCell">
          <xsl:with-param name="col" select="1"/>
          <xsl:with-param name="num">.</xsl:with-param>
          <xsl:with-param name="background-color">cccccc</xsl:with-param>
          <xsl:with-param name="subitem" select="$subitem" />
        </xsl:call-template>
        <xsl:call-template name="outputGridInCell">
          <xsl:with-param name="col" select="2"/>
          <xsl:with-param name="num">.</xsl:with-param>
          <xsl:with-param name="background-color">cccccc</xsl:with-param>
          <xsl:with-param name="subitem" select="$subitem" />
        </xsl:call-template>
        <xsl:call-template name="outputGridInCell">
          <xsl:with-param name="col" select="3"/>
          <xsl:with-param name="num">.</xsl:with-param>
          <xsl:with-param name="background-color">cccccc</xsl:with-param>
          <xsl:with-param name="subitem" select="$subitem" />
        </xsl:call-template>
        <xsl:call-template name="outputGridInCell">
          <xsl:with-param name="col" select="4"/>
          <xsl:with-param name="num">.</xsl:with-param>
          <xsl:with-param name="background-color">cccccc</xsl:with-param>
          <xsl:with-param name="subitem" select="$subitem" />
        </xsl:call-template>
      </tr>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">0</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">1</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">2</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">3</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">4</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">5</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">6</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">7</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">8</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInRow">
        <xsl:with-param name="num">9</xsl:with-param>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
    </table>
  </xsl:template>

  <xsl:template name="outputGridInRow">
    <xsl:param name="num"/>
    <xsl:param name="subitem" />
    <tr>
      <xsl:call-template name="outputGridInCell">
        <xsl:with-param name="col" select="1"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInCell">
        <xsl:with-param name="col" select="2"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInCell">
        <xsl:with-param name="col" select="3"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
      <xsl:call-template name="outputGridInCell">
        <xsl:with-param name="col" select="4"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="subitem" select="$subitem" />
      </xsl:call-template>
    </tr>
  </xsl:template>

  <xsl:template name="outputGridInCell">
    <xsl:param name="col"/>
    <xsl:param name="num"/>
    <xsl:param name="background-color"/>
    <xsl:param name="subitem" />
    <xsl:variable name="num0">
      <xsl:call-template name="outputGridInFileName">
        <xsl:with-param name="num" select="$num"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:element name="td">
      <xsl:attribute name="style">padding-left: 1px; cursor: pointer; cursor: hand;<xsl:if test="$background-color!=''">background-color: #<xsl:value-of select="$background-color"/>;</xsl:if></xsl:attribute>
      <xsl:element name="img">
        <xsl:attribute name="id"><xsl:value-of select="$subitem"/>.<xsl:value-of select="$col"/>.<xsl:value-of select="$num"/></xsl:attribute>
        <xsl:attribute name="src">media/gridInNums/<xsl:value-of select="$num0"/>_lo.gif</xsl:attribute>
        <xsl:attribute name="OVERSRC">media/gridInNums/<xsl:call-template name="outputSelectedGridInFileName"><xsl:with-param name="num" select="$num"/></xsl:call-template>.gif</xsl:attribute>
        <xsl:attribute name="OUTSRC">media/gridInNums/<xsl:value-of select="$num0"/>_lo.gif</xsl:attribute>
        <xsl:if test="$mode != 'review'">
          <xsl:attribute name="onMouseOver">if (window["g_seqMgr"] != null)g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'gridIns').HandleMouseOver(this);</xsl:attribute>
          <xsl:attribute name="onMouseOut">if (window["g_seqMgr"] != null)g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'gridIns').HandleMouseOut(this);</xsl:attribute>
          <xsl:attribute name="onClick">if (window["g_seqMgr"] != null)g_seqMgr.InteractionControls.GetControl('<xsl:value-of select="$subitem"/>', 'gridIns').HandleClick(this);</xsl:attribute>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="outputGridInFileName">
    <xsl:param name="num"/>
    <xsl:choose>
      <xsl:when test="$num='.'">dot</xsl:when>
      <xsl:when test="$num='/'">slash</xsl:when>
      <xsl:otherwise><xsl:value-of select="$num"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="outputSelectedGridInFileName">
    <xsl:param name="num"/>
    <xsl:choose>
      <xsl:when test="$num='.'">hi_bg</xsl:when>
      <xsl:when test="$num='/'">hi_bg</xsl:when>
      <xsl:otherwise>hi</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  INTERACTION: Two Part Analysis
  -->

  <xsl:template match="two-part-analysis">
    <style type="text/css">

      .selectedansstyle.incorrectansstyle{
      background-image:url('/apps/delivery/media/responseInCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
      .selectedansstyle.correctansstyle{
      background-image:url('/apps/delivery/media/responseCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }

      .twopartHeaderCell{font-weight:bold;border-bottom:solid 1px #80AEE1;<xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>;</xsl:if><xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>}
      .twopartAnswerOption{border-right:solid 1px #80AEE1;}
    </style>

    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>

    <table cellpadding="5" cellspacing="0" border="0" class="interaction" name="twoPartAnalysis">
      <xsl:attribute name="id">subitem<xsl:value-of select="ancestor::*[@subitem][1]/@subitem"/>.twoPartAnalysis</xsl:attribute>
      <xsl:attribute name="answerChoiceCount"><xsl:value-of select="count(analysis-answer-choice)" /></xsl:attribute>
    <xsl:if test="@width !=''">
    <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
    </xsl:if>
      <tr>
        <td align="center" style="max-width:150px;" class="twopartHeaderCell">
      <xsl:if test="@part1Header-width !=''">
        <xsl:attribute name="width"><xsl:value-of select="@part1Header-width"/></xsl:attribute>
      </xsl:if>
          <xsl:value-of select="@part1Header" />
        </td>
        <td align="center" style="max-width:150px;" class="twopartHeaderCell">
      <xsl:if test="@part2Header-width !=''">
        <xsl:attribute name="width"><xsl:value-of select="@part2Header-width"/></xsl:attribute>
      </xsl:if>
          <xsl:value-of select="@part2Header" />
        </td>
        <td align="center" class="twopartHeaderCell">
      <xsl:if test="@contentHeader-width !=''">
        <xsl:attribute name="width"><xsl:value-of select="@contentHeader-width"/></xsl:attribute>
      </xsl:if>
          <xsl:value-of select="@contentHeader" />
        </td>
      </tr>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="analysis-answer-choice">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name="rowId">subitem<xsl:value-of select="$subitem"/>.twoPartAnalysis.answerChoiceRow<xsl:value-of select="position()"/></xsl:variable>

    <tr class="answerChoiceRow" style="padding: 5px 0px 5px 0px;">
      <xsl:attribute name="name"><xsl:value-of select="position()"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$rowId"/></xsl:attribute>

      <!-- output the bubble -->
      <td style="padding-right: 3px;" class="twopartAnswerOption">
    <xsl:attribute name="align">
      <xsl:choose>
        <xsl:when test="ancestor::two-part-analysis/@part1Header-align !=''"><xsl:value-of select="ancestor::two-part-analysis/@part1Header-align"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="'center'"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
        <span class="parentindicator">
          <xsl:if test="$mode='review'">
            <xsl:attribute name="class">parentindicator incorrectansstyle</xsl:attribute>
          </xsl:if>
          <xsl:if test="$mode='review' and @part1Correct='yes'">

            <xsl:attribute name="class">parentindicator correctansstyle</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="style">padding:0 20px 0 20px;min-width:50px;</xsl:attribute>
          <span>
          <xsl:if test="$mode='review' and @part1Correct='yes'">
            <xsl:attribute name="class">correctanswerhighlight1 highlighted</xsl:attribute>
            <xsl:attribute name="style">border:solid 1px #009933</xsl:attribute>
          </xsl:if>
          <xsl:element name="input">
            <xsl:attribute name="type">radio</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.question1.state1</xsl:attribute>
            <xsl:attribute name="questionPosition">1</xsl:attribute>
          </xsl:element>
        </span>
        </span>
      </td>
      <td style="padding-right: 3px;" class="twopartAnswerOption">
    <xsl:attribute name="align">
      <xsl:choose>
        <xsl:when test="ancestor::two-part-analysis/@part2Header-align !=''"><xsl:value-of select="ancestor::two-part-analysis/@part2Header-align"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="'center'"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
        <span class="parentindicator">
          <xsl:if test="$mode='review'">
            <xsl:attribute name="class">parentindicator incorrectansstyle</xsl:attribute>
          </xsl:if>
          <xsl:if test="$mode='review' and @part2Correct='yes'">
            <xsl:attribute name="class">parentindicator correctansstyle</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="style">padding:0 20px 0 20px;min-width:50px;</xsl:attribute>
          <span>
            <xsl:if test="$mode='review' and @part2Correct='yes'">
              <xsl:attribute name="class">correctanswerhighlight1 highlighted</xsl:attribute>
              <xsl:attribute name="style">border:solid 1px #fff</xsl:attribute>
            </xsl:if>
            <xsl:element name="input">
              <xsl:attribute name="type">radio</xsl:attribute>
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.question2.state1</xsl:attribute>
              <xsl:attribute name="questionPosition">2</xsl:attribute>
            </xsl:element>
          </span>
        </span>
      </td>
      <!-- output the choice content -->
      <xsl:element name="td">
        <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.content</xsl:attribute>
        <xsl:attribute name="class">choiceContent<xsl:if test="$mode='review'">Review</xsl:if></xsl:attribute>
        <xsl:attribute name="align">
      <xsl:choose>
        <xsl:when test="ancestor::two-part-analysis/@contentHeader-align !=''"><xsl:value-of select="ancestor::two-part-analysis/@contentHeader-align"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="'center'"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>;</xsl:if>
          <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>
        </xsl:attribute>
        <xsl:apply-templates />
      </xsl:element>
    </tr>
  </xsl:template>

  <!--
  INTERACTION: Multiple Question with Yes/No Answer
  -->

  <xsl:template match="multi-yesno-questions">
    <style type="text/css">

      .yesCorrect.noSelected , .noCorrect.yesSelected{
      background-image:url('/apps/delivery/media/responseInCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
      .yesSelected.yesCorrect, .noSelected.noCorrect{
      background-image:url('/apps/delivery/media/responseCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
    </style>
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
      <table width="100%" cellpadding="5" cellspacing="0" border="0" class="interaction" name="multipleYesNoQuestion">
      <xsl:attribute name="id">subitem<xsl:value-of select="ancestor::*[@subitem][1]/@subitem"/>.multipleYesNoQuestion</xsl:attribute>
      <xsl:attribute name="questionCount"><xsl:value-of select="count(yesno-question)" /></xsl:attribute>
      <tr>
        <td align="center">
          <xsl:attribute name="style">
          <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>;</xsl:if>
          <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>padding-right:10px;max-width:70px;
          </xsl:attribute>
          <xsl:value-of select="@yesHeader" /></td>
        <td align="center">
          <xsl:attribute name="style">
          <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>;</xsl:if>
          <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>max-width:50px;
          </xsl:attribute>
          <xsl:value-of select="@noHeader" /></td>
        <td></td>
      </tr>
      <xsl:for-each select="yesno-question"><xsl:apply-templates select="."/></xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="yesno-question">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name="pos" select="count(preceding-sibling::node()[name()='yesno-question'])+1"/>
    <xsl:variable name="rowId">subitem<xsl:value-of select="$subitem"/>.multipleYesNoQuestion.questionRow<xsl:value-of select="$pos"/></xsl:variable>

    <tr class="questionRow" style="padding: 2px 0px 2px 0px;">
      <xsl:attribute name="name"><xsl:value-of select="$pos"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$rowId"/></xsl:attribute>

      <!-- output the bubble -->
      <td style="padding-right:3px;width:70px;" align="center">
        <span>
          <xsl:if test="$mode='review'"><xsl:attribute name="class">noCorrect</xsl:attribute></xsl:if>
          <xsl:if test="$mode='review' and @answer='yes'"><xsl:attribute name="class">parentindicator yesCorrect</xsl:attribute></xsl:if>
          <xsl:attribute name="style">padding:0 20px 0 20px;min-width:50px;</xsl:attribute>
          <span style="border:solid 1px #FFFFFF">
            <xsl:if test="$mode='review' and @answer='yes'">
              <xsl:attribute name="class">correctanswerhighlight highlighted<xsl:value-of select="$pos"/></xsl:attribute>
              <xsl:attribute name="style">border:solid 1px #fff</xsl:attribute>
            </xsl:if>
            <xsl:element name="input">
              <xsl:attribute name="type">radio</xsl:attribute>
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.ans1.state1</xsl:attribute>
              <xsl:attribute name="ansPosition">1</xsl:attribute>
            </xsl:element>
          </span>
        </span>
      </td>
      <td style="padding-right:3px;width:50px;" align="center">

          <span style="border:solid 1px #FFFFFF">
            <xsl:if test="$mode='review' and @answer='no'">
              <xsl:attribute name="class">correctanswerhighlight highlighted<xsl:value-of select="$pos"/></xsl:attribute>
              <xsl:attribute name="style">border:solid 1px #009933</xsl:attribute>
            </xsl:if>
            <xsl:element name="input">
              <xsl:attribute name="type">radio</xsl:attribute>
              <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.ans2.state1</xsl:attribute>
              <xsl:attribute name="ansPosition">2</xsl:attribute>
            </xsl:element>

        </span>
      </td>
      <!-- output the choice content -->
      <xsl:element name="td">
        <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.content</xsl:attribute>
        <xsl:attribute name="class">choiceContent<xsl:if test="$mode='review'">Review</xsl:if></xsl:attribute>
        <xsl:attribute name="style">
          <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>;</xsl:if>
          <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>
        </xsl:attribute>
        <xsl:apply-templates />
      </xsl:element>
    </tr>
    <xsl:if test="$mode='review' or $explanations='True'">
    <tr>
      <td colspan="3">
        <xsl:apply-templates select="../descendant::explanation[@interaction='true'][$pos]"/>
      </td>
    </tr>
    </xsl:if>
  </xsl:template>

  <!--
  INTERACTION: Multi Answer PickList
  -->

  <xsl:template match="multi-picklist">
    <style>
      .hoverSelect {border-width: 1px; border-color:#555555;}
      .hoverSelect:hover {border-width: 1px; border-color:#AAAAFF;}

      .selectedansstyle.incorrectansstyle{
      background-image:url('/apps/delivery/media/responseInCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
      .selectedansstyle.correctansstyle{
      background-image:url('/apps/delivery/media/responseCorrect.gif');
      background-repeat: no-repeat;
      background-position: left center;
      }
      .borderHidden{
      border:1px solid #AAAAAA;
      border-color:#AAAAAA;
      }
      .borderShown{
      border:2px solid #009933;
      border-color:#009933;
      }

    </style>
    <style type="text/css">

      .choiceContent
      {
      padding-top:5px;
      padding-bottom:5px;
      }
      .choiceContentReview
      {
      padding-top:0px;
      padding-bottom:0px;
      }

    </style>
    <div class="interaction" name="multipleAnswerPickList">
      <xsl:attribute name="id">subitem<xsl:value-of select="ancestor::*[@subitem][1]/@subitem"/>.multipleAnswerPickList</xsl:attribute>
      <xsl:attribute name="answerCount"><xsl:value-of select="count(descendant::picklist-answer)" /></xsl:attribute>

      <script language="javascript">
        function ToggleCorrectAnsVisibility(position){
        <xsl:if test="$mode='review'">
          var corAns = window.g_seqMgr.frameWin.$(".correctanswerhighlight" + position, window.g_seqMgr.contentWin.document);
          corAns.css("border-color", "");
          if(!corAns.hasClass("borderHidden")){
          corAns.removeClass("borderShown").addClass("borderHidden");
          }
          else{
          corAns.removeClass("borderHidden").addClass("borderShown");
          }
        </xsl:if>
        }
      </script>

      <xsl:apply-templates/>

      <script language="javascript">
        window.g_seqMgr.frameWin.$("select",window.document).change(function (eventObject) {
        window.g_seqMgr.frameWin.$(this).find("option[value='-1']").remove();
        window.g_seqMgr.frameWin.$(this).unbind('change');
        });
      </script>
    </div>

  </xsl:template>

  <xsl:template match="picklist-answer">
    <xsl:variable name="subitem" select="ancestor::*[@subitem][1]/@subitem"/>
    <xsl:variable name ="pos" select="count(../preceding-sibling::node()[name()='para']/descendant::picklist-answer)+1"/>
    <xsl:variable name="rowId">subitem<xsl:value-of select="$subitem"/>.multipleAnswerPickList.answer<xsl:value-of select="$pos"/></xsl:variable>
    <xsl:if test="$mode='review'">
        <xsl:variable name="optionCount" select="count(pickListOption)"/>
        <xsl:for-each select="pickListOption">

            <span class="parentindicator borderHidden">
              <xsl:if test="$mode='review'">
                <xsl:attribute name="class">parentindicator incorrectansstyle borderHidden</xsl:attribute>
              </xsl:if>
              <xsl:if test="$mode='review' and @correct='yes'">
                 <xsl:attribute name="class">parentindicator correctansstyle borderShown correctanswerhighlight<xsl:value-of select="$pos"/></xsl:attribute>
              </xsl:if>
            <xsl:attribute name="id"><xsl:value-of select="$rowId"/>.<xsl:value-of select="position()"/></xsl:attribute>
            <xsl:attribute name="style">padding:0 20px 0 20px;margin:0 2px 0 2px;min-width:50px;</xsl:attribute>
            <span><xsl:value-of select="@title"/></span>
           </span>
        </xsl:for-each>
    </xsl:if>
    <span id="selectedAns{$pos}">
      <xsl:if test="$mode='review'"><xsl:attribute name="style">display:none;</xsl:attribute></xsl:if>
    <select class="hoverSelect">
      <xsl:attribute name="id"><xsl:value-of select="$rowId"/></xsl:attribute>
      <xsl:attribute name="style">
        <xsl:if test="$mode='review' and @correct='yes'">border-color: #009933; padding: 0px 2px 0px 2px;</xsl:if>
        <xsl:if test="$fontFamily != '' ">font-family: <xsl:value-of select="$fontFamily"/>;</xsl:if>
        <xsl:if test="$fontSize != '' ">font-size: <xsl:value-of select="$fontSize"/>;</xsl:if>
      </xsl:attribute>
      <option value="-1">Select...</option>
      <xsl:apply-templates />
    </select>
    </span>
  </xsl:template>

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

  <!--
  INTERACTION: Insert Sentence
  -->
  <xsl:template match="insert-sentence">
    <div class="insert-sentence" style="display: none">
      <xsl:attribute name="id">
        <xsl:value-of select="concat('subitem', ancestor::*[@subitem][1]/@subitem, '.insertSentence')"/>
      </xsl:attribute>

      <xsl:attribute name="data-section-class">
        <xsl:value-of select="@section-class"/>
      </xsl:attribute>

      <xsl:attribute name="data-section-para-index">
        <xsl:value-of select="@section-para-index"/>
      </xsl:attribute>

      <xsl:apply-templates />
    </div>

    <style>
      div.insert-sentence-instructions {
        width: 354px;
        margin: 0 auto;
        background-color: #dddddd;
        padding: 20px;
        margin-top: 100px;
      }

      span.insertion-point, span.sentence-insertion-point{
        display: inline-block;
        height: 17px;
        width: 17px;
        background-color: #000000;
        vertical-align: middle;
        margin: 0 2px;
      }

      span.insertion-point.correctAnswer, span.sentence-insertion-point.correctAnswer{
        background-color: #fec15d;
      }

      span.insertion-point-content, span.sentence-insertion-point-content{
        color: #ffffff;
        background-color: #000000;
        cursor: default;
        margin-right: 2px;
        padding: 1px 4px;
        vertical-align: middle;
      }

      span.insertion-point-content.correctAnswer, span.sentence-insertion-point-content.correctAnswer{
        background-color: #fec15d;
        color: #000000;
      }
    </style>
  </xsl:template>

  <xsl:template match="sentence">
    <div class="sentence">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="insertion-points">
    <div class="insertion-points" style="display: none;">
      <xsl:for-each select="insertion-point">
        <div class="insertion-point">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <xsl:if test="$mode='review' and @correctAnswer='yes'">
            <xsl:attribute name="class">
              <xsl:value-of select="'insertion-point correctAnswer'"/>
            </xsl:attribute>
          </xsl:if>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="passage-highlight">
    <style>
      .highlight-span{
        background-color: #d2d2d2;
        padding: 1px 2px;
      }
    </style>
    <script type="text/javascript" src="javascript/common/lib/jquery/min/jquery-1.6.1.min.js"></script>
    <script>
      var highlightSpanInterval = null

      function renderHighlightSpans(){
      var spanId = '<xsl:value-of select="translate(@id, '.', '-')"/>';
      try{
      var highlightSpanElem = window.parent.$('#' + spanId, window.parent.g_frameMgr.testModeFrame.frames[0].document);
      if (highlightSpanElem.length > 0){
      highlightSpanElem.show();

      var passageContainerElem = window.parent.$('#divPassage', window.parent.g_frameMgr.testModeFrame.frames[0].document);
      if (passageContainerElem.length > 0){
      passageContainerElem.scrollTop(highlightSpanElem.offset().top - 50);
      }
      clearInterval(highlightSpanInterval);
      }

      var highlightSpans = window.parent.$('.passage .highlight-span', window.parent.g_frameMgr.testModeFrame.frames[0].document);
      if (highlightSpans.length > 0){
      highlightSpans.each(function(index, elem){
      var elemId = window.parent.$(elem).attr('id');
      if (elemId != spanId){
      window.parent.$(elem).removeClass('highlight-span').show();
      }
      });
      }
      }
      catch(e){
      clearInterval(highlightSpanInterval);
      }
      }

      $(window).load(function() {
      highlightSpanInterval = setInterval(renderHighlightSpans(), 100);
      });

    </script>
  </xsl:template>

  <xsl:template match="passage-arrow">
    <style>
      span.arrow-mark{
        display: inline-block;
        background: url(/apps/delivery/UI/AthenaFull/images/passage-arrow.png);
        height: 18px;
        width: 22px;
        vertical-align: middle;
        margin-right: 2px;
      }
    </style>

    <div class="passage-arrow" style="display: none;">
      <xsl:for-each select="arrowSpan">
        <div class="para-arrow">
          <xsl:attribute name="data-para-index">
            <xsl:value-of select="@para-index"/>
          </xsl:attribute>
        </div>
      </xsl:for-each>
    </div>
    <script>
      var arrowSpanInterval = setInterval('renderArrowSpans()', 100);
      function renderArrowSpans(){
        try{
          var passageElem = window.parent.$('.passage', window.parent.g_frameMgr.testModeFrame.frames[0].document);
          if (passageElem.length > 0){
            var paraElems = passageElem.find('p');
            if (paraElems.length > 0){
              window.parent.$('.passage-arrow', window.parent.g_frameMgr.testModeFrame.frames[0].document).find('.para-arrow').each(function(index, element){
                var passageParaId = window.parent.$(element).attr('data-para-index');
                if (passageParaId != null &amp;&amp; passageParaId != ''){
                  passageParaId = parseInt(passageParaId);
                }
                var passagePara =  window.parent.$(paraElems[passageParaId - 1]);
                if (passagePara.length > 0){
                  var oldHtml = passagePara.html();
                  passagePara.html('<span class="arrow-mark"></span>' + oldHtml);

                  if (index === 0){
                    var passageContainerElem = window.parent.$('#divPassage', window.parent.g_frameMgr.testModeFrame.frames[0].document);
                    passageContainerElem.scrollTop(passagePara.offset().top - 50);
                  }
                }
              });
            }

            clearInterval(arrowSpanInterval);
          }
        }
        catch(e){
          clearInterval(arrowSpanInterval);
        }
      }
    </script>
  </xsl:template>
</xsl:stylesheet>
