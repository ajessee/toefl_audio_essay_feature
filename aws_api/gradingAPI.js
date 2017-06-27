'use strict';

//create an object to store responses from Jasper API
var responseObject = {};

//create global variables for the path and body of the rescore request. (Scope issues)
var pathForReScore = null;
var bodyForRescore = null;

//processStudent info is function that validates data and then runs Jasper API requests
//for updating scores for audio questions 1-6 and essay questions 1-2. Is passed a success handler and a failure handler to deal with both scenarios.
var processStudentInfo = (studentInfo, index, array, successHandler, failureHandler) => {

  try{
  //data validation to ensure that correct data type is being recorded to DB
  console.log("Validating data...");
  if (!Number.isInteger(studentInfo.productID)) throw "Product ID must be an integer";
  if (!Number.isInteger(studentInfo.historyDBID)) throw "History DB ID must be an integer";
  if (!Number.isInteger(studentInfo.sequenceID)) throw "Sequence ID must be an integer";
  if (!Number.isInteger(studentInfo.contentItemID)) throw "Content Item ID must be an integer";
  if (!Number.isInteger(studentInfo.position)) throw "Postion must be an integer";
  if (Number.isNaN(Number.parseFloat(studentInfo.score))) throw "Score must be a integer or decimal";
  if (typeof studentInfo.comments !== "string") throw "Comments must be a string";
  console.log("No validation errors!");

  //create URL path for score update request using data from grades object
  var pathForScoreUpdate = "/api/sequence/" + studentInfo.sequenceID + "/" +
  studentInfo.contentItemID + "/" + studentInfo.position + "/update_score";

  //create URL path for rescoring entire test. This is last request made to DB. Assigning value to the global variable that was declared at top with null value.
  pathForReScore = "/api/sequence/" + studentInfo.sequenceID + "/score";

  //body for the score update request containing score, productId, historyDb, and comments
  var bodyForScoreUpdate = {
    score: studentInfo.score,
    productId: studentInfo.productID,
    historyDb: studentInfo.historyDBID,
    comments: studentInfo.comments
  };

  //body for the test rescore request containing the productId and the historyDb. Assigning value to the global variable that was declared at top with null value.
  bodyForRescore = {
    productId: studentInfo.productID,
    historyDb: studentInfo.historyDBID,
  };

  //Run scoreUpdateRequest, which returns a promise. Promise will resolve with body of Jasper API response, which we then pass to our successHandler with the content item ID and index of the element in the grades array. If the promise rejects, we pass the error, content item ID, and index to failureHandler.
  var itMessedUp = false;
    scoreUpdateRequest(pathForScoreUpdate, bodyForScoreUpdate)
      .then(function(body){
        console.log("Score update for question: " + (index+1) + " COMPLETE. Response body from Jasper API is: " + body.toString());
        successHandler(body, studentInfo.contentItemID, index);
      }).catch(function(err){
        console.log("Score update for question: " + (index+1) + " FAILED. Response body from Jasper API is: " + err.toString());
        failureHandler(err, studentInfo.contentItemID, index);
        throw "Server Error!";
    })
  }
  catch(error){
    console.log("catch");
    throw error;
  }
};

//http POST request to the Jasper API to update the question scores with the grades provided in the grade object
var scoreUpdateRequest = (path, requestBody) => {

  return new Promise((resolve, reject) => {

    var http = require("http");
    const requestContents = JSON.stringify(requestBody, null, 2);

    var options = {
      "method": "POST",
      "hostname": "jasper.kaptest.com",
      "port": null,
      "path": path,
      "headers": {
        "content-type": "application/json",
        "cache-control": "no-cache",
        // this is the key, disables chunked transfer encoding
        'Content-Length': Buffer.byteLength(requestContents)
      }
    };

    var req = http.request(options, function (res) {

      var chunks = [];

      res.on("data", function (chunk) {
        chunks.push(chunk);
      });

      res.on("end", function () {
        var body = Buffer.concat(chunks);
        if(res.statusCode === 400){
          console.log("Status code: " + res.statusCode);
          console.log("Score update failed. Promise rejected.");
          reject(body);
          return;
        }
        else {
          console.log("Status code: " + res.statusCode);
          console.log("Score update request done. Promise resolved.");
          resolve(body);
        }
      });
    });

    req.write(requestContents);
    req.on('error', (err) => {
      console.log("Request failed. Promise rejected.");
      console.log(err.toString());
      reject(err)
    });
    req.end();
  })
};

