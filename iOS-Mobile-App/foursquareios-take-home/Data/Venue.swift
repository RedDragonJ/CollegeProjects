//
//  Peaple.swift
//  ios-interview
//
//  Created by James H Layton on 5/3/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

import Foundation

@objc class Visitor: NSObject {
    
    var visitorId: String?
    var visitorName: String?
    var visitorArriveTime: Int = 0
    var visitorLeaveTime: Int = 0
    
    func setData(json: Dictionary<String, Any>) {
        
        visitorId = json["id"] as? String ?? nil
        visitorName = json["name"] as? String ?? nil
        visitorArriveTime = json["arriveTime"] as? Int ?? 0
        visitorLeaveTime = json["leaveTime"] as? Int ?? 0
    }
}

@objc class Venue: NSObject {
    
    var venueId: String?
    var venueName: String?
    var venueOpenTime: Int = 0
    var venueCloseTime: Int = 0
    var venueVisitors: [Visitor]?
    
    func setData(json: Dictionary<String, Any>) {
        
        venueId = json["id"] as? String ?? nil
        venueName = json["name"] as? String ?? nil
        venueOpenTime = json["openTime"] as? Int ?? 0
        venueCloseTime = json["closeTime"] as? Int ?? 0
        
        if let visitors = json["visitors"] as? NSArray {

            venueVisitors = [Visitor]()
            for visitor in visitors { // Loop through the array and create visitor instance then add to the new array
                let visitorDict = visitor as? Dictionary<String, Any>
                let visitorObject = Visitor()
                visitorObject.setData(json: visitorDict!)
                venueVisitors?.append(visitorObject)
            }
            
            venueVisitors = self.sortArray(inputArray: venueVisitors!) // Sort the array of visitors
        }
        else {
            venueVisitors = nil
        }
    }
    
    func sortArray(inputArray: [Visitor]) -> [Visitor] {
        
        let arrayToBeSorted = inputArray as NSArray
        
        //NOTE: SortedArray has O(nlogn) sorting complexity, this is the reason need conver custom array of visitors into nsarray
        let sortedVisitors = arrayToBeSorted.sortedArray(comparator: { (time1, time2) -> ComparisonResult in
            let t1 = time1 as! Visitor
            let t2 = time2 as! Visitor
            
            if t1.visitorArriveTime > t2.visitorArriveTime {
                return ComparisonResult.orderedDescending
            }
            else if t1.visitorArriveTime < t2.visitorArriveTime {
                return ComparisonResult.orderedAscending
            }
            else {
                if t1.visitorLeaveTime > t2.visitorLeaveTime {
                    return ComparisonResult.orderedDescending
                }
                else if t1.visitorLeaveTime > t2.visitorLeaveTime {
                    return ComparisonResult.orderedAscending
                }
                else {
                    return ComparisonResult.orderedAscending
                }
            }
        }) as NSArray // Here cast the [Any] back into nsarray
        
        return sortedVisitors as! [Visitor]
    }
}

@objc class PeopleManager: NSObject {
    
    func getData(completion: @escaping (_ dictData: Dictionary<String, Any>?, _ error: String?) -> Void) {
        if let path = Bundle.main.path(forResource: "people-here", ofType: "json") { // Getting path from bundle
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) // Attempt safely getting data from URL onto memory
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any> // Parse json as dictionary

                if let result = json {
                    if let venueData = result["venue"] as? Dictionary<String, Any> { // Parse the json
                        completion(venueData, nil) // Retunrn the data
                    }
                    else {
                        completion(nil, "ERROR: Failed to get venue data")
                    }
                }
                else {
                    completion(nil, "ERROR: Failed to conver Any to Dictionary<String, Any>")
                }

            } catch let err {
                completion(nil, err.localizedDescription)
            }
        }
        else {
            completion(nil, "ERROR: Failed to get path from Bundle")
        }
    }
}
