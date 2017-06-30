# TOEFL Audio/Essay Grading Feature

I worked for Kaplan Test Prep's international division as their Content Engineer from January 2016 to April 2017. During that time, my boss asked me to build a new feature into our online test assessment platform. Kaplan's platform is propietary, and since I don't have a way to grant access to this platform for users, I am using this repository to showcase my work.

## Background

TOEFL is an English-language test that is administered on-line by ETS (Educational Testing Services), a nonprofit that focuses on educational assessment. Kaplan Test Prep International (KTPi) has an online test preparation program for TOEFL that is designed to mimic the experience of taking the ETS test. KTPi's online practice tests mirror the same aestetic design and functionality of the ETS tests, so that students get as close to a 'test-like' experience as possible.

The ETS online test has 4 sections - reading, listening, speaking, and writing. The reading and listening sections are comprised of multiple-choice questions and are graded automatically by comparing a student’s submitted answers to a correct answer key. The speaking section records the student's spoken answers and sends the audio file to a teacher to be graded. The essay section does the same for the student's written response.

When KTPi first built their TOEFL test preparation product, they did not build the audio and essay grading functionality into the product. The reading and listening sections were graded automatically, but for the audio and the essay sections, Kaplan provided some basic guidance for students to assess their own work. This clearly was not 'test-like', so eventually they outsourced the creation of a product to a third party vendor called TestDen. TestDen built a web application in Adobe Flash with the missing functionality.

In recent years, Flash’s position as the defacto way to present dynamic content on the web has been supplanted by modern HTML5, CCS3, and Javascript technologies. A combination of our expiring contractual relationship with TestDen and the changing technological landscape led my boss to challenge me to buid an in-house feature to capture student audio and essays and grade them.

## Planning Stage

After doing my inital research, I started planning out the feature. Here is a workflow diagram that I put together to map out how the feature would work:

![Workflow](https://github.com/ajessee/toefl_audio_essay_feature/blob/master/images/workflow_toefl_feature.png)


I built a feature into Kaplan Test Prep's online TOEFL test to be able to record student audio, record submitted essays, and then those files to teachers to be graded. I also built an API to recieve the grade data and then write that back to the web application's database.


The how:

