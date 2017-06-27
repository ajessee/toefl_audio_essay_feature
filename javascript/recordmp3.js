(function (window) {

    var WORKER_PATH = 'javascript/AtomWeb/recorderWorker.js';
    var encoderWorker = new Worker('javascript/AtomWeb/mp3Worker.js');

    var Recorder = function (source, cfg) {
        var config = cfg || {};
        var bufferLen = config.bufferLen || 4096;
        var numChannels = config.numChannels || 2;
        this.context = source.context;
        this.node = (this.context.createScriptProcessor ||
                     this.context.createJavaScriptNode).call(this.context,
                     bufferLen, numChannels, numChannels);
        var worker = new Worker(config.workerPath || WORKER_PATH);
        worker.postMessage({
            command: 'init',
            config: {
                sampleRate: this.context.sampleRate,
                numChannels: numChannels
            }
        });
        var recording = false,
          currCallback;

        this.node.onaudioprocess = function (e) {
            if (!recording) return;
            var buffer = [];
            for (var channel = 0; channel < numChannels; channel++) {
                buffer.push(e.inputBuffer.getChannelData(channel));
            }
            worker.postMessage({
                command: 'record',
                buffer: buffer
            });
        }

        this.configure = function (cfg) {
            for (var prop in cfg) {
                if (cfg.hasOwnProperty(prop)) {
                    config[prop] = cfg[prop];
                }
            }
        }

        this.record = function () {
            recording = true;
        }

        this.stop = function () {
            recording = false;
        }

        this.clear = function () {
            worker.postMessage({ command: 'clear' });
        }

        this.getBuffer = function (cb) {
            currCallback = cb || config.callback;
            worker.postMessage({ command: 'getBuffer' })
        }

        this.exportWAV = function (cb, type, testAudio) {
            currCallback = cb || config.callback;
            type = type || config.type || 'audio/wav';
            testAudio = testAudio || false;
            if (!currCallback) throw new Error('Callback not set');
            worker.postMessage({
                command: 'exportWAV',
                type: type,
                testAudio: testAudio
            });
        }

        //Mp3 conversion
        worker.onmessage = function (e) {
            var blob = e.data[0];
            var testAudio = e.data[1];
            //console.log("the blob " +  blob + " " + blob.size + " " + blob.type);

            var arrayBuffer;
            var fileReader = new FileReader();
            g_seqMgr.mp3FormData = new FormData($("form#audioForm", g_seqMgr.contentDoc)[0]);

            fileReader.onload = function () {
                arrayBuffer = this.result;
                var buffer = new Uint8Array(arrayBuffer),
                data = parseWav(buffer);

                console.log(data);
                console.log("Converting to Mp3");
                //log.innerHTML += "\n" + "Converting to Mp3.";

                encoderWorker.postMessage({
                    cmd: 'init', config: {
                        mode: 3,
                        channels: 1,
                        samplerate: data.sampleRate,
                        bitrate: data.bitsPerSample
                    }
                });

                encoderWorker.postMessage({ cmd: 'encode', buf: Uint8ArrayToFloat32Array(data.samples) });
                encoderWorker.postMessage({ cmd: 'finish' });
                encoderWorker.onmessage = function (e, formData) {
                    if (e.data.cmd == 'data') {

                        console.log("Done converting to Mp3");
                        //log.innerHTML += "\n" + "Done converting to Mp3";
                        //log.innerHTML = "Done converting to Mp3.";

                        /*var audio = new Audio();
                        audio.src = 'data:audio/mp3;base64,'+encode64(e.data.buf);
                        audio.play();*/

                        //console.log ("The Mp3 data " + e.data.buf);

                        var mp3Blob = new Blob([new Uint8Array(e.data.buf)], { type: 'audio/mp3' });
                        if (testAudio == false) {
                            uploadAudio(mp3Blob);
                        }
                        else {
                            var url = 'data:audio/mp3;base64,' + encode64(e.data.buf);
                            var au = document.createElement('audio');
                            au.controls = true;
                            au.src = url;
                            if (window.parent.$('#testAudioPlayer', window.parent.g_frameMgr.testModeFrame.frames[0].document).children().length > 0) {
                                window.parent.$('#testAudioPlayer', window.parent.g_frameMgr.testModeFrame.frames[0].document).children().remove();
                                window.parent.$('#testAudioPlayer', window.parent.g_frameMgr.testModeFrame.frames[0].document).append(au);
                            }
                            else {
                                window.parent.$('#testAudioPlayer', window.parent.g_frameMgr.testModeFrame.frames[0].document).append(au);
                            }
                            window.parent.$('#toeflSpinner', window.parent.g_frameMgr.testModeFrame.frames[0].document).hide()
                            window.parent.$('#startTestRecordingButton', window.parent.g_frameMgr.testModeFrame.frames[0].document).show()
                        }
                    }
                };
            };

            fileReader.readAsArrayBuffer(blob);

            currCallback(blob);
        }


        function encode64(buffer) {
            var binary = '',
                bytes = new Uint8Array(buffer),
                len = bytes.byteLength;

            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return window.btoa(binary);
        }

        function parseWav(wav) {
            function readInt(i, bytes) {
                var ret = 0,
                    shft = 0;

                while (bytes) {
                    ret += wav[i] << shft;
                    shft += 8;
                    i++;
                    bytes--;
                }
                return ret;
            }
            if (readInt(20, 2) != 1) throw 'Invalid compression code, not PCM';
            if (readInt(22, 2) != 1) throw 'Invalid number of channels, not 1';
            return {
                sampleRate: readInt(24, 4),
                bitsPerSample: readInt(34, 2),
                samples: wav.subarray(44)
            };
        }

        function Uint8ArrayToFloat32Array(u8a) {
            var f32Buffer = new Float32Array(u8a.length);
            for (var i = 0; i < u8a.length; i++) {
                var value = u8a[i << 1] + (u8a[(i << 1) + 1] << 8);
                if (value >= 0x8000) value |= ~0x7FFF;
                f32Buffer[i] = value / 0x8000;
            }
            return f32Buffer;
        }

        function uploadAudio(mp3Data) {
            var reader = new FileReader();
            reader.onload = function (event) {
                var formData = g_seqMgr.mp3FormData
                var mp3Name = encodeURIComponent('audio_recording_' + new Date().getTime() + '.mp3');
                console.log("mp3name = " + mp3Name);
                formData.append('file', event.target.result);
                productID = formData.get("productID");
                historyDBID = formData.get("historyDBID");
                sequenceID = formData.get("sequenceID");
                contentItemID = formData.get("contentItemID");
                position = formData.get("position");
                // First step in storing audio files locally for backup to then send in the case of AJAX failure.
                //try {
                //    if (typeof (Storage) !== "undefined") {
                //        localStorage.setItem(productID + "." + historyDBID + "." + sequenceID + "." + contentItemID + "." + position + "." + "audio", event.target.result);
                //    } else {
                //        throw "Sorry! Your browser does not support web storage. We won't have a backup of your audio file if for some reason you lose connection during the transmission  of your recording."
                //    }
                //} catch (e) {
                //    alert(e);
                //}

                submitAudio(formData)
            };
            reader.readAsDataURL(mp3Data);
        }

        function submitAudio(formData) {
            var url = g_seqMgr.ukAPIProductionURL;
                $.ajax({
                    url: url,
                    type: 'POST',
                    data: formData,
                    async: false,
                    success: function (resp) {
                        console.log(resp)
                    },
                    failure: function (resp) {
                        console.log(resp)
                    },
                    cache: false,
                    contentType: false,
                    processData: false
                }).done(function (data) {
                    console.log("Audio File Submitted");
                    g_seqMgr.audioProcessing = false;
                    if (g_seqMgr.quitButton.css('display') === 'none') {
                        g_seqMgr.quitButton.show();
                        g_seqMgr.suspendButton.show();
                    }
                    //log.innerHTML += "\n" + data;
                });
        }

        source.connect(this.node);
        this.node.connect(this.context.destination);    //this should not be necessary
    };

    /*Recorder.forceDownload = function(blob, filename){
      console.log("Force download");
      var url = (window.URL || window.webkitURL).createObjectURL(blob);
      var link = window.document.createElement('a');
      link.href = url;
      link.download = filename || 'output.wav';
      var click = document.createEvent("Event");
      click.initEvent("click", true, true);
      link.dispatchEvent(click);
    }*/

    window.Recorder = Recorder;

})(window);
