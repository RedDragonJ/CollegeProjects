//
//  WeatherBaseController.swift
//  WeatherLoc
//
//  Created by James H Layton on 5/12/17.
//  Copyright © 2017 james. All rights reserved.
//

import UIKit

class WeatherBaseController: UIViewController
/**
 * This is the base UIViewController for other UIViewController
 * WeatherBaseController contains some methods for easy access for other UIViewController
 */
{
    var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        print("Base View Controller")
    }
    
    //MARK: - Alerts
    func ShowNormalAlertView (inputController: UIViewController, warningType: String, msg: String) //Alert View with no action
    {
        let alert = UIAlertController(title: warningType, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        inputController.present(alert, animated: true, completion: nil)
    }
    
    func ShowQuiAppAlertView (inputController: UIViewController, warningType: String, msg: String) //Alert view with one actions
    {
        let alert = UIAlertController(title: warningType, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.cancel, handler: { UIAlertAction in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            Thread.sleep(forTimeInterval: 2.0)
            exit(0)
        }))
        inputController.present(alert, animated: true, completion: nil)
    }
    
    func ShowActivityIndicator () //Show activity indicator
    {
        self.HideActivityIndicator() //Double check and make sure previous activity indicator is off
        
        self.activityView = UIActivityIndicatorView()
        self.activityView?.frame = CGRect.init(x:self.view.frame.width/2-20, y: self.view.frame.height/4, width: 40.0, height: 40.0)
        self.activityView?.hidesWhenStopped = true
        self.activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(self.activityView!)
        self.activityView?.startAnimating()
    }
    
    func HideActivityIndicator () //Hide/ Stop activity indicator
    {
        self.activityView?.stopAnimating()
        self.activityView?.removeFromSuperview()
    }
}




