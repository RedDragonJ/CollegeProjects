//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation

//MARK: - NameGameDelegate Protocol
protocol NameGameDelegate: class {
    func getData(employees: [Employee]?, numberData: Int, errorMsg: String?)
}

class NameGame {
    
    // Delegate between NameGameViewController and NameGame
    weak var delegate: NameGameDelegate?
    
    // Capture array of Employee on the memory
    var gameEmployees: [Employee]?

    private let network = NetworkManager.shared
    private let numberPeople = 6
    
    //MARK: - Fetch Employees For Hint Mode
    func fetchWithHint(buttons: [FaceButton], employees: [Employee], completion: @escaping (_ compareName: String) -> Void) {
        var results = [Employee]()
        var duplicateTest = [String:Any]()
        var count: Int = 0
        
        // Loop only valid 6 times
        while count < self.numberPeople {
            let randomIndex = getRandom(count: employees.count)// Get random index number in the employee array
            let employee = employees[randomIndex]// Get random employee
            
            if let head = employee.headshot {// Remove people that doesn't have headshot
                if head.url != nil {
                    if duplicateTest[employee.id!] == nil{// Prevent random pick same employee
                        duplicateTest[employee.id!] = employee.slug!
                        results.append(employee)
                        count += 1
                    }
                }
            }
        }
        
        let randomIndex = self.getRandom(count: results.count)// Get random index number in the employee array
        let guessEmployee = results[randomIndex]
        let guessName = String(format: "%@ %@", guessEmployee.firstName!, guessEmployee.lastName!)// Get the employee name need to compare against
        
        // Loop through 6 buttons and apply UI changes
        for (index, button) in buttons.enumerated() {
            button.isUserInteractionEnabled = true
            let employee = results[index]
            button.id = index + 1
            button.employeeName = String(format: "%@ %@", employee.firstName!, employee.lastName!)
            button.compareName = guessName
            if let head = employee.headshot {
                button.setImage(url: head.url!)
            }
        }
        completion(guessName)
    }
    
    //MARK: - Fetch Employees For Patter("Matt") Mode
    func fetchWithSimilar(buttons: [FaceButton], employees: [Employee], pattern: String, completion: @escaping (_ compareName: String) -> Void) {
        var results = [Employee]()
        var duplicateTest = [String:Any]()
        var count: Int = 0
        
        // Loop only valid 6 times
        while count < self.numberPeople {
            let randomIndex = self.getRandom(count: employees.count)// Get random index number in the employee array
            let employee = employees[randomIndex]// Get random employee
            
            if let first = employee.firstName {
                if first.range(of: pattern, options: .caseInsensitive) != nil {// Find if pattern exist in the firstname
                    if let head = employee.headshot {// Remove people that doesn't have headshot
                        if head.url != nil {
                            if duplicateTest[employee.id!] == nil{// Prevent random pick same employee
                                duplicateTest[employee.id!] = employee.slug!
                                results.append(employee)
                                count += 1
                            }
                        }
                    }
                }
            }
        }
        
        let randomIndex = self.getRandom(count: results.count)// Get random index number in the employee array
        let guessEmployee = results[randomIndex]
        let guessName = String(format: "%@ %@", guessEmployee.firstName!, guessEmployee.lastName!)// Get the employee name need to compare against
        
        // Loop through 6 buttons and apply UI changes
        for (index, button) in buttons.enumerated() {
            button.isUserInteractionEnabled = true
            let employee = results[index]
            button.id = index + 1
            button.employeeName = String(format: "%@ %@", employee.firstName!, employee.lastName!)
            button.compareName = guessName
            if let head = employee.headshot {
                button.setImage(url: head.url!)
            }
        }
        completion(guessName)
    }
    
    //MARK: - Fetch Employees For Team Mode
    func fetchWithTeam(buttons: [FaceButton], employees: [Employee], completion: @escaping (_ compareName: String) -> Void) {
        var results = [Employee]()
        var duplicateTest = [String:Any]()
        var count: Int = 0
        
        // Loop only valid 6 times
        while count < self.numberPeople {
            let randomIndex = self.getRandom(count: employees.count)// Get random index number in the employee array
            let employee = employees[randomIndex]// Get random employee
            
            if let head = employee.headshot {// Remove people that doesn't have headshot
                if head.url != nil {
                    if duplicateTest[employee.id!] == nil{// Prevent random pick same employee
                        duplicateTest[employee.id!] = employee.slug!
                        if employee.jobTitle != nil {//Find employee who has a job title
                            results.append(employee)// Add selected employee to new array
                            count += 1
                        }
                    }
                }
            }
        }
        
        let randomIndex = self.getRandom(count: results.count)// Get random index number in the employee array
        let guessEmployee = results[randomIndex]
        let guessName = String(format: "%@ %@", guessEmployee.firstName!, guessEmployee.lastName!)// Get the employee name need to compare against
        
        // Loop through 6 buttons and apply UI changes
        for (index, button) in buttons.enumerated() {
            button.isUserInteractionEnabled = true
            let employee = results[index]
            button.id = index + 1
            button.employeeName = String(format: "%@ %@", employee.firstName!, employee.lastName!)
            button.compareName = guessName
            if let head = employee.headshot {
                button.setImage(url: head.url!)
            }
        }
        completion(guessName)
    }
    
