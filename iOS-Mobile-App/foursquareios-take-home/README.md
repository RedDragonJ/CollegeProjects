# iOS Take Home Interview
Hello! For this portion of the interview, we’d like you to help us implement two bits of functionality.

You may use Swift for any new classes you create, but please use Objective-C for the view controllers themselves. We will review your code for correctness, but we will also consider its design, efficiency, and readability. You should test the code well enough that you think it's correct, but you don't need to include any tests in your submission. You may also assume that the input is well-formed (e.g. JSON is valid, all fields have the correct type, `arriveTime` is always before `leaveTime`).

## Background

Venue Visitors: Merchants may want to know some analytics about who is visiting their venue. We want to show the people who have visited, and the time that their venue is idle. We’d like to build something to show the people at a venue (*sorted by arrival time*) filling in the gaps for open to close.

## Getting Started

We have provided you with input JSON files in the Data directory. You will need to write code to read in this data and convert it to a form consumable by your view controllers. You should read in the data files in each view controller's viewDidLoad method.

Take a look at the screenshot (Visitors) to get a feel for what our UI should look like.

Familiarize yourself with people-here.json:
- Note that the visitors are not sorted in any way.
- For simplification purposes, we’ve chosen to represent time by *seconds since midnight* in integer form.
- Also note that the sample screenshots are taken from a different data set than the one provided, and the solution should match the style but not the exact data.

You will need to write a small algorithm to find idle intervals where no visitor is present at the venue.  *Your solution should include a comment in your code with a brief description of how your algorithm works, a discussion of any trade-offs or assumptions you made in your design, and an analysis of its running time* (hint: you can do better than O(n²), where n is the number of visitors).

## Tips & FAQs
- We aren't looking for gotchas or future proofing. Your solution should solve the problem but does not need to worry about features we haven't asked for (e.g. you don't need to persist any data to disk).
- You are welcome to use any third party libraries you feel comfortable with - just make sure to create a LICENSE file in the root directory listing libraries and relevant license information. You should not need any extra libraries, but we won't penalize you for using one. _Make sure the solution code you send back to us compiles on the latest version of XCode without any additional steps, like downloading cocoapods._
