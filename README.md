# TOEFL Audio/Essay Grading Feature

I worked for Kaplan Test Prep's international division as their Content Engineer from January 2016 to April 2017. During that time, my boss asked me to build a new feature into our online test assessment platform. Kaplan's platform is proprietary, and since I don't have a way to grant access to this platform for users, I am using this repository to showcase my work.

## Background

TOEFL is an English-language test that is administered on-line by ETS (Educational Testing Services), a nonprofit that focuses on educational assessment. Kaplan Test Prep International (KTPi) has an online test preparation program for TOEFL that is designed to mimic the experience of taking the ETS test. KTPi's online practice tests mirror the same aesthetic design and functionality of the ETS tests, so that students get as close to a “test-like” experience as possible.

The ETS online test has 4 sections - reading, listening, speaking, and writing. The reading and listening sections are comprised of multiple-choice questions and are graded automatically by comparing a student’s submitted answers to a correct answer key. The speaking section records the student's spoken answers and sends the audio file to a teacher to be graded. The essay section does the same for the student's written response.

When KTPi first built their TOEFL test preparation product, they did not build the audio and essay grading functionality into the product. The reading and listening sections were graded automatically, but for the audio and the essay sections, Kaplan provided some basic guidance for students to assess their own work. This clearly was not “test-like”, so eventually they outsourced the creation of a product to a third party vendor called TestDen. TestDen built a web application in Adobe Flash with the missing functionality.

In recent years, Flash’s position as the defacto way to present dynamic content on the web has been supplanted by modern HTML5, CCS3, and Javascript technologies. A combination of our expiring contractual relationship with TestDen and the changing technological landscape led my boss to challenge me to build an in-house feature to capture student audio and essays and grade them.

## The way it works

Here is a flowchart that I put together to show how the feature works:

![Workflow](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/workflow_toefl_feature.png)

A couple notes to interpret this flowchart - **JASPER** is Kaplan's legacy web application that is written in C#/.NET. It has an API that you can call to write data to the production database. However, it is unsecured, which is why I built the secured **AWS Gateway API** using Amazon Web Service's Lamba and API Gateway services to validate the data and then make multiple calls to the Jasper API. **UK API** is an API built by our developers in London that routed the student's audio/essay data to Kaplan’s AWS S3 bucket and to a web application (The **UK Grading Portal**) they built for teachers to grade the data. 

For each question in both the speaking and writing sections, we capture the student's response and then attach student/test/question metadata to the response. We send a POST request with this data to the UK API. The UK API stores the audio/essay response as a file in a AWS S3 bucket.

Once the student completes the test (or quits), we send a final POST request to the UK API to indicate that all the data has been submitted. This triggers the UK API to send all the data to the UK grading portal for grading by a teacher.

At this point, a teacher logs in to the grading portal and begins to review the student responses. They grade each question and provide feedback and comments. Once the entire set of questions for that student's test have been graded, the grading portal makes a POST request to the AWS Gateway API with the grade data.

The AWS Gateway API receives this grade data, validates that the data is in the correct format, and then makes a series of POST requests back to Jasper in order to write the grades to the database and rescore the test. Once this is complete, a student can log back into Jasper and see their updated grade.

## A deep dive into the feature

### Steps 1 - 6

For each question in the speaking section, a student is presented with a question prompt. On the next screen, they are given 15 seconds to prepare themselves to respond to the question. Once the 15 second countdown is over, the recording starts and a student has 45 seconds to speak. They can choose to end the recording early, or the recording stops at the end of the 45 seconds.

Here is what the student sees while recording an audio response:

![Audio Screen](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/speaking_screen.png)

In order to capture and send the student responses to the UK API, I first had to get metadata about the student, the test, and the question from Jasper's database. This metadata would uniquely identify the student's responses and serve as the filename for the audio and essay files. It would also be used to write the grades and comments back to the Jasper production database. 

