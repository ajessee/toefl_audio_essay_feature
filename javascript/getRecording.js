
               function __log(e, data) {
                   log.innerHTML += "\n" + e + " " + (data || '');
               }

var audio_context;

function startUserMedia(stream) {
    var input = audio_context.createMediaStreamSource(stream);
    //__log('Media stream created.' );
    //__log("input sample rate " +input.context.sampleRate);

    // Feedback!
    //input.connect(audio_context.destination);
    //__log('Input connected to audio context destination.');

    window.parent.g_seqMgr.arecorder = new Recorder(input, {
        numChannels: 1
    });
    console.log('Recorder initialised.');
    //log.innerHTML = 'Recorder initialised.'
}

function startRecording() {
    window.parent.g_seqMgr.arecorder && window.parent.g_seqMgr.arecorder.record();
    if (window.parent.$('#startTestRecordingButton', window.parent.g_frameMgr.testModeFrame.frames[0].document)) {
        window.parent.$('#startTestRecordingButton', window.parent.g_frameMgr.testModeFrame.frames[0].document).hide()
        window.parent.$('#stopTestRecordingButton', window.parent.g_frameMgr.testModeFrame.frames[0].document).css("display", "block")
    }

    //button.disabled = true;
    //button.nextElementSibling.disabled = false;
    g_seqMgr.currentlyRecording = true;
    console.log('Recording...');
    //log.innerHTML = 'Recording...'
}


function stopRecording() {
    window.parent.g_seqMgr.arecorder && window.parent.g_seqMgr.arecorder.stop();
    //button.disabled = true;
    //button.previousElementSibling.disabled = false;
    console.log('Stopped recording.');
    //log.innerHTML = 'Stopped recording.'

    // create WAV download link using audio data blob
    createDownloadLink();
    console.log(window.parent.g_seqMgr.arecorder);
    window.parent.g_seqMgr.arecorder.clear();
    g_seqMgr.currentlyRecording = false;
    g_seqMgr.audioProcessing = true;
}

function stopRecordingTest() {
    window.parent.g_seqMgr.arecorder && window.parent.g_seqMgr.arecorder.stop();

    console.log('Stopped recording.');
    //log.innerHTML = 'Stopped recording.'

    // create WAV download link using audio data blob
    createDownloadLinkTest();
    console.log(window.parent.g_seqMgr.arecorder);
    window.parent.g_seqMgr.arecorder.clear();
    window.parent.$('#toeflSpinner', window.parent.g_frameMgr.testModeFrame.frames[0].document).show()
    window.parent.$('#stopTestRecordingButton', window.parent.g_frameMgr.testModeFrame.frames[0].document).hide()
    g_seqMgr.currentlyRecording = false;
    g_seqMgr.audioProcessing = true;
}

function createDownloadLinkTest() {

    window.parent.g_seqMgr.arecorder && window.parent.g_seqMgr.arecorder.exportWAV(function (blob) {
    }, 'audio/wav', true);

}

function createDownloadLink() {
    window.parent.g_seqMgr.arecorder && window.parent.g_seqMgr.arecorder.exportWAV(function (blob) {
        /*var url = URL.createObjectURL(blob);
        var li = document.createElement('li');
        var au = document.createElement('audio');
        var hf = document.createElement('a');

        au.controls = true;
        au.src = url;
        hf.href = url;
        hf.download = new Date().toISOString() + '.wav';
        hf.innerHTML = hf.download;
        li.appendChild(au);
        li.appendChild(hf);
        recordingslist.appendChild(li);*/
    });
}
