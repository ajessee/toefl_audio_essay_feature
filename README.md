# toefl_audio_essay_feature

I built a feature into Kaplan Test Prep's online TOEFL test to be able to record student audio, record submitted essays, and then those files to teachers to be graded. I also built an API to recieve the grade data and then write that back to the web application's database.

The why:

TOEFL is an English-language test that is administered on-line by ETS (Educational Testing Services), a nonprofit that focuses on educational assessment. Kaplan Test Prep International (KTPi) has been providing test preparation for TOEFL and is committed to making the test prep as ‘test-like’ as possible. 

The test has 4 sections - reading, listening, speaking, and writing. The first two sections are made up of questions that have set correct answers, and can therefore be graded automatically by comparing a student’s submitted answers to a correct answer key.

However, the speaking and writing sections can’t be graded by an automated process. They need to be graded by teachers who can provide a subjective score, as well as any comments they may have. In the past, KTPi has outsourced the creation of a ‘test-like’ application to a third party vendor called TestDen. They built a web application in Adobe Flash that included this functionality.

In recent years, Flash’s position as the defacto way to present dynamic content on the web has been supplanted by modern HTML5, CCS3, and Javascript technologies. A combination of our expiring contractual relationship with TestDen, as well as changing technologies, has led KTPi to develop an in-house feature to capture student audio and essays and grade them.

The how:

![Workflow](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/workflow_toefl_feature.svg)