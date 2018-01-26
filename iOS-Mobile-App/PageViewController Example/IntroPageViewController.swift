//
//  IntroPageViewController.swift
//  AutoGuardian
//
//  Created by James on 9/27/17.
//  Copyright © 2017 James. All rights reserved.
//

import Foundation
import UIKit

class IntroPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //ViewControllers
    lazy var orderViewControllers: [UIViewController]? = [UIViewController]()
    
    //Constant class
    let iphone = iPhoneHelpers.init()
    let user = DefaultHelpers.shared
    
    //Vars
    var currentIndex: Int = 0
    var pageControl: UIPageControl?
    
    //MARK: - PageViewController Life Cycle
    deinit {
        self.orderViewControllers = nil
        self.pageControl = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.pageControl = UIPageControl.init()
        self.orderViewControllers = [self.newVC(identifier: "intro1"),self.newVC(identifier: "intro3"),self.newVC(identifier: "intro4"),self.newVC(identifier: "intro2")]
        
        self.dataSource = self
        self.delegate = self
        
        if let fristViewController = self.orderViewControllers!.first {
            setViewControllers([fristViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configurePageControl()
        
        let imageView = UIImageView.init(frame: UIScreen.main.bounds)
        imageView.image = #imageLiteral(resourceName: "Background")
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.user.GetDefaultWithInt(key: self.user.introPageState) != 0
        {
            let nextViewController = self.orderViewControllers![self.user.GetDefaultWithInt(key: self.user.introPageState)]
            self.pageControl?.currentPage = self.orderViewControllers!.index(of: nextViewController)!
            setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
            self.user.SetDefaultWith(count: 0, key: self.user.introPageState)
        }
    }
    
    func newVC(identifier: String) -> UIViewController
    {
        return UIStoryboard.init(name: StoryboardConstants.introName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func configurePageControl()
    {
        if self.iphone.CheckiPhoneType() == 5
        {
            self.pageControl = UIPageControl(frame: CGRect(x: 0,y: view.bounds.height - 135.0, width: UIScreen.main.bounds.width,height: 50))
        }
        else if self.iphone.CheckiPhoneType() == 61
        {
            self.pageControl = UIPageControl(frame: CGRect(x: 0,y: view.bounds.height - 150.0, width: UIScreen.main.bounds.width,height: 50))
        }
        else if self.iphone.CheckiPhoneType() == 62
        {
            self.pageControl = UIPageControl(frame: CGRect(x: 0,y: view.bounds.height - 160.0, width: UIScreen.main.bounds.width,height: 50))
        }
        else if self.iphone.CheckiPhoneType() == 10
        {
            self.pageControl = UIPageControl(frame: CGRect(x: 0,y: view.bounds.height - 200.0, width: UIScreen.main.bounds.width,height: 50))
        }
        self.pageControl?.numberOfPages = self.orderViewControllers!.count
        self.pageControl?.currentPage = 0
        self.pageControl?.isUserInteractionEnabled = false
        self.pageControl?.pageIndicatorTintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.25)
        self.pageControl?.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(self.pageControl!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl?.currentPage = self.orderViewControllers!.index(of: pageContentViewController)!
    }
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.orderViewControllers!.index(of: viewController) else {
            return nil
        }
        
        //self.currentIndex = viewControllerIndex
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            //return self.orderViewControllers.last
            return nil
        }
        
        guard self.orderViewControllers!.count > previousIndex else {
            return nil
        }
        
        return self.orderViewControllers![previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.orderViewControllers!.index(of: viewController) else {
            return nil
        }
        
        //self.currentIndex = viewControllerIndex
        
        let nextIndex = viewControllerIndex + 1
        
        guard self.orderViewControllers!.count != nextIndex else {
            //return self.orderViewControllers.first
            return nil
        }
        
        guard self.orderViewControllers!.count > nextIndex else {
            return nil
        }
        
        return self.orderViewControllers![nextIndex]
    }
}

//MARK: - Button Tap to Next Page Delegates
extension IntroPageViewController
{
    func goNextPage(index: Int) {
        if index < 3
        {
            let nextViewController = self.orderViewControllers![index+1]
            self.pageControl?.currentPage = self.orderViewControllers!.index(of: nextViewController)!
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}