    //MARK: - Fetch Employees For Reverse Mode
    func fetchWithReverse(buttons: [FaceButton], employees: [Employee], completion: (() -> ())?) {
        var results = [Employee]()
        var duplicateTest = [String:Any]()
        var count: Int = 0
        
        // Loop only valid 6 times
        while count < self.numberPeople {
            let randomIndex = self.getRandom(count: employees.count)// Get random index number in the employee array
            let employee = employees[randomIndex]// Get random employee
            
            if let head = employee.headshot {// Remove people that doesn't have headshot
                if head.url != nil {
                    if duplicateTest[employee.id!] == nil{// Prevent random pick same employee
                        duplicateTest[employee.id!] = employee.slug!
                        results.append(employee)
                        count += 1
                    }
                }
            }
        }
        
        let randomIndex = self.getRandom(count: results.count)// Get random index number in the employee array
        let guessEmployee = results[randomIndex]
        let guessName = String(format: "%@ %@", guessEmployee.firstName!, guessEmployee.lastName!)// Get the employee name need to compare against
        
        var findGuessName: Bool = false//Check if guessName has been set
        var tempButtonID: Int = 0//temp button id holder
        
        for (index, button) in buttons.enumerated() {
            button.isUserInteractionEnabled = true
            let employee = results[index]
            button.id = index + 1
            
            if index == 0 {
                tempButtonID = button.id
            }
            
            if let head = employee.headshot {//Change the next button employeeName if previous one is a guessName
                if findGuessName == true {
                    findGuessName = false
                    button.employeeName = guessName
                    button.compareName = guessName
                    button.setButtonTitle(text: guessName)
                }
                else {//Haven't found guessName match yet
                    button.employeeName = String(format: "%@ %@", employee.firstName!, employee.lastName!)
                    button.compareName = guessName
                    button.setButtonTitle(text: String(format: "%@ %@", employee.firstName!, employee.lastName!))
                }
                
                if guessName == String(format: "%@ %@", employee.firstName!, employee.lastName!) {//Found guessName match and prepare for update
                    button.compareName = guessName
                    findGuessName = true
                    button.setImage(url: head.url!)
                }
            }
            
            // If the guessname is last element in the array then replace first element employeename
            if index == buttons.count - 1 {
                if findGuessName == true {
                    for button in buttons {//TODO: Could be improved!
                        if button.id == tempButtonID {
                            button.employeeName = guessName
                            button.setButtonTitle(text: guessName)
                        }
                    }
                }
            }
        }
        completion!()
    }
    
    //MARK: - Helper
    func hintModeUpdateLogic(buttons: [FaceButton]) {
        for button in buttons {
            if button.compareName! != button.employeeName! && button.isEnabled == true {
                button.disableButton()
                break
            }
        }
    }
    
    private func getRandom(count: Int) -> Int {
        return Int(arc4random_uniform(UInt32(count)))
    }
}

//MARK: - API request
//TODO: Should i seperate this function from this class and file
extension NameGame {
    // Load JSON data from API
    func loadGameData() {
        
        var results = [Employee]()
        
        self.network.requestDataWith(urlStr: NetworkConstant.profileApi, completion: {(data, response, error) in
            if let err = error {
                if let del = self.delegate {
                    del.getData(employees: nil, numberData: 0, errorMsg: err)// Call delegate call back function
                }
            }
            else {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray else {return}
                    
                    // Parse and pack up the data with struct
                    for data in json {
                        let dictData = data as! Dictionary<String, Any>
                        let employee = Employee(jsonData: dictData)
                        results.append(employee)
                    }
                    
                    // Call delegate call back function
                    if let del = self.delegate {
                        del.getData(employees: results, numberData: self.numberPeople, errorMsg: nil)
                    }
                    
                } catch let jsonError {
                    print("Error with json: ", jsonError)
                }
            }
        })
    }
}
