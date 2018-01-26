//
//  ViewController.swift
//  ImageDownloadTest
//
//  Created by James on 1/23/18.
//  Copyright © 2018 James. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imageUrlString = "https://static.pexels.com/photos/54632/cat-animal-eyes-grey-54632.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the image to imageview
        self.loadImage()
    }

}

extension ViewController {
    
    func loadImage() {
        let url = URL.init(string: self.imageUrlString)
        let session = URLSession.init(configuration: .default)
        
        let getImageData = session.dataTask(with: url!, completionHandler: {(data, response, error) in
            //if there is any error
            if let err = error {
                //displaying the message
                print("Error Occurred: \(err)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                            //displaying the image
                            self.imageView.image = image
                        }
                        
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        })
        
        getImageData.resume()
    }
}

