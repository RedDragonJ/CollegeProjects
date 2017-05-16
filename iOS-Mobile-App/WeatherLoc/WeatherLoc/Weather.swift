//
//  Weather.swift
//  WeatherLoc
//
//  Created by James H Layton on 5/14/17.
//  Copyright © 2017 james. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Weather: NSObject
/**
 * This is a Weather class and handle between Backend data and front end UI
 * The variables in the class can be easy accessed by the front end
 * All data hanlde methods are private in this class and cannot be directly access it
 * This class also handle process of save data to CoreData
 */
{
    
    let weatherAttributeName = "userWeatherHistory" //CoreData table attribue
    var dataHelper: CoreDataHelper! //CoreData helper
    
    //Arrays for store to CoreData and return to user
    var userHistory: NSMutableArray?
    var weatherDataForController: NSMutableArray?
    
    //Temp store current data on memory
    var locationName: String?
    var locationCondition: String?
    var locationIconImageURL: String?
    var locationTempF: String?
    var locationDateTime: String?
    var locationHumidity: String?
    
    override init()
    {
        print("This is Weather")
        self.dataHelper = CoreDataHelper.sharedInstance
    }
    
    //MARK: - Parse JSON store on memory and CoreData
    func ParseJSONDataForStorage (dictionary: [String: AnyObject]) //Parse JSON data with input value
    {
        //TEST to see JSON data//
        //print(dictionary)
        ////////
        let current = dictionary["current"] as! NSDictionary //Parse current into dictionary
        let condition = current["condition"] as! NSDictionary //Parse condition intio dictionary
        let location = dictionary["location"] as! NSDictionary //Parse location into dictionary
        
        //Parse for weather icon URL and store on memory
        self.locationCondition = condition["text"] as? String
        let url = condition["icon"] as? String
        self.locationIconImageURL = "http:" + url!
        
        //Parse other need information and store on memory //Cast float into string so can be easy access and display
        self.locationTempF = String(describing: (current["temp_f"] as? Int)!)
        self.locationHumidity = String(describing: (current["humidity"] as? Int)!)
        self.locationDateTime = location["localtime"] as? String
        let city = location["name"] as? String
        let state = location["region"] as? String
        self.locationName = city! + ", " + state!
        
        //Call method to save data to CoreData
        self.SaveWeatherDataToCoreData()
    }
    
    //MARK: - Save to or Fetch from CoreData
    func FetchWeatherDataFromCoreData ()
    {
        self.weatherDataForController = NSMutableArray.init()
        if self.dataHelper.isCoreDataEmpty() //Check if CoreData has data
        {
            print("Cannot fetch from CoreData because it's empty !!!")
        }
        else
        {
            do {
                let storyResults = try dataHelper.getContext().fetch(dataHelper.FetchObject()) //Try to fetch raw data from CoreData
                if storyResults.count > 0 //Check if fetch result available
                {
                    for result in storyResults as! [NSManagedObject] //Search through raw data and cast them to NSManagedObject
                    {
                        if let arr = result.value(forKey: weatherAttributeName) as? NSMutableArray //Get data and cast to NSMutableArray
                        {
                            self.weatherDataForController = arr //Assign the usable data to var on memory
                        }
                    }
                }
            }
            catch
            {
                print("Something wrong with CoreData's data !!!!")
                
            }
        }
    }
    
    //MARK: - Check duplicate of CoreData before save
    func CheckDuplicateOfCoreData (dicts: NSMutableArray) -> Bool
    {
        //TEST////////////
        //print(dicts.count)
        ///////////////////
        
        var count: Int = 0
        
        for dict in dicts //Search through CoreData data array
        {
            //Parse all the information from each element
            let tempDict = dict as! [String : AnyObject]
            let tempDataTime = tempDict["historydatetime"] as? String
            
            //Format the current date and saved date, then compare
            let currentDate = DateFormatter()
            let oldDate = DateFormatter()
            currentDate.dateFormat = "yyyy-MM-dd HH:mm"
            oldDate.dateFormat = "yyyy-MM-dd HH:mm"
            
            let current = currentDate.date(from: self.locationDateTime!)!
            let old = oldDate.date(from: tempDataTime!)!
            
            if current == old
            {
                print("Found duplicate !!!")
                count += 1 //If find duplicate in CoreData then increase count
            }
        }
        
        if count > 0
        {
            return true //Found duplicate
        }
        else
        {
            return false //Not found duplicate
        }
    }
}

//MARK: - Private methods
private extension Weather {
    
    //MARK: - Save data to the CoreData
    func SaveWeatherDataToCoreData ()
    {
        self.userHistory = NSMutableArray.init()
        
        let historyDictionary = ["historyname" : self.locationName!, "historyimage" : self.locationIconImageURL!, "historycondition" : self.locationCondition!, "historytempf" : self.locationTempF!, "historydatetime" : self.locationDateTime!, "historyhumidity" : self.locationHumidity!] //Format data and ready to be add into array
        
        //TEST//////////////////////
        //print(historyDictionary)
        //dataHelper.DeleteAllData()
        //dataHelper.saveContext()
        ////////////////////////////
        
        if self.dataHelper.isCoreDataEmpty() //Check if CoreData is empty
        {
            //First time add data into CoreData
            self.userHistory?.add(historyDictionary) //Add dictionary into array for insert
            self.dataHelper.InsertNewObject().setValue(self.userHistory!, forKey: self.weatherAttributeName) //Use CoreData helper to insert data to PersistentContainer
            self.dataHelper.saveContext() //Save data to CoreData
        }
        else
        {
            self.userHistory = self.weatherDataForController!
        
            self.FetchWeatherDataFromCoreData() //Fetch data from CoreData
            let isDataExisted = self.CheckDuplicateOfCoreData(dicts: self.userHistory!) //Check for data duplicates
            
            if isDataExisted == false //Add new data to CoreData if no duplicate found
            {
                if self.userHistory!.count == 5
                {
                    //The tableview only allow 5 elements, so if CoreData's data already has 5.
                    //Remove the oldest data and append new data to the end of array
                    self.userHistory?[0] = self.userHistory![1]
                    self.userHistory?[1] = self.userHistory![2]
                    self.userHistory?[2] = self.userHistory![3]
                    self.userHistory?[3] = self.userHistory![4]
                    self.userHistory?[4] = historyDictionary
                    
                    self.dataHelper.InsertNewObject().setValue(self.userHistory!, forKey: self.weatherAttributeName) //Use CoreData helper to insert data to PersistentContainer
                }
                else
                {
                    //Append the data to the end of array
                    self.userHistory?.add(historyDictionary)
                    self.dataHelper.InsertNewObject().setValue(self.userHistory!, forKey: self.weatherAttributeName) //Use CoreData helper to insert data to PersistentContainer
                }
                self.dataHelper.saveContext() //Save to the CoreData
            }
            else
            {
                //If found duplicate then do nothing
            }
        }
    }
}
