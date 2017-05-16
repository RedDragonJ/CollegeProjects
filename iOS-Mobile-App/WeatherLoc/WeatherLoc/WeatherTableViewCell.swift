//
//  WeatherTableViewCell.swift
//  WeatherLoc
//
//  Created by James H Layton on 5/15/17.
//  Copyright © 2017 james. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableViewCell: UITableViewCell
/**
 * This is a custom UITableViewCell for custimized cell
 * The information to be displayed are more complicate and this is the reason to create this custom cell
 */
{
    
    static let cellID = "WeatherTableViewCell"
    
    @IBOutlet weak var cellSecondView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tempF: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    let apiHelper = APIManager.sharedManager
    
    var imageURL: String?
    
    override func awakeFromNib() { //Awake the custom cell from nib and set up
        super.awakeFromNib()
        
        self.cellSecondView.layer.masksToBounds = true
        self.cellSecondView.layer.cornerRadius = 10
        self.cellSecondView.clipsToBounds = true
        
        self.backgroundColor = UIColor.clear
        self.cellSecondView.backgroundColor = UIColor.init(red: 255.0/255, green: 250.0/255, blue: 205.0/255, alpha: 1.0)
    
        self.weatherImageView.layer.masksToBounds = true
        self.weatherImageView.layer.cornerRadius = self.weatherImageView.frame.size.height/2
        self.weatherImageView.clipsToBounds = true
    }
    
    //MARK: - Custom cell methods
    class func cellName() -> String {
        return cellID
    }
    
    class func cellIdentifier() -> String {
        return cellID
    }
    
    class func cellHeight() -> CGFloat {
        return 150
    }
    
    func SetImage (imageURLString: String) //Set the custom image url and call to get image from website
    {
        self.imageURL = imageURLString
        self.GetTableViewCellImage()
    }
}

//MARK: - Private methods
private extension WeatherTableViewCell {
    func GetTableViewCellImage () //Download image from website
    {
        self.apiHelper.DownloadImageData(urlString: self.imageURL!, completion: {(data) in
            self.weatherImageView.image = UIImage.init(data: data!)
        })
    }
}








