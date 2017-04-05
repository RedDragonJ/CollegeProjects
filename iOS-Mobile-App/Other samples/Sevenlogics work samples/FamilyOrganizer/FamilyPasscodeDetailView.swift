//
//  FamilyOrganizerSLPasscodeView.swift
//  FamilyOrganizer
//
//  Created by James Sun on 7/22/16.
//  Copyright © 2016 Sevenlogics. All rights reserved.
//

import UIKit
import LocalAuthentication

@objc protocol FOPasscodeDetailViewDelegate
{
    func passcodeView(passcodeView: FamilyPasscodeDetailView, enteredPasscode passcode: String)
    func touchIdAuthenticatedForPasscodeView(passcodeView: FamilyPasscodeDetailView)
    
    optional func passcodeView(passcodeView: FamilyPasscodeDetailView, cancelAction sender: AnyObject?)
}

class FamilyPasscodeDetailView: SLPasscodeView
{
    let DELETE_BUTTON_TAG = -1
    
    var TOUCH_ID_IS_SHOWN = false
    
    //Family Organizer own IBOutlet
    @IBOutlet var FOtitleImage:UIImageView!
    @IBOutlet var FOkeyboard:UIView!
    @IBOutlet var FOanimationView:UIView!
    @IBOutlet var FOinstructionLabel:UILabel!
    @IBOutlet var FOdeleteButton:UIButton!
    @IBOutlet var FOtextfield1:UITextField!
    @IBOutlet var FOtextfield2:UITextField!
    @IBOutlet var FOtextfield3:UITextField!
    @IBOutlet var FOtextfield4:UITextField!
    
    //private variables
    var FOfakePasscode: NSString?
    var FOpasscode: NSString?
    var FOenterNewPasscode: Bool?
    
    //layout switches
    var isAdjustedImage:Bool?
    var isAdjustedKeys:Bool?
    var isDotsComplete:Bool?
    
    var FOviewType: PasscodeViewType?
    
    static func FamilyOrganizerSLPasscodeViewDelegate(delegate: AnyObject?) -> FamilyPasscodeDetailView
    {
        let view = ViewHelper.viewFromBundleNamed("FamilyPasscodeDetailView") as! FamilyPasscodeDetailView

        view.delegate = delegate;
        return view;
    }
    
    //MARK: - Override SLPasscode functions
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib()
    {
        self.FOenterNewPasscode = false
        self.FOfakePasscode = ""
        self.FOpasscode = ""
        
        self.isAdjustedImage = false
        self.isAdjustedKeys = false
        self.isDotsComplete = false
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.SetUpFamilyOrganizerViews()
    }
    
