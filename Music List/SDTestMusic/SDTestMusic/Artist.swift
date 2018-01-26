//
//  Artist.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/14/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class Artist: NSObject {
    var name: String?
    var ID: String?
    var followers: Int? = 0
    var popularity: Int? = 0
    var imageUrls: [ArtistImage] = []
    
    struct ArtistImage {
        var height: Int? = 0
        var width: Int? = 0
        var url: NSURL?
    }
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary["name"] as? String
        ID = dictionary["id"] as? String
        popularity = dictionary["popularity"] as? Int
        followers = dictionary["followers"] as? Int
        
        for image in dictionary["images"] as! [[String : AnyObject]] {
            let artistImage = ArtistImage(height: image["height"] as? Int, width: image["width"] as? Int, url: NSURL(string: image["url"] as! String))
            imageUrls.append(artistImage)
        }
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
    
    class func getArtistsWithArray(array: [[String : AnyObject]]) -> [Artist] {
        var tmpArray = [Artist]()
        for artist in array {
            let tmpArtist = Artist(dictionary: artist)
            tmpArray.append(tmpArtist)
        }
        return tmpArray
    }
}
