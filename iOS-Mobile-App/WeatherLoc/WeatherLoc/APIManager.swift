//
//  APIManager.swift
//  WeatherLoc
//
//  Created by James H Layton on 5/13/17.
//  Copyright © 2017 james. All rights reserved.
//

import Foundation

class APIManager: NSObject
/**
 * This is the API class to handle all the internet connections
 * All methods in the are processed in background thread so they will not interrupt the front end process
 * All methods will return downloaded data to front end in main thread
 */
{
    
    static let sharedManager = APIManager()
    
    let weatherURL: String = "http://api.apixu.com/v1/current.json?key=14d16d89f42b41259ee30640171405&q=" //Partial URL for API call
    
    //Session data task var
    var task: URLSessionDataTask?
    
    //MARK: - Download weather data from API
    func DownloadWeatherData (location: String?, completion: @escaping (_ weathers: [String: AnyObject]) -> ()) //Main API method with input string and completion block to return data
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { //Put API call in the background thread so it will not interrupt with front end UI actions
            let urlAddress = self.weatherURL + location! //Create usable string URL address
            
            let config = URLSessionConfiguration.default // Session Configuration
            let session = URLSession(configuration: config) // Load configuration into Session
            
            let url = URL(string: urlAddress)! //Create URL with string address
            
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error != nil //If there is error while dowaloading the data
                {
                    print(error!.localizedDescription) //Display the reason of this error
                }
                else //If there is no error
                {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] //Try to convert raw data into JSON
                        {
                            DispatchQueue.main.async { //Call main thread to work with completionhandler
                                completion(json as [String: AnyObject]) //Pass the JSON data to viewcontroller
                            }
                        }
                    }
                    catch
                    {
                        print("Error while in JSONSerialization !!!")
                    }
                }
            })
            
            //Run task
            task.resume()
        }
    }
    
    //MARK: - Download image icon for weather
    func DownloadImageData (urlString: String?, completion: @escaping (_ imageData: Data?) -> ())
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { //Put API call in the background thread so it will not interrupt with front end UI actions
            
            let url = URL(string: urlString!)! //Create URL with string address
            
            let task = URLSession.shared.dataTask(with: url) { (responseData, responseUrl, error) -> Void in
                if let data = responseData { // if responseData is not null
                    DispatchQueue.main.async(execute: { () -> Void in //Call main thread to work with image data
                        completion(data) ////Pass the JSON data to viewcontroller
                    })
                }
            }
            
            // Run task
            task.resume()
        }
    }
}








