# TOEFL Audio/Essay Grading Feature

I worked for Kaplan Test Prep's international division as their Content Engineer from January 2016 to April 2017. During that time, my boss asked me to build a new feature into our online test assessment platform. Kaplan's platform is propietary, and since I don't have a way to grant access to this platform for users, I am using this repository to showcase my work.

## Background

TOEFL is an English-language test that is administered on-line by ETS (Educational Testing Services), a nonprofit that focuses on educational assessment. Kaplan Test Prep International (KTPi) has an online test preparation program for TOEFL that is designed to mimic the experience of taking the ETS test. KTPi's online practice tests mirror the same aestetic design and functionality of the ETS tests, so that students get as close to a 'test-like' experience as possible.

The ETS online test has 4 sections - reading, listening, speaking, and writing. The reading and listening sections are comprised of multiple-choice questions and are graded automatically by comparing a student’s submitted answers to a correct answer key. The speaking section records the student's spoken answers and sends the audio file to a teacher to be graded. The essay section does the same for the student's written response.

When KTPi first built their TOEFL test preparation product, they did not build the audio and essay grading functionality into the product. The reading and listening sections were graded automatically, but for the audio and the essay sections, Kaplan provided some basic guidance for students to assess their own work. This clearly was not 'test-like', so eventually they outsourced the creation of a product to a third party vendor called TestDen. TestDen built a web application in Adobe Flash with the missing functionality.

In recent years, Flash’s position as the defacto way to present dynamic content on the web has been supplanted by modern HTML5, CCS3, and Javascript technologies. A combination of our expiring contractual relationship with TestDen and the changing technological landscape led my boss to challenge me to buid an in-house feature to capture student audio and essays and grade them.

## Planning Stage

After doing my inital research, I started planning out the feature. Here is a workflow diagram that I put together to map out how the feature would work:

**JASPER** = Kaplan's web application (Written in C#/.NET) \n
**AWS Essay Grading API** = API I built using Amazon Web Service's Lamba and API Gateway services
**UK API** = API built by our developers in London that handled that routed the student's audio/essay data to a web application they built for teachers to grade the data.

For each question in both the speaking and writing sections, we need to capture the student's response and then attach student/test/question metadata to the response. We then send a POST request with this data to the UK API. The UK API stores the audio/essay response as a file in a AWS S3 bucket.

Once the student completes the test (or quits), we send a final POST request to the UK API to indicate that all the data has been submitted. This triggers the UK API to send all the data to another web application for grading by a teacher.

At this point, a teacher logs in to the grading web app and begins to review the student responses. They grade each question and provide feedback and comments. Once the entire set of questions for that student's test have been graded, the grading web app makes a POST request to the AWS API with the grade data.

The AWS API recieves this grade data, validates that the data is in the correct format, and then makes a series of POST requests back to JASPER in order to write the grades to the database and rescore the test. Once this is complete, a student can log back into JASPER and see their updated grade.

![Workflow](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/workflow_toefl_feature.png)

## Building the feature

### Step 1

For each question in the speaking section of the ETS test, a student is presented with a question prompt. On the next screen, they are given 15 seconds to prepare themselves to respond to the question. Once the 15 second countdown is over, the recording starts and a student has 45 seconds to speak. They can choose to end the recording early, or the recording stops at the end of the 45 seconds.

To recreate this functionality, I first had to get metadata about the student, the test, and the question from JASPER's database. This metadata would serve two purposes - it would uniquely identify the student's responses 

![Recording Screen](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/speaking_screen.png)

In order to capture the student's audio, I used a library called [Recordmp3js](https://github.com/Audior/Recordmp3js "Recordmp3js"). This library makes use of the [WebRTC (Web Real-Time Communications) ](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API "WebRTC (Web Real-Time Communications)") browser technology to capture and stream audio input. 



JASPER uses eXtensible Markup Language (XML) to store test prep assessment content (questions), and then uses EXtensible Stylesheet Language (XSL) to transform the XML document into HyperText Markup Language (HTML) to render what you see on the screen. The first thing I had to do was build a hidden webform into the XSL document to pull in metadata  