    //MARK: - functions override
    override func resetWithPasscodeType(type: PasscodeViewValueType)
    {
        self.performSelector(#selector(resetTextFieldsWithType(_:)), withObject: NSNumber(int: Int32(type.rawValue)), afterDelay: 0)
    }
    
    override func enteringNewPasscode() -> Bool
    {
        return self.FOenterNewPasscode!
    }
 
    //MARK: - button action
    @IBAction func keyboardButtonTapped(sender: AnyObject)
    {
        let tag = sender.tag as Int
        
        if (tag == DELETE_BUTTON_TAG)
        {
            if (self.FOfakePasscode!.length != 0)
            {
                self.FOfakePasscode = self.FOfakePasscode?.substringToIndex(self.FOfakePasscode!.length - 1)
            }
            else
            {
                if (self.delegate.respondsToSelector(#selector(FOPasscodeDetailViewDelegate.passcodeView(_:cancelAction:))))
                {
                    self.delegate.passcodeView!(self, cancelAction: sender)
                }
            }
        }
        else if (self.FOfakePasscode!.length < 4)
        {
            self.FOfakePasscode = self.FOfakePasscode!.stringByAppendingFormat("%d", tag)
        }
        
        self.updatePasscodeView()
        
        if (self.FOfakePasscode!.length == 4)
        {
            self.userInteractionEnabled = false
            
            self.performSelector(#selector(checkPasscode(_:)), withObject: self.FOfakePasscode!, afterDelay: 0.1)
        }
        
    }
    
    //MARK: - Properties
    func setFOviewType(FOviewType: PasscodeViewType) -> Void
    {
        self.FOviewType = FOviewType
        
        if (FOviewType == PasscodeViewTypeChange)
        {
            self.FOtitleImage.image = UIImage(named: "enterOldPasscode")
            self.FOenterNewPasscode = false
        }
        else if (FOviewType == PasscodeViewTypeEnable)
        {
            self.FOtitleImage.image = UIImage(named: "setPasscode")
        }
        else
        {
            self.FOtitleImage.image = UIImage(named: "enterPasscode")
        }
    }
    
    //MARK: - present touchID
    func presentFOTouchIdAuthentication() -> Void
    {
        if (!DeviceUtil.isDeviceOSVersionBase8x())
        {
            return
        }
        
        let myContext = LAContext()
        var authError:NSError?
        var bSelf:FamilyPasscodeDetailView!
        bSelf = self
        
        let myLocalizedReasonString = "Authenticate using Touch ID"
        
        if (myContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError))
        {
            self.TOUCH_ID_IS_SHOWN = true
            
            myContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: {( success: Bool, error: NSError?) in
                dispatch_async(dispatch_get_main_queue(), {
                    self.TOUCH_ID_IS_SHOWN = false
                    
                    if (success)
                    {
                        if (nil != bSelf.delegate && bSelf.delegate.respondsToSelector(#selector(FOPasscodeDetailViewDelegate.touchIdAuthenticatedForPasscodeView(_:))))
                        {
                            bSelf.delegate.touchIdAuthenticatedForPasscodeView(self)
                        }
                    }
                    else
                    {
                        switch (error!.code)
                        {
                        case Int(kLAErrorAuthenticationFailed):
                            print("Authentication Failed")
                            break
                        case Int(kLAErrorUserCancel):
                            print("User pressed Cancel button")
                            break
                        case Int(kLAErrorUserFallback):
                            print("User pressed \"Enter Password\"")
                            break
                        default:
                            print("Touch ID is not configured")
                            break
                        }
                        print("Authentication Fails")
                    }
                })
            })
        }
        else
        {
            print("Can not evaluate Touch ID")
        }
        
    }
    
    //MARK: - Methods
    func resetTextFieldsWithType(typeNumber: NSNumber) -> Void
    {
        self.updatePasscodeView()

        switch typeNumber.intValue
        {
        case Int32(PasscodeViewValueTypeInvalid.rawValue), Int32(PasscodeViewValueTypeFail.rawValue):
            
            let incorrectColor = UIColor(red: 1.0, green: 0.90, blue: 0.0, alpha: 1.0)
            if (typeNumber.intValue == Int32(PasscodeViewValueTypeFail.rawValue))
            {
                self.FOinstructionLabel.text = "Incorrect passcode"
                self.FOinstructionLabel.textColor = incorrectColor
                self.FOinstructionLabel.font = UIFont(name: "Quicksand-Bold", size: 15)
            }
            else
            {
                if (self.FOviewType == PasscodeViewTypeChange)
                {
                    self.FOtitleImage.image = UIImage(named: "enterNewPasscode")
                }
                else
                {
                    self.FOtitleImage.image = UIImage(named: "setPasscode")
                }
                
                self.FOinstructionLabel.text = "Passcode does not match"
                self.FOinstructionLabel.textColor = incorrectColor
                self.FOinstructionLabel.font = UIFont(name: "Quicksand-Bold", size: 15)
            }
            
            let animation = CABasicAnimation.init(keyPath: "position")
            UIView.setAnimationDidStopSelector(#selector(animationDidStop(_:finished:)))
            animation.delegate = self
            UIView.setAnimationDidStopSelector(#selector(animationDidStop(_:finished:)))
            animation.duration = 0.025
            animation.repeatCount = 8
            animation.autoreverses = true
            animation.fromValue = NSValue.init(CGPoint: CGPointMake(self.FOanimationView.center.x - 14.0, self.FOanimationView.center.y))
            animation.toValue = NSValue.init(CGPoint: CGPointMake(self.FOanimationView.center.x + 14.0, self.FOanimationView.center.y))
            self.FOanimationView.layer.addAnimation(animation, forKey: "position")
            
            break
        case Int32(PasscodeViewValueTypeReEnter.rawValue):
            
            if (self.FOviewType == PasscodeViewTypeChange)
            {
                self.FOenterNewPasscode = true
                
                if (!StringHelper.isEmptyString(self.FOpasscode as! String))
                {
                    self.FOtitleImage.image = UIImage(named: "reenterNewPasscode")
                }
                else
                {
                    self.FOtitleImage.image = UIImage(named: "enterNewPasscode")
                }
            }
            else
            {
                self.FOtitleImage.image = UIImage(named: "reenterPasscode")
            }
            
            self.FOinstructionLabel.text = ""
            
            let transition = CATransition.init()
            transition.delegate = self
            UIView.setAnimationDidStopSelector(#selector(animationDidStop(_:finished:)))
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.exchangeSubviewAtIndex(0, withSubviewAtIndex: 1)
            self.FOanimationView.layer.addAnimation(transition, forKey: "swipe")
            
            break
        case Int32(PasscodeViewValueTypeNone.rawValue):
            self.FOinstructionLabel.text = ""
            break
        default:
            self.FOinstructionLabel.text = ""
            break
        }
        
        self.userInteractionEnabled = true
    }
    
    //update the passcode once user entered
    func updatePasscodeView() -> Void
    {
        switch self.FOfakePasscode!.length
        {
        case 0:
            self.FOtextfield1.backgroundColor = UIColor.clearColor()
            self.FOtextfield2.backgroundColor = UIColor.clearColor()
            self.FOtextfield3.backgroundColor = UIColor.clearColor()
            self.FOtextfield4.backgroundColor = UIColor.clearColor()
            
            self.FOdeleteButton.setTitle("Cancel", forState: UIControlState.Normal)
            self.FOdeleteButton.setTitle("Cancel", forState: UIControlState.Highlighted)
            break;
        case 1:
            self.FOtextfield1.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield2.backgroundColor = UIColor.clearColor()
            self.FOtextfield3.backgroundColor = UIColor.clearColor()
            self.FOtextfield4.backgroundColor = UIColor.clearColor()
            
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Normal)
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Highlighted)
            break;
        case 2:
            self.FOtextfield1.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield2.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield3.backgroundColor = UIColor.clearColor()
            self.FOtextfield4.backgroundColor = UIColor.clearColor()
            
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Normal)
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Highlighted)
            break;
        case 3:
            self.FOtextfield1.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield2.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield3.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield4.backgroundColor = UIColor.clearColor()
            
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Normal)
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Highlighted)
            break;
        case 4:
            self.FOtextfield1.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield2.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield3.backgroundColor = UIColor.whiteColor()//white
            self.FOtextfield4.backgroundColor = UIColor.whiteColor()//white
            
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Normal)
            self.FOdeleteButton.setTitle("DEL", forState: UIControlState.Highlighted)
            break;
            
        default:
            break;
        }
    }

