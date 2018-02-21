//
//  AlertViewHelper.swift
//  AutoGuardian
//
//  Created by James on 7/5/17.
//  Copyright © 2017 James. All rights reserved.
//

import UIKit

public class AlertViewManager
{
    public static let shared = AlertViewManager()
    private init(){}
    
    /** Alert view with one ok button and no action **/
    public func presentAlertWith(title: String?, msg: String?, vc: UIViewController)
    {
        let alertView = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alertView, animated: true, completion: nil)
    }
    
    /** Alert view with one ok button and closure **/
    public func presentAlertWithClosure(title: String?, msg: String?, vc: UIViewController, closure: (()->())?)
    {
        let alertView = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            closure!()
        })
        alertView.addAction(okAction)
        vc.present(alertView, animated: true, completion: nil)
    }
    
    /** Alert view with two buttons same closure **/
    public func presentAlertWithTwoClosures(title: String?, msg: String?, vc: UIViewController, cancel: @escaping (()->()), ok: @escaping (()->()))
    {
        let alertView = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: {(action) in
            cancel()
        })
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            ok()
        })
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        vc.present(alertView, animated: true, completion: nil)
    }
    
    /** Alert view with closure for settings **/
    public func presentAlertForSettings(title: String?, msg: String?, vc: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let openAction = UIAlertAction(title: "OPEN SETTINGS", style: UIAlertActionStyle.cancel) {(action) in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
