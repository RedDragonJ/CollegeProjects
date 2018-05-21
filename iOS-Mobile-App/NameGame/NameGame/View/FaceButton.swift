//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {

    // Set those up when set up the game mode
    var id: Int = 0
    var compareName: String?
    var employeeName: String?
    
    var employeeImage: UIImage?
    
    private let network = NetworkManager.shared
    private let stats = StatsTrack.shared
    private let loader = LoadingViewHelper() //TODO: should i use this?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp), for: .touchDragOutside)
        
        self.alpha = 0.0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
    }
    
    func startLoading() {
        self.alpha = 0.0
        self.isEnabled = false
    }
    
    func stopLoading(withButtonEnable: Bool) {
        self.isEnabled = withButtonEnable
        UIView.animate(withDuration: 1.5, animations: {
            self.alpha = 1.0
        })
    }
    
    @objc func touchDown() {
        self.backgroundColor = .gray
    }
    
    @objc func touchUp() {
        self.backgroundColor = .white
    }
}

// MARK: - Button Game Logic
extension FaceButton {
    func checkMatch() -> Bool {
        if self.employeeName! == self.compareName! {// Won the game
            self.stats.problemEndTime = Date()//Set an end date for game
            if self.stats.gameMode == .hint {
                self.stats.stopHintTimer()
            }
            return true
        }
        else { // Not found correct people yet
            self.stats.incorrectAttempts += 1
            return false
        }
    }
    
    func disableButton() {
        self.isEnabled = false
    }
}

// MARK: - Image Network
extension FaceButton {
    
    //MARK: - set image for button
    func setImage(url: String) {
        self.startLoading()
        let imageUrl = String(format: "https:%@", url)
        
        if self.stats.gameMode == .reverse {//Disable this button touch when in reverse mode
            self.isUserInteractionEnabled = false
        }
        
        self.network.requestDataWith(urlStr: imageUrl, completion: {(data, response, error) in
            if let err = error {
                print(err)
                self.stopLoading(withButtonEnable: false)
                self.setImage(#imageLiteral(resourceName: "error"), for: .normal)
            }
            else {
                self.stopLoading(withButtonEnable: true)
                //checking if the response contains an image
                if let imageData = data {
                    // convert and set the image
                    let image = UIImage(data: imageData)
                    self.employeeImage = image!//Set the image property for checking later
                    self.setImage(image!, for: .normal)
                    
                    if self.stats.gameMode != .reverse {
                        NotificationCenter.default.post(name: Notification.Name("UpdateButtonStatus"), object: nil)//Send notification to check if buttons' images all loaded
                    }
                    
                } else {
                    print("No Image Data")
                    self.setImage(#imageLiteral(resourceName: "person"), for: .normal)
                }
            }
        })
    }
    
    func setButtonTitle(text: String) {
        self.setImage(nil, for: .normal)
        self.setTitle(text, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = .black
    }
}
