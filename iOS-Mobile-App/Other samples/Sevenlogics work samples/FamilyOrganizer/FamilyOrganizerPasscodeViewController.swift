//
//  FamilyOrganizerSLPasscodeViewController.swift
//  FamilyOrganizer
//
//  Created by James Sun on 7/22/16.
//  Copyright © 2016 Sevenlogics. All rights reserved.
//

import UIKit

@objc protocol FOSLPasscodeViewControllerDelegate
{
    optional func touchIdAuthenticatedForPasscodeViewController(viewController: FamilyOrganizerSLPasscodeViewController)
    optional func passcodeViewController(viewController: FamilyOrganizerSLPasscodeViewController, enteredPasscode passcode:String!)
    optional func passcodeViewController(viewController: FamilyOrganizerSLPasscodeViewController, cancelAction sender:AnyObject?)
}

class FamilyOrganizerSLPasscodeViewController: SLPasscodeViewController
{
    var FOviewControllerType:PasscodeViewType?
    var FOpasscodeView: FamilyPasscodeDetailView!
    
    static func FamilyOrganizerSLPasscodeViewControllerDelegate(FOviewType: PasscodeViewType, delegate: AnyObject) -> FamilyOrganizerSLPasscodeViewController
    {
        let viewController = FamilyOrganizerSLPasscodeViewController.init(nibName: "SLPasscodeViewController", bundle: nil)
        
        viewController.FOviewControllerType = FOviewType

        viewController.delegate = delegate
        
        return viewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationBar.hidden = true
        self.navigationBar.translucent = true
        
        //presenting viewdidload stuff
        if (nil == self.FOpasscodeView)
        {
            var frame:CGRect!
            frame = self.view.frame
            
            frame.origin.y += CGRectGetMaxX(super.navigationBar.frame)
            
            self.FOpasscodeView = FamilyPasscodeDetailView.FamilyOrganizerSLPasscodeViewDelegate(self)
            
            self.FOpasscodeView.frame = frame
            self.FOpasscodeView.FOviewType = self.FOviewControllerType!
            self.FOpasscodeView.setFOviewType(self.FOviewControllerType!)
            
            self.view.addSubview(self.FOpasscodeView)
        }
        
        if (DeviceUtil.isDeviceOSVersionBase7x())
        {
            ViewHelper.view(self.view, setHeight: DeviceUtil.sharedInstance().maxHeight)
        }
        else
        {
            ViewHelper.view(self.view, setHeight: DeviceUtil.sharedInstance().maxHeight - CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame))
        }
        
    }
    
    //MARK: - methods for presenting passcode view and touchID
    func presentFOPasscodeViewInView(view: UIView!, animated: Bool)
    {
        if (DeviceUtil.isDeviceOSVersionBase7x() && !(UIApplication.sharedApplication().statusBarHidden))
        {
            ViewHelper.view(self.FOpasscodeView, setY: 0)
        }
        view.addSubview(self.view)
        
        if (DeviceUtil.isDeviceOSVersionBase8x())
        {
            self.view.frame = view.bounds
        }
        
        if (!animated)
        {
            self.view.alpha = 1.0
        }
        else
        {
            self.view.alpha = 0.0
            
            UIView.animateWithDuration(0.3, animations: {
                self.view.alpha = 1.0
            })
        }
    }
    
    //MARK: - FOSLpasscodeView stuff
    func passcodeView(passcodeView: FamilyPasscodeDetailView, enteredPasscode passcode: String)
    {
        if(self.delegate.respondsToSelector(#selector(FOSLPasscodeViewControllerDelegate.passcodeViewController(_:enteredPasscode:))))
        {
            self.delegate.passcodeViewController!(self, enteredPasscode: passcode)
        }
    }
     
    func touchIdAuthenticatedForPasscodeView(passcodeView: FamilyPasscodeDetailView)
    {
        if (self.delegate.respondsToSelector(#selector(FOSLPasscodeViewControllerDelegate.touchIdAuthenticatedForPasscodeViewController(_:))))
        {
            self.delegate.touchIdAuthenticatedForPasscodeViewController!(self)
        }
    }
     
    func passcodeView(passcodeView: FamilyPasscodeDetailView, cancelAction sender: AnyObject?)
    {
        if (self.delegate.respondsToSelector(#selector(FOSLPasscodeViewControllerDelegate.passcodeViewController(_:cancelAction:))))
        {
            self.delegate.passcodeViewController!(self, cancelAction: sender)
        }
        else if (PasscodeViewTypeUnlock == self.FOviewControllerType!)
        {
            let alert = UIAlertController(title: "Do you wish to exit the app?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {_ in self.AlertCancelAction()}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.cancelAction(sender)
        }
     }
     
     //MARK: - alertcontroller stuff
     func AlertCancelAction() -> Void
     {
        exit(0)
     }
    
}
