//
//  Track.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/14/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class Track: NSObject {
    var name: String?
    var album: String?
    var artistName: String?
    var duration: Int? = 0
    var popularity: Int? = 0
    var trackNumber: Int?
    var previewUrl: NSURL?
    var imageUrls: [TrackImage] = []
    
    struct TrackImage {
        var height: Int? = 0
        var width: Int? = 0
        var url: NSURL?
    }
    
    init(dictionary: [String : AnyObject]) {
        let tempAlbum = dictionary["album"] as! NSDictionary
        
        name = dictionary["name"] as? String
        album = tempAlbum["name"] as? String
        
        let artistArr = dictionary["artists"] as? NSArray
        let contentInArtistArr = artistArr![0] as? NSDictionary
        artistName = contentInArtistArr!["name"] as? String
        
        duration = dictionary["duration_ms"] as? Int
        popularity = dictionary["popularity"] as? Int
        trackNumber = dictionary["track_number"] as? Int
        
        let url = dictionary["preview_url"] as? String
        if url != nil
        {
            previewUrl = NSURL(string: url!)
        }
        else
        {
            previewUrl = NSURL(string: "")
        }

        for image in tempAlbum["images"] as! [[String : AnyObject]] {
            let trackImage = TrackImage(height: image["height"] as? Int, width: image["width"] as? Int, url: NSURL(string: image["url"] as! String))
            imageUrls.append(trackImage)
        }
    }
}

extension Track {
    // Instance Methos
    func formattedDuration() -> String {
        if let duration = self.duration {
            let hours = ((duration / (1000 * 60 * 60)) % 24)
            let minutes = ((duration / (1000 * 60)) % 60)
            let seconds = ((duration / 1000) % 60)
            
            let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
            let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
            let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            
            return "\(hoursString):\(minutesString):\(secondsString)"
        }
        
        return "00:00:00"
    }
    
    func thumbnailImage(completion: (image: UIImage?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            var image = UIImage(named: "musicImage")
            
            if !self.imageUrls.isEmpty {
                if let url = self.imageUrls[0].url {
                    if let imageData = NSData(contentsOfURL: url) {
                        if let tmpImage = UIImage(data: imageData) {
                            image = tmpImage
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(image: image)
            })
        })
    }
    
    // Class Methods
    class func getTracksWithArray(array: [[String : AnyObject]]) -> [Track] {
        var tmpArray = [Track]()
        for track in array {
            let tmpTrack = Track(dictionary: track)
            tmpArray.append(tmpTrack)
        }
        return tmpArray
    }
    
    class func sortTracksWithArray(array: [Track]) -> [String : AnyObject] {
        var sortedTrackDictionary = [String: [Track]]()
        
        for (_, item) in array.enumerate() {
            let key = item.album!
            if sortedTrackDictionary[key] == nil {
                sortedTrackDictionary[key] = [Track]()
            }
            
            sortedTrackDictionary[key]?.append(item)
        }
        
        let sortedAlbumArray = Array(sortedTrackDictionary.keys).sort()
        
        return ["sortedTracks" : sortedTrackDictionary, "sortedAlbums" : sortedAlbumArray]
    }
}
