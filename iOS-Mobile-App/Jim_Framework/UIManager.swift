//
//  UIHelper.swift
//  AutoGuardian
//
//  Created by James on 8/14/17.
//  Copyright © 2017 James. All rights reserved.
//

import UIKit

public class UIManager
{
    public static let shared = UIManager()
    private init() {}
}

//MARK: - Main UI
public extension UIManager
{
    /** Change the background color of view controller **/
    public func updateBackgroundWith(vc: UIViewController?, color: UIColor)
    {
        guard let controller = vc else {
            print("ERROR: The ViewController does not exist")
            return
        }
        controller.view.backgroundColor = color
    }
    
    /** Change the background color of a view **/
    public func updateBackgroundWith(view: UIView, color: UIColor)
    {
        view.backgroundColor = color
    }
    
    /** Add background image to UIView **/
    public func addBackgroundImageTo(view: UIView, image: UIImage)
    {
        let imageView = UIImageView.init(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    /** Add background image UIViewController **/
    public func addBackgroundImageTo(vc: UIViewController?, image: UIImage)
    {
        guard let controller = vc else {
            print("ERROR: The ViewController does not exist")
            return
        }
        let imageView = UIImageView.init(frame: UIScreen.main.bounds)
        imageView.image = image
        controller.view.addSubview(imageView)
        controller.view.sendSubview(toBack: imageView)
    }
}

//MARK: - Status Bar
public extension UIManager
{
    /**In order to use statusBarWithDefaultStyle and statusBarWithLightContentStyle, add
     
     View controller-based status bar appearance - NO
     
     inside plist file
     **/
    public func updateStatusBarWithDefault()
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    public func updateStatusBarWithLightContent()
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    /** Change status bar color **/
    public func updateStatusBarWith(color: UIColor)
    {
        UINavigationBar.appearance().clipsToBounds = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = color
    }
}

//MARK: - Navigation Bar
public extension UIManager
{
    /** Make navigationbar transparent **/
    public func updateNavigationBarTranslucentWith(vc: UIViewController?, isTransparent: Bool)
    {
        guard let nav = vc?.navigationController else {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        
        if isTransparent == true
        {
            nav.navigationBar.isTranslucent = true
        }
        else
        {
            nav.navigationBar.isTranslucent = false
        }
    }
    
    /** Change navigationbar title and tint color **/
    public func updateNavigationBarTitleTintWith(vc: UIViewController?, color: UIColor)
    {
        guard let nav = vc?.navigationController else {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
        nav.navigationBar.tintColor = color
    }
    
    /** Change navigation bar style to black **/
    public func updateNavigationBarBlackWith(vc: UIViewController?)
    {
        guard let nav = vc?.navigationController else
        {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        nav.navigationBar.barStyle = .black
    }
    
    /** Change navigation bar style to default **/
    public func updateNavigationBarDefaultWith(vc: UIViewController?)
    {
        guard let nav = vc?.navigationController else {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        nav.navigationBar.barStyle = .default
    }
    
    /** Hide of show navigation controller **/
    public func showHideNavigationBarWith(vc: UIViewController?, ishidden: Bool, animated: Bool)
    {
        guard let nav = vc?.navigationController else {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        nav.setNavigationBarHidden(ishidden, animated: animated)
    }
    
    /** Change navigation bar color **/
    public func updateNavigationBarTintWith(vc: UIViewController?, color: UIColor)
    {
        guard let nav = vc?.navigationController else {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        nav.navigationBar.barTintColor = color
    }
    
    /** Create shadow image for navigation bar to remove the bottom line **/
    public func addNavigationBarBackgroundShadowImageWith(vc: UIViewController?)
    {
        guard let nav = vc?.navigationController else {
            print("ERROR: The ViewController does not have NavigationController")
            return
        }
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
    }
}
