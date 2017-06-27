$(document).ready(function () {
    var audioRecordingAvailable = null;
    //On 'next' button click...
    $('.navcontrol-nextposition').click(function (e) {

        //If the navigation controls are hidden, show them
        if ($('.navcontrols-container')[0].style.display == "none") {
            $('.navcontrols-container').show()
        }

        //If the current question is an essay question...
        if (window.parent.g_seqMgr.Mode === "sim" && $('.navcontrol-nextposition')[3].style.display === "block") {

            //And there is text in essay form field, attach metadata and essay to form...
            if (window.parent.$('textarea', window.parent.g_frameMgr.testModeFrame.frames[0].document).length !== 0) {
                if (window.parent.$('textarea', window.parent.g_frameMgr.testModeFrame.frames[0].document)[0].value !== "") {
                    var sequenceID = window.parent.g_seqMgr.sequenceId;
                    var contentItemID = window.parent.g_seqMgr.contentItemID;
                    var position = g_seqMgr.SequenceSession.position;
                    var title = g_seqMgr.SequenceSession.title;
                    var contentItemName = g_seqMgr.contentItemName;
                    var productID = window.parent.g_seqMgr.productID;
                    var ukProductionURL = g_seqMgr.ukAPIProductionURL;
                    var ukQAURL = g_seqMgr.ukAPIqaURL;
                    var historyDBID = window.parent.g_seqMgr.historyDBID;
                    var testEnv = window.location.href
                    testEnv.includes("qa") || testEnv.includes("395") || testEnv.includes("preview") ? testEnv = 0 : testEnv = 1
                    var essayText = $("textarea", g_seqMgr.contentDoc).val();

                    // First step in storing essay text locally for backup to then send in the case of AJAX failure.
                    //try {
                    //    if (typeof (Storage) !== "undefined") {
                    //        localStorage.setItem(productID + "." + historyDBID + "." + sequenceID + "." + contentItemID + "." + position + "." + "essayText", essayText);
                    //    } else {
                    //        "Sorry! Your browser does not support web storage. We won't have a backup of your essay text if for some reason you lose connection during the transmission of your essay."
                    //    }
                    //} catch (e) {
                    //    alert(e);
                    //}

                    $("form#essayForm", g_seqMgr.contentDoc).children()[6].value = sequenceID;
                    $("form#essayForm", g_seqMgr.contentDoc).children()[7].value = position;
                    $("form#essayForm", g_seqMgr.contentDoc).children()[8].value = title;
                    $("form#essayForm", g_seqMgr.contentDoc).children()[9].value = contentItemName;
                    $("form#essayForm", g_seqMgr.contentDoc).children()[10].value = testEnv;

                    //...and send to UK API for grading
                    e.preventDefault();
                    $("form#essayForm", g_seqMgr.contentDoc).children()[11].value = essayText;
                    var formData = new FormData($("form#essayForm", g_seqMgr.contentDoc)[0]);
                    $.ajax({
                        url: ukProductionURL,
                        type: 'POST',
                        data: formData,
                        async: false,
                        success: function (resp) {
                            console.info(resp)
                        },
                        failure: function (resp) {
                            console.info(resp)
                        },
                        cache: false,
                        contentType: false,
                        processData: false
                    });
                    console.log("Essay Submitted");
                }
            }
        }
    });

    //Setup audio recorder and get user permission to record audio
    try {
        window.AudioContext = window.AudioContext || window.webkitAudioContext;
        navigator.getUserMedia = (navigator.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia ||
        navigator.msGetUserMedia);
        window.URL = window.URL || window.webkitURL;

        audio_context = new AudioContext;
        console.log('Audio context set up.');
        console.log('navigator.getUserMedia ' + (navigator.getUserMedia ? 'available.' : 'not present!'));
        audioRecordingAvailable = true;
    } catch (e) {
        alert("Oops...it looks like the browser you are using doesn't support recording audio. Please switch to Google Chrome, Mozilla Firefox, or Microsoft Edge. This happened because: " + e);
        audioRecordingAvailable = false;
    }

    navigator.getUserMedia({ audio: true }, startUserMedia, function (e) {
        alert("You may have denied the browser permission to use the microphone.\n\nPlease reload the page and give permission again or change your settings to allow kaptest.com to always use your microphone.\n\nError: " + e.message);
        console.log(e);
        audioRecordingAvailable = false;
    });

});

