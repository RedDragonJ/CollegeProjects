//
//  CoreDataHelper.swift
//  WeatherLoc
//
//  Created by James H Layton on 5/14/17.
//  Copyright © 2017 james. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper
/**
 * CoreDataHelper simply provides easy methods to manipulate the data between memory and CoreData
 */
{
    
    static let sharedInstance = CoreDataHelper()
    private let userEntityName = "WeatherData" //CoreData entity's name
    
    init()
    {
        print("This is CoreDataHelper");
    }
    
//MARK: - Save Context
    func saveContext ()
    {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
//MARK: - Get NSManagedObjectContext
    func getContext () -> NSManagedObjectContext
    {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
//MARK: - Insert new object to CoreData
    func InsertNewObject () -> NSManagedObject
    {
        return NSEntityDescription.insertNewObject(forEntityName: self.userEntityName, into: getContext())
    }
    
//MARK: - Fetch object from CoreData
    func FetchObject () -> NSFetchRequest<NSFetchRequestResult>
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.userEntityName)
        request.returnsObjectsAsFaults = false
        return request
    }
    
//MARK: - Check if the CoreData is empty
    func isCoreDataEmpty () -> Bool
    {
        do
        {
            let weatherResult = try getContext().fetch(FetchObject())
            
            if weatherResult.count > 0
            {
                print(" - CoreData is not empty")
                return false
            }
            else
            {
                print(" - CoreData is empty")
                return true
            }
        }
        catch
        {
            //Error
            return false
        }
    }
    
//MARK: - Delete all data from CoreData (Use for reset database)
    func DeleteAllData()
    {
        let managedContext = getContext()
        
        do
        {
            let storyResults = try managedContext.fetch(FetchObject())
            
            for managedObject in storyResults
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Story error : \(error) \(error.userInfo)")
        }
    }

}






