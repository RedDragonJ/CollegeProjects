//
//  IntroPage1.swift
//  AutoGuardian
//
//  Created by James on 9/27/17.
//  Copyright © 2017 James. All rights reserved.
//

import Foundation
import UIKit

class IntroPage1: AtlantisPrime {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    @IBOutlet weak var detailLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var title2Top: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton?
    @IBOutlet weak var subscriptionButton: UIButton?
    @IBOutlet weak var bodyText: UILabel?
    
    let iphone = iPhoneHelpers.init()
    
    deinit {
        print("\n --- dealloc IntroPage1 --- ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n --- Portable --- ")
        
        // BlueKai
        let webView = UIWebView.init()
        webView.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        self.view.addSubview(webView)
        let gif = GifManager.init()
        gif.loadGif(view: webView, source: "blue_kai_first_launch")
        //////////
        
        self.nextButton?.clipsToBounds = true
        self.nextButton?.layer.borderWidth = 2
        self.nextButton?.layer.borderColor = UIColor.white.cgColor
        self.nextButton?.layer.shadowColor = UIColor.black.cgColor
        self.nextButton?.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        self.nextButton?.layer.masksToBounds = false
        self.nextButton?.layer.shadowOpacity = 1.0
        self.nextButton?.layer.shadowRadius = 2.0
        
        /* TEXT */
        var fontSize: CGFloat = 0.0
        if  self.iphone.CheckiPhoneType() == 62
        {
            fontSize = 18
            self.titleLabel.font = UIFont(name: "OpenSans-Bold", size: 18)
            self.titleLabel2.font = UIFont(name: "OpenSans-Bold", size: 20)
            self.detailLabelHeight.constant = 140
            self.title2Top.constant = 55
        }
        else if self.iphone.CheckiPhoneType() == 10
        {
            fontSize = 16
            self.titleLabel.font = UIFont(name: "OpenSans-Bold", size: 18)
            self.titleLabel2.font = UIFont(name: "OpenSans-Bold", size: 20)
            self.detailLabelHeight.constant = 130
            self.title2Top.constant = 45
        }
        else if self.iphone.CheckiPhoneType() == 61
        {
            fontSize = 16
            self.titleLabel.font = UIFont(name: "OpenSans-Bold", size: 16)
            self.titleLabel2.font = UIFont(name: "OpenSans-Bold", size: 18)
            self.detailLabelHeight.constant = 130
            self.title2Top.constant = 45
        }
        else if self.iphone.CheckiPhoneType() == 5
        {
            fontSize = 13
            self.title2Top.constant = 25
        }
        
        let attFirstStr = NSMutableAttributedString.init(string: "With Sfara, it’s all covered: driver, passenger, \ntaxi, ride-share, children carpooling home \nand teenagers off to school. Sfara is always \npresent, aware and ready to call for help ", attributes: [NSAttributedStringKey.font: UIFont(name: "OpenSans", size: fontSize)!, NSAttributedStringKey.foregroundColor: UIColor.white])
        let attSecondStr = NSMutableAttributedString.init(string: "— \nCrash Protection in your pocket™.", attributes: [NSAttributedStringKey.font: UIFont(name: "OpenSans-Italic", size: fontSize)!, NSAttributedStringKey.foregroundColor: UIColor.white])
        attFirstStr.append(attSecondStr)
        self.bodyText?.attributedText = attFirstStr
        ////////////////////
        
        if self.iphone.CheckiPhoneType() == 5
        {
            self.nextButton?.layer.cornerRadius = 20
        }
        else if self.iphone.CheckiPhoneType() == 61
        {
            self.nextButton?.layer.cornerRadius = 23
        }
        else if self.iphone.CheckiPhoneType() == 62
        {
            self.nextButton?.layer.cornerRadius = 25
        }
        else
        {
            self.nextButton?.layer.cornerRadius = 28
        }
    }
    
    @IBAction func nextButtonTapped(sender: UIButton)
    {
        guard let parentVC = self.parent else {
            print("PageViewController ERROR: Bad parent")
            return
        }
        
        guard let pageVC = parentVC as? IntroPageViewController else {
            print("PageViewController ERROR: Failed to cast into IntroPageViewController")
            return
        }
        
        pageVC.goNextPage(index: 0)
    }
    
    @IBAction func subscriptionButtonTapped(sender: UIButton)
    {
        self.user.SetDefaultWith(count: 0, key: self.user.introPageState)
        self.user.SetDefaultWith(bool: true, key: "IntroPageDone")
        self.user.SaveUser()
        self.dismiss(animated: false, completion:nil)
    }
}