//http POST request to the Jasper API to rescore the test once all the scores have been updated with the scores from the grade object
var rescoreRequest = (path, requestBody) => {

  return new Promise((resolve,reject) => {

    var http = require("http");
    const requestContents = JSON.stringify(requestBody, null, 2);

    var options = {
      "method": "POST",
      "hostname": "jasper.kaptest.com",
      "port": null,
      "path": path,
      "headers": {
        "content-type": "application/json",
        "cache-control": "no-cache",
        'Content-Length': Buffer.byteLength(requestContents)
      }
    };

    var req = http.request(options, function (res) {
      var chunks = [];

      res.on("data", function (chunk) {
        chunks.push(chunk);
      });

      res.on("end", function () {
        var body = Buffer.concat(chunks);
        if(res.statusCode === 400){
          console.log("Status code: " + res.statusCode);
          console.log("Score update failed. Promise rejected.");
          reject(body);
          return;
        }
        else {
          console.log("Status code: " + res.statusCode);
          console.log("Score update request done. Promise resolved.");
          resolve(body);
        }
      });
    });

    req.write(requestContents);
    req.on('error', (err) => {
      console.log("Request failed. Promise rejected.");
      console.log(err.toString());
      reject(err);
    });
    req.end();
  })
};

//main Lambda function. Recieves event, which is body of POST request to API.
exports.myHandler = (event, context, callback) => {

    //take event, turn it into an array of grade information
    var gradesObj = JSON.parse(event.body);
    var gradesArray = gradesObj["grades"].map(function(grade){
      return grade;
    });

    console.log('Received event:', JSON.stringify(event, null, 2));
    console.log('Grades Array:', gradesArray);

    //success JSON response to UK API
    var returnInfoSuccess = (responseObject) => {
      return {
      "statusCode": 200,
      "headers": { "Content-Type": "application/json" },
      "body": JSON.stringify(responseObject)
      }
    };

    //failure JSON response to UK API
    var returnInfoFailure = (error) => {
      var message = null;
      console.log(typeof error);
      if (typeof error === 'object'){
        message = JSON.stringify(error)
      }
      else {
        message = error
      }
      console.log(message);
      return {
      "statusCode": 400 ,
      "headers": { "Content-Type": "application/json" },
      "body": message
      }
    };

    //Success handler. Writes response body of successful Jasper API call into the response object, tests if we have made calls for all existing grades in the grades array, and if so, makes final Jasper API call to rescore the entire test.
    const successHandler = (successResponseBody, contentItemID, index) => {
      responseObject["Question " + (index+1) + " | Content Item Id " + contentItemID] = "Status: " + successResponseBody.toString().replace(/[\\"]/g, "")

      if (Object.keys(responseObject).length === gradesArray.length) {
        console.log("We're done with updating scores, time to rescore the whole test.")
        rescoreRequest(pathForReScore, bodyForRescore)
        .then((body) => {
          console.log("All done, sending response object back to UK API")
          responseObject["Rescore of Test"] = "Status: "  + body.toString().replace(/[\\"]/g, "");
          callback(null, returnInfoSuccess(responseObject));
          responseObject = {};
        }).catch(function(err){
          console.log(err.toString());
          throw "Rescore request failed.";
        })
      }
      else {
        console.log("Grades Array Length = " + gradesArray.length);
        console.log("Response Object Length = " + Object.keys(responseObject).length);
      }
    };

    //Failure handler. Takes error, content item ID, and index and sends failure response to UK API.
    const failureHandler = (error, contentItemID, index) => {
      callback(null, returnInfoFailure("Question " + (index+1) + " | Content Item " + contentItemID + " Status: " + error.toString()));
      responseObject = {};
    };

    //Process the student info for each element of the recieved grades array, and handles successful and failed calls to Jasper API. Also catches any validation errors thrown.
    try {
      gradesArray.forEach((element, count,array) => processStudentInfo(element, count,array, successHandler, failureHandler));
    }
    catch(error){
      console.log("Oops...");
      console.log(error);
      callback(null, returnInfoFailure(error));
    }
  };
