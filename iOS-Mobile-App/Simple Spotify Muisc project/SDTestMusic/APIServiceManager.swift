//
//  APIServiceManager.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation

class APIServiceManager: NSObject {
    static let sharedManager = APIServiceManager()
    
    var showImages: Bool = true
    
    func fetchArtist(name: String?, completion: (artists: [Artist]) -> Void, failure FailureBlock: (error: NSError) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            let artistName = name
            
            let urlString = "https://api.spotify.com/v1/search?q=\(artistName!)&type=artist"
            
            if let url = NSURL(string: urlString) {
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                    guard let data = data else {
                        let error = NSError(domain: "No Data Returned", code: 0, userInfo: nil)
                        FailureBlock(error: error)
                        return
                    }
                    
                    guard error == nil else {
                        FailureBlock(error: error!)
                        return
                    }
                    
                    do {
                        let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                        let artistArray = Artist.getArtistsWithArray(jsonDict["artists"]!["items"] as! [[String : AnyObject]])
                        //print(jsonDict)
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(artists: artistArray)
                        })
                    }
                    catch let error as NSError {
                        FailureBlock(error: error)
                    }
                })
                task.resume()
            }
        }
    }
    
    func fetchTracksWithArtistID(artistID: String, completion: (tracks: [Track]) -> Void, failure FailureBlock: (error: NSError) -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            let urlString = "https://api.spotify.com/v1/artists/\(artistID)/top-tracks/?country=US"
            
            if let url = NSURL(string: urlString) {
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                    guard let data = data else {
                        let error = NSError(domain: "No Data Returned", code: 0, userInfo: nil)
                        FailureBlock(error: error)
                        return
                    }
                    
                    guard error == nil else {
                        FailureBlock(error: error!)
                        return
                    }
                    
                    do {
                        let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                        let trackArray = Track.getTracksWithArray(jsonDict["tracks"] as! [[String : AnyObject]])
                        //print(jsonDict)
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(tracks: trackArray)
                        })
                    }
                    catch let error as NSError {
                        FailureBlock(error: error)
                    }
                })
                task.resume()
            }
        }
    }
}