I used parameters in the XSL stylesheet to import this metadata, and then I attached those parameters to a [XML form](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/xsl/IP_interactionControls.xsl#L102 "XML form") that I built into the stylesheet. For metadata that lived in the Javascript window object, I dynamically attached that metadata on [window load](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/xsl/IP_interactionControls.xsl#L188 "window load").

When a student’s 15 second preparation time is over, we start recording the student’s audio response using a library called [Recordmp3js](https://github.com/Audior/Recordmp3js "Recordmp3js"). This library makes use of the [WebRTC (Web Real-Time Communications) ](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API "WebRTC (Web Real-Time Communications)") browser technology to capture and stream audio input. 

Once the student runs out of time to record their response, or they click the “Stop Recording” button, we stop the recording and initiate the POST request for the current audio question. We use JQuery’s AJAX functionality to make this request. The stop recording function call triggers a number of processes for Recordmp3js to record a WAV file and convert it to an MP3 file in the browser. I built the [AJAX POST request](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/javascript/recordmp3.js#L217 "AJAX POST request") into one of the Recordmp3js library’s Javascript files.

We make the POST request to the UK API, which sends back a response indicating whether the request was successful or not. If it was, the response contains the URL of where the audio file was saved in Kaplan’s AWS S3 bucket. 

We repeat this process for each of the 6 speaking questions in the speaking section, and then move on to the writing section. This is what a student sees when they are writing an essay:

![Essay Screen](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/essay_screen.png)

We do pretty much the exact same thing for an essay, but instead of recording audio, we just grab the text the student has written into the form when the student hits  [“Next”](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/javascript/toeflAudioEssayCapture.js#L3 "Next") (for the first essay question) or [“Quit”](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/javascript/toeflAudioEssayCapture.js#L98 "Quit") (for the second essay question). 

Once a student hits “Quit”, either upon completion of the test, the expiration of time, or at any other point, we send a final POST request to indicate to the UK API that the student is done with the test. The UK API then gathers all the data they have received for the student taking this test (determined by the metadata), and sends it along to the UK grading portal for grading.

### Step 7

The teachers log in to the UK grading portal and are greeted by this screen:

![Grading Portal](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/grading_portal_screen.png)

Here, they can “claim” a question to grade it. Here is the screen they see if they “claim” an speaking question:

![Grading Portal Speaking](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/review_audio_grading_screen.png)

As you can see, the question prompt is provided as well as a link to the AWS S3 bucket so that the teacher can listen to the student’s response. There are fields for the teacher to grade the response and provide any comments. This is similar to what the teacher would see for an essay question, except that they would see the student's written response instead of an audio file.

Once all the speaking and writing questions for that student for that test are graded, the UK grading portal will send a POST request to the AWS Gateway API with a JSON payload with a grades object that contains each question’s metadata, grades, and comments.

### Step 8

The AWS Gateway API receives this grade object in the POST request, and begins by [validating the data](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/aws_api/gradingAPI.js#L14 "validating the data"). Once that is done, for each question that data has been provided for, the Lambda function begins to [build](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/aws_api/gradingAPI.js#L26 "build") the Jasper API URL and HTTP POST request payload to write the grades and comments to the Jasper production database. 

Once that is done, it [sends](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/aws_api/gradingAPI.js#L66 "sends")  the POST requests for each question to update the score and write the comments. After it has gotten a successful response for each request, it makes one final [POST request](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/aws_api/gradingAPI.js#L120 "POST request") to have Jasper rescore the entire test so that the student can see their grades and comments.

### Step 9

Once the test has been rescored, a student can log into their Kaplan account and visit the test review mode, which will show their updated scores:

![Jasper Review Screen](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/review_score_screen.png)

When the student clicks on the link for an speaking question they responded to, they will see a link to the AWS S3 bucket to review their audio response, as well as any comments provided by the teacher who graded the question:

![Speaking Question Review Screen](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/review_audio_screen.png)

When the student clicks on the link for a writing question they responded to, they will see their essay text as well as any comments provided by the teacher who graded the question:

![Writing Question Review Screen](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/review_essay_screen.png)

