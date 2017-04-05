//
//  FamilyPasscodeView.swift
//  FamilyOrganizer
//
//  Created by James Sun on 7/8/16.
//  Copyright © 2016 Sevenlogics. All rights reserved.
//

import UIKit

class FamilyPasscodeView: UIView, FOPasscodeDetailViewDelegate
{
    typealias FamilyPasscodeView_CompletionBlock = (FamilyPasscodeView!, Bool) -> Void
    
    @IBOutlet var contentView:UIView?
    
    var completionBlock:FamilyPasscodeView_CompletionBlock?
    var passCodeView:FamilyPasscodeDetailView!
    
    var FOviewType:PasscodeViewType?
    
    //MARK: - Methods
    static func familyPasscodeViewWithViewType(FOviewType: PasscodeViewType) -> FamilyPasscodeView
    {
        var settingsPasscodeView:FamilyPasscodeView!
        settingsPasscodeView = ViewHelper.viewFromBundleNamed("FamilyPasscodeView") as! FamilyPasscodeView
        settingsPasscodeView.FOviewType = FOviewType
        settingsPasscodeView.passCodeView.FOviewType = FOviewType
        settingsPasscodeView.passCodeView.setFOviewType(settingsPasscodeView.FOviewType!)
        
        return settingsPasscodeView
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.passCodeView = FamilyPasscodeDetailView.FamilyOrganizerSLPasscodeViewDelegate(self)
        
        if (DeviceUtil.isDeviceOSVersionBase7x())
        {
            self.passCodeView.frame = CGRectMake(0, 0, self.contentView!.frame.size.width, self.contentView!.frame.size.height);
        }
        
        self.passCodeView.setTitleColor(UIColor.whiteColor(), fontName: "Quicksand-Regular", bgColor: UIColor.clearColor(), textColor: UIColor.whiteColor())
        
        self.contentView?.addSubview(self.passCodeView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillResignActive(_:)), name:UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    //MARK: - NSNotification
    func applicationWillResignActive(notification: NSNotification)
    {
        if (nil != self.completionBlock)
        {
            self.completionBlock!(self,false)
        }
    }
    
    //MARK: - IBAction
    @IBAction func cancelAction(sender: AnyObject!)
    {
        if (nil != self.completionBlock)
        {
            self.completionBlock!(self,false)
        }
    }
    
    //MARK: - SLPasscodeViewDelegate
    func touchIdAuthenticatedForPasscodeView(passcodeView: FamilyPasscodeDetailView)
    {
        //this is touchID
    }
    
    func passcodeView(passcodeView: FamilyPasscodeDetailView, enteredPasscode passcode: String)
    {
        if (StringHelper.isEmptyString(passcode))
        {
            return
        }
        
        if (self.FOviewType! == PasscodeViewTypeEnable)
        {
            AppDelegate.sharedInstance().userInfos?.setBool(true, forKey: "passcodeEnable")
            AppDelegate.sharedInstance().userInfos?.setObject(passcode, forKey: "passcode")
            AppDelegate.sharedInstance().userInfos!.synchronize()
            
            self.completionBlock?(self,true)
        }
        else if (self.FOviewType! == PasscodeViewTypeUnlock)
        {
            if (passcode == AppDelegate.sharedInstance().userInfos!.objectForKey("passcode") as! String)
            {
                self.completionBlock!(self,true)
                
                passcodeView.resetWithPasscodeType(PasscodeViewValueTypeNone)
            }
            else
            {
                passcodeView.resetWithPasscodeType(PasscodeViewValueTypeFail)
            }
        }
        else if (self.FOviewType! == PasscodeViewTypeDisable)
        {
            if (passcode == AppDelegate.sharedInstance().userInfos!.objectForKey("passcode") as! String)
            {
                AppDelegate.sharedInstance().userInfos?.setBool(false, forKey: "passcodeEnable")
                AppDelegate.sharedInstance().userInfos?.setObject("Empty", forKey: "passcode")
                AppDelegate.sharedInstance().userInfos!.synchronize()
                
                self.completionBlock?(self,true)
            }
            else
            {
                passcodeView.resetWithPasscodeType(PasscodeViewValueTypeFail)
            }
        }
        else if (self.FOviewType! == PasscodeViewTypeChange)
        {
            if (passcodeView.enteringNewPasscode())
            {
                AppDelegate.sharedInstance().userInfos?.setObject(passcode, forKey: "passcode")
                AppDelegate.sharedInstance().userInfos!.synchronize()
                
                self.completionBlock!(self,true)
            }
            else if (passcode == AppDelegate.sharedInstance().userInfos!.objectForKey("passcode") as! String)
            {
                passcodeView.resetWithPasscodeType(PasscodeViewValueTypeReEnter)
            }
            else
            {
                passcodeView.resetWithPasscodeType(PasscodeViewValueTypeFail)
            }
        }
    }
    
    func passcodeView(passcodeView: FamilyPasscodeDetailView, cancelAction sender: AnyObject?)
    {
        self.cancelAction(sender)
    }
}
