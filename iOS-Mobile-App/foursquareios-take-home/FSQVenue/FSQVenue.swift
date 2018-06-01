//
//  PeopleHandler.swift
//  iosinterview
//
//  Created by James H Layton on 5/4/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

import Foundation

@objc class FSQVenue: NSObject {
    
    func getTime(firstTime: Int, secondTime: Int) -> String {
        
        let firstHrs = firstTime / 3600
        let firstMins = (firstTime % 3600) / 60
        var secondHrs = secondTime / 3600
        let secondMins = (secondTime % 3600) / 60
        
        var firstMinsStr = String()
        var secondMinsStr = String()
        
        if firstMins < 10 {
            firstMinsStr = String(format: "%i0", firstMins)
        }
        else {
            firstMinsStr = String(firstMins)
        }
        
        if secondMins < 10 {
            secondMinsStr = String(format: "%i0", secondMins)
        }
        else {
            secondMinsStr = String(secondMins)
        }
        
        if secondHrs > 24 {
            secondHrs = secondHrs % 24
        }
        
        return String(format: "%i:%@ - %i:%@", firstHrs, firstMinsStr, secondHrs, secondMinsStr)
    }
    
    func findNoVisit(openTime: Int, closeTime: Int, inputArray: [Visitor]) -> [Visitor] {
        
        var newVisitors = [Visitor]()
        var lastTime: Int = 0
        var count = 0
        var latestLeaveTime: Int = 0
        
        // NOTE: Here i loop through the array once and do some if statement checking
        // The complexity in this case is O(n) which much better than O(n**2)
        while count < inputArray.count {
            
            let visitor = inputArray[count]
            
            if lastTime == 0 { // First time into array
                if (visitor.visitorArriveTime - openTime) > 0 { // Check if theres gap between current visitor arrival and open time
                    let noVisitor = Visitor()
                    noVisitor.visitorName = "No Visitors"
                    noVisitor.visitorArriveTime = openTime
                    noVisitor.visitorLeaveTime = visitor.visitorArriveTime
                    newVisitors.append(noVisitor)
                }
                lastTime = visitor.visitorLeaveTime
                newVisitors.append(visitor)
            }
            else {
                if (visitor.visitorArriveTime - lastTime) > 0 { // Check if theres gap between current visitor arrival and last visitor leave
                    let noVisitor = Visitor()
                    noVisitor.visitorName = "No Visitors"
                    noVisitor.visitorArriveTime = lastTime
                    noVisitor.visitorLeaveTime = visitor.visitorArriveTime
                    newVisitors.append(noVisitor)
                }
                
                if lastTime < visitor.visitorLeaveTime {
                    lastTime = visitor.visitorLeaveTime
                }
                
//                lastTime = visitor.visitorLeaveTime
                newVisitors.append(visitor)
            }
            
            let lastCount = count + 1
            if lastCount == inputArray.count { // Reach last elment in the array
                if lastTime != closeTime {
                    let noVisitor = Visitor()
                    noVisitor.visitorName = "No Visitors"
                    noVisitor.visitorArriveTime = lastTime
                    noVisitor.visitorLeaveTime = closeTime
                    newVisitors.append(noVisitor)
                }
            }
            count += 1
        }
        
        return newVisitors
    }
}