//On 'quit' button click...
function quitTOEFL() {
    //Get metadata...
    e.preventDefault();
    var sequenceID = window.parent.g_seqMgr.sequenceId;
    var contentItemID = window.parent.g_seqMgr.contentItemID;
    var position = g_seqMgr.SequenceSession.position;
    var title = g_seqMgr.SequenceSession.title;
    var contentItemName = g_seqMgr.contentItemName;
    var productID = window.parent.g_seqMgr.productID;
    var ukProductionURL = g_seqMgr.ukAPIProductionURL;
    var ukQAURL = g_seqMgr.ukAPIqaURL;
    var testEnv = window.location.href
    testEnv.includes("qa") || testEnv.includes("395") || testEnv.includes("preview") ? testEnv = 0 : testEnv = 1
    //If question is an essay question, attach metadata form...
    if ($("form#essayForm", g_seqMgr.contentDoc).length != 0) {
        $("form#essayForm", g_seqMgr.contentDoc).children()[6].value = sequenceID;
        $("form#essayForm", g_seqMgr.contentDoc).children()[7].value = position;
        $("form#essayForm", g_seqMgr.contentDoc).children()[8].value = title;
        $("form#essayForm", g_seqMgr.contentDoc).children()[9].value = contentItemName;
        $("form#essayForm", g_seqMgr.contentDoc).children()[10].value = testEnv;
        //If there is text in the essay field, attach essay to form
        if ($("textarea", g_seqMgr.contentDoc).length != 0) {
            var essayText = $("textarea", g_seqMgr.contentDoc).val();
            //try {
            //    if (typeof (Storage) !== "undefined") {
            //        localStorage.setItem(productID + "." + historyDBID + "." + sequenceID + "." + contentItemID + "." + position + "." + "essayText", essayText);
            //    } else {
            //        "Sorry! Your browser does not support web storage. We won't have a backup of your essay text if for some reason you lose connection during the transmission of your essay."
            //    }
            //} catch (e) {
            //    alert(e);
            //}
            $("form#essayForm", g_seqMgr.contentDoc).children()[11].value = essayText
        }
        //Append a test complete flag to form
        var formData = new FormData($("form#essayForm", g_seqMgr.contentDoc)[0]);
        formData.append("submitComplete", 1)
    }
        //Else, if the question is not an essay question, build new form, attach meta data, and attach  submitComplete flag. We may have to rethink this as there is an edge case where the student quits or runs out of time during the first essay question, and we fail to send a test incomplete flag. This negates having the incomplete flag at all, and if the UK system logic isn't using that flag, then there is no reason to have it there.
    else {
        var formData = new FormData;
        var userEmail = window.parent.g_seqMgr.userEmail;
        var kbsEnrollmentID = window.parent.g_seqMgr.kbsEnrollmentID;
        var kaptestProductCode = window.parent.g_seqMgr.kaptestProductCode;
        var productID = window.parent.g_seqMgr.productID;
        var historyDBID = window.parent.g_seqMgr.historyDBID;
        var contentItemID = window.parent.g_seqMgr.contentItemID;
        var position = g_seqMgr.SequenceSession.position;
        var testEnv = window.location.href
        testEnv.includes("qa") || testEnv.includes("395") || testEnv.includes("preview") ? testEnv = 0 : testEnv = 1
        formData.append("email", userEmail);
        formData.append("kbsEnrollmentID", kbsEnrollmentID);
        formData.append("kaptestProductCode", kaptestProductCode);
        formData.append("productID", productID);
        formData.append("historyDBID", historyDBID);
        formData.append("sequenceID", sequenceID);
        formData.append("contentItemID", contentItemID);
        formData.append("position", position);
        formData.append("testTitle", title);
        formData.append("contentItemName", contentItemName);
        formData.append("testEnv", testEnv);
        formData.append("submitComplete", 1);
    }
    //Send form to UK API
    $.ajax({
        url: ukProductionURL,
        type: 'POST',
        data: formData,
        async: false,
        success: function (resp) {
            console.info(resp)
        },
        failure: function (resp) {
            console.info(resp)
        },
        cache: false,
        contentType: false,
        processData: false
    });

};

