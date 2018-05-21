//
//  People.swift
//  NameGame
//
//  Created by James H Layton on 4/24/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

struct Employee {
    
    var id: String?
    var bio: String?
    var type: String?
    var slug: String?
    var jobTitle: String?
    var firstName: String?
    var lastName: String?
    var headshot: HeadShot?
    var socialLinks: NSArray? // TODO: Could contain more than one dictionary, should improve 
    
    init(jsonData: Dictionary<String, Any>) {
        id = jsonData["id"] as? String ?? nil
        bio = jsonData["bio"] as? String ?? nil
        type = jsonData["type"] as? String ?? nil
        slug = jsonData["slug"] as? String ?? nil
        jobTitle = jsonData["jobTitle"] as? String ?? nil
        firstName = jsonData["firstName"] as? String ?? nil
        lastName = jsonData["lastName"] as? String ?? nil
        socialLinks = (jsonData["socialLinks"] as? NSArray ?? nil)!
        
        if let head = jsonData["headshot"] as? Dictionary<String, Any> {
            headshot = HeadShot(jsonData: head)
        }
        else {
            headshot = nil
        }
    }
}

struct HeadShot {
    
    var type: String?
    var mimeType: String?
    var id: String?
    var url: String?
    var alt: String?
    var height: Int
    var width: Int
    
    init(jsonData: Dictionary<String, Any>) {
        type = jsonData["type"] as? String ?? nil
        mimeType = jsonData["mimeType"] as? String ?? nil
        id = jsonData["id"] as? String ?? nil
        url = jsonData["url"] as? String ?? nil
        alt = jsonData["alt"] as? String ?? nil
        height = jsonData["height"] as? Int ?? 0
        width = jsonData["width"] as? Int ?? 0
    }
}
