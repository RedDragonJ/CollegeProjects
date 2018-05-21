//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    
    private var nameGame = NameGame()
    private let stats = StatsTrack.shared
    
    private let alert = AlertViewManager.shared
    private let network = NetworkManager.shared
    private let loader = LoadingViewHelper()

    //MARK: - NameGameViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkButtonDownloadStatus), name: Notification.Name("UpdateButtonStatus"), object: nil)
            
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        
        // Set delegate between viewcontroller and NameGame
        nameGame.delegate = self
        
        // Check network status before make request to API
        self.network.checkStatus(completion: {status in
            switch status {
            case .NoNetwork, .OtherNetwork, .Unknown:
                // Show no network try again later
                break
            default:
                self.loader.startLoaderWith(view: self.view, loadViewColor: .gray, style: .whiteLarge)
                self.view.isUserInteractionEnabled = false
                self.nameGame.loadGameData()
                break
            }
        })
    }

    //MARK: - UI Transitions
    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
    
    //MARK: - UISegmentedControl Action
    @IBAction func segTapped(_ seg: UISegmentedControl) {
        switch seg.selectedSegmentIndex {
        case 0: // Matt mode
            self.setMattGame()
            break
        case 1: // Reverse mode
            self.setReverseGame()
            break
        case 2: // Hint mode
            self.setHintGame()
            break
        case 3: // Team mode
            self.setTeamGame()
            break
        default:
            break
        }
    }
    
    //MARK: - FaceButton Action
    @IBAction func faceTapped(_ button: FaceButton) {
        if button.checkMatch() == true {
            let msg = String(format: "Fail Attempt:%i; Time spent: %is", self.stats.incorrectAttempts, Int(self.stats.solveProblemTime!))
            self.alert.presentAlertWithClosure(title: "Stats", msg: msg, vc: self, closure: {
                if self.stats.gameMode == .matt {
                    self.setMattGame()
                }
                else if self.stats.gameMode == .reverse {
                    self.setReverseGame()
                }
                else if self.stats.gameMode == .hint {
                    self.setHintGame()
                }
                else if self.stats.gameMode == .team {
                    self.setTeamGame()
                }
            })
        }
    }
}

//MARK: - NameGame and NameGameDelegate
extension NameGameViewController: NameGameDelegate {
    
    //MARK: - NameGameDelegate
    func getData(employees: [Employee]?, numberData: Int, errorMsg: String?) {
        
        if errorMsg != nil {
            self.alert.presentAlertWith(title: "ERROR", msg: String(format: "%@, try again later", errorMsg!), vc: self)
        }
        else {
            // Capture the data
            self.nameGame.gameEmployees = employees!
            
            // First time run so check game mode and setup first game
            if self.stats.gameMode == .matt {
                self.nameGame.fetchWithSimilar(buttons: self.imageButtons, employees: employees!, pattern: "Matt", completion: {name in
                    self.questionLabel.text = name
                    self.stats.problemStartTime = Date()
                })
            }
        }
    }
    
    //MARK: - Start And Reset Matt Game
    func setMattGame() {
        self.loader.startLoaderWith(view: self.view, loadViewColor: .gray, style: .whiteLarge)
        self.stats.gameMode = .matt
        self.stats.resetStats()
        self.nameGame.fetchWithSimilar(buttons: self.imageButtons, employees: self.nameGame.gameEmployees!, pattern: "Matt", completion: {name in
            self.questionLabel.text = name //Update the question label
            self.stats.problemStartTime = Date() //Track starting time
        })
    }
    
    //MARK: - Start And Reset Reverse Game
    func setReverseGame() {
        self.loader.startLoaderWith(view: self.view, loadViewColor: .gray, style: .whiteLarge)
        self.stats.gameMode = .reverse
        self.stats.resetStats()
        self.nameGame.fetchWithReverse(buttons: self.imageButtons, employees: self.nameGame.gameEmployees!, completion: {
            self.questionLabel.text = "Who is...?" //Update the question label
            self.stats.problemStartTime = Date() //Track starting time
            self.view.isUserInteractionEnabled = true
            self.loader.stopLoader()
        })
    }
    
    //MARK: - Start And Reset Hint Game
    func setHintGame() {
        self.loader.startLoaderWith(view: self.view, loadViewColor: .gray, style: .whiteLarge)
        self.stats.gameMode = .hint
        self.stats.resetStats()
        self.nameGame.fetchWithHint(buttons: self.imageButtons, employees: self.nameGame.gameEmployees!, completion: {name in
            self.questionLabel.text = name  //Update the question label
            self.stats.problemStartTime = Date() //Track starting time
            // Run the timer
            self.stats.hintModeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateHintTime), userInfo: nil, repeats: true)
        })
    }
    
    //MARK: - Start And Reset Team Game
    func setTeamGame() {
        self.loader.startLoaderWith(view: self.view, loadViewColor: .gray, style: .whiteLarge)
        self.stats.gameMode = .team
        self.stats.resetStats()
        self.nameGame.fetchWithTeam(buttons: self.imageButtons, employees: self.nameGame.gameEmployees!, completion: {name in
            self.questionLabel.text = name  //Update the question label
            self.stats.problemStartTime = Date() //Track starting time
        })
    }
    
    //MARK: - Update The Hint Mode With Timer
    @objc func updateHintTime() {
        if self.stats.hintTime == 50.0 || self.stats.hintTime == 40.0 || self.stats.hintTime == 30.0 || self.stats.hintTime == 20.0 || self.stats.hintTime == 10.0 {
            self.nameGame.hintModeUpdateLogic(buttons: self.imageButtons)
        }
        
        if self.stats.hintTime == 10.0 {
            self.stats.stopHintTimer()
            if self.stats.problemEndTime == nil {
                self.stats.problemEndTime = Date()
                let msg = String(format: "Fail Attempt:%i; Time spent: %is", self.stats.incorrectAttempts, Int(self.stats.solveProblemTime!))
                self.alert.presentAlertWithClosure(title: "Stats", msg: msg, vc: self, closure: {
                    self.setHintGame()
                })
            }
        }
        self.stats.hintTime -= 1.0
    }
    
    //MARK: - Check Buttons All Loaded If Not Reverse Mode
    @objc func checkButtonDownloadStatus() {
        
        var buttonNotFinishLoading: Bool = true
        
        for button in self.imageButtons {
            if button.employeeImage == nil {
                buttonNotFinishLoading = false
                break
            }
        }
        
        if buttonNotFinishLoading == true {
            self.view.isUserInteractionEnabled = true
            self.loader.stopLoader()
        }
    }
}