    //check user entered passcode everytime
    func checkPasscode(passcode: NSString)
    {
        self.FOfakePasscode = ""
        
        if (self.FOviewType! == PasscodeViewTypeEnable || (self.FOviewType! == PasscodeViewTypeChange && self.FOenterNewPasscode!))
        {
            if (!(StringHelper.isEmptyString(self.FOpasscode as! String)))
            {
                if (!(self.FOpasscode!.isEqualToString(passcode as String)))
                {
                    self.FOpasscode = ""
                    self.resetWithPasscodeType(PasscodeViewValueTypeInvalid)
                    return
                }
            }
            else
            {
                self.FOpasscode = passcode
                self.resetWithPasscodeType(PasscodeViewValueTypeReEnter)
                return
            }
        }
        
        if (self.delegate.respondsToSelector(#selector(FOPasscodeDetailViewDelegate.passcodeView(_:enteredPasscode:))))
        {
            self.delegate.passcodeView(self, enteredPasscode: passcode as String)
        }
    }
    
    //MARK: - Set up the family organizer views
    func SetUpFamilyOrganizerViews() -> Void
    {
        //check if image size and point set up once
        if (self.isAdjustedImage != true)
        {
            ViewHelper.view(self.FOtitleImage, setY: self.FOkeyboard.frame.origin.y - 140)
            ViewHelper.view(self.FOtitleImage, setHeight: self.FOtitleImage.frame.size.height + 30)
            
            self.isAdjustedImage = true
        }
        
        //check if keynums size and point set up once
        if (self.isAdjustedKeys != true)
        {
            var buttonImage:UIImage!
            var buttonNineFrame:CGRect!
            
            for view in self.FOkeyboard.subviews as [UIView]
            {
                if (view.isKindOfClass(UIButton))
                {
                    let button = view as! UIButton
                    
                    if ((button.titleLabel!.text! as String == "1") || (button.titleLabel!.text! as String == "2") || (button.titleLabel!.text! as String == "3"))
                    {
                        ViewHelper.view(button, setY: button.frame.origin.y + button.frame.size.height/5)
                        buttonImage = button.currentBackgroundImage
                        ViewHelper.view(button, setSize: CGSizeMake(buttonImage.size.height, buttonImage.size.height))
                    }
                    
                    if ((button.titleLabel!.text! as String == "4") || (button.titleLabel!.text! as String == "5") || (button.titleLabel!.text! as String == "6"))
                    {
                        buttonImage = button.currentBackgroundImage
                        ViewHelper.view(button, setSize: CGSizeMake(buttonImage.size.height, buttonImage.size.height))
                    }
                    
                    if ((button.titleLabel!.text! as String == "7") || (button.titleLabel!.text! as String == "8") || (button.titleLabel!.text! as String == "9"))
                    {
                        ViewHelper.view(button, setY: button.frame.origin.y - button.frame.size.height/5)
                        buttonImage = button.currentBackgroundImage
                        ViewHelper.view(button, setSize: CGSizeMake(buttonImage.size.height, buttonImage.size.height))
                        
                        if (button.titleLabel!.text! as String == "9")
                        {
                            buttonNineFrame = button.frame
                        }
                    }
                    
                    if (button.titleLabel!.text! as String == "0")
                    {
                        ViewHelper.view(button, setY: button.frame.origin.y - button.frame.size.height/2.5)
                        buttonImage = button.currentBackgroundImage
                        ViewHelper.view(button, setSize: CGSizeMake(buttonImage.size.height, buttonImage.size.height))
                    }
                    
                    if (button.titleLabel!.text! as String == "Cancel")
                    {
                        ViewHelper.view(self.FOdeleteButton, setY: buttonNineFrame.origin.y + buttonNineFrame.size.height * 1.1 + self.FOdeleteButton.frame.size.height/3)
                        ViewHelper.view(self.FOdeleteButton, setX: 150)
                        ViewHelper.view(self.FOdeleteButton, setHeight: self.FOdeleteButton.frame.size.height/3)
                    }
                }
            }
            self.isAdjustedKeys = true
        }
 
        //check if passcode dots size and point set up once
        if (self.isDotsComplete != true)
        {
            let text1_X = 35 as CGFloat
            let text4_X = self.FOanimationView.frame.size.width - self.FOtextfield1.frame.size.width - text1_X as CGFloat
            let difference_X = (text4_X - text1_X) / 3 as CGFloat
            let text2_X = text1_X + difference_X as CGFloat
            let text3_X = text2_X + difference_X as CGFloat
            
            self.FOtextfield1.placeholder = "";
            self.FOtextfield1.layer.cornerRadius =  self.FOtextfield1.frame.size.width / 2
            self.FOtextfield1.clipsToBounds = true
            self.FOtextfield1.layer.borderWidth = 1.5
            ViewHelper.view(self.FOtextfield1, setX: text1_X)
            
            self.FOtextfield2.placeholder = "";
            self.FOtextfield2.layer.cornerRadius =  self.FOtextfield2.frame.size.width / 2
            self.FOtextfield2.clipsToBounds = true
            self.FOtextfield2.layer.borderWidth = 1.5
            ViewHelper.view(self.FOtextfield2, setX: text2_X)

            self.FOtextfield3.placeholder = "";
            self.FOtextfield3.layer.cornerRadius =  self.FOtextfield3.frame.size.width / 2
            self.FOtextfield3.clipsToBounds = true
            self.FOtextfield3.layer.borderWidth = 1.5
            ViewHelper.view(self.FOtextfield3, setX: text3_X)

            self.FOtextfield4.placeholder = "";
            self.FOtextfield4.layer.cornerRadius =  self.FOtextfield4.frame.size.width / 2
            self.FOtextfield4.clipsToBounds = true
            self.FOtextfield4.layer.borderWidth = 1.5
            ViewHelper.view(self.FOtextfield4, setX: text4_X)
            
            self.FOtextfield1.layer.borderColor = UIColor.whiteColor().CGColor
            self.FOtextfield2.layer.borderColor = UIColor.whiteColor().CGColor
            self.FOtextfield3.layer.borderColor = UIColor.whiteColor().CGColor
            self.FOtextfield4.layer.borderColor = UIColor.whiteColor().CGColor
            
            self.isDotsComplete = true
        }
        
        let centerX = self.FOkeyboard.frame.size.width / 2 as CGFloat
        let leftCenterX = self.FOkeyboard.frame.size.width / 4
        let rightCenterX = leftCenterX * 3
        
        for view in self.FOkeyboard.subviews as [UIView]
        {
            if (view.isKindOfClass(UIButton))
            {
                let button = view as! UIButton
                
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                
                let tag = button.tag as Int
                
                var centerXToUse:CGFloat
                centerXToUse = 0.0
                
                switch tag
                {
                case 2,5,8,0:
                    centerXToUse = centerX
                    break
                case 1,4,7:
                    centerXToUse = leftCenterX
                    break
                case 3,6,9,DELETE_BUTTON_TAG:
                    centerXToUse = rightCenterX
                    break
                default:
                    break
                }
                ViewHelper.view(button, setCenter: CGPointMake(centerXToUse, button.center.y))
            }
        }
        ViewHelper.view(self.FOinstructionLabel, setY: CGRectGetMinY(self.FOkeyboard.frame) - self.FOinstructionLabel.frame.size.height - 4.0)
        ViewHelper.view(self.FOanimationView, setY: CGRectGetMinY(self.FOinstructionLabel.frame) - self.FOanimationView.frame.size.height)
    }

    //MARK: - CAAnimationDelegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        self.FOtextfield1.backgroundColor = UIColor.clearColor()
        self.FOtextfield2.backgroundColor = UIColor.clearColor()
        self.FOtextfield3.backgroundColor = UIColor.clearColor()
        self.FOtextfield4.backgroundColor = UIColor.clearColor()
        
        self.FOfakePasscode = ""
        
        self.userInteractionEnabled = true
    }
    
}











