//
//  WeatherMainController.swift
//  WeatherLoc
//
//  Created by James H Layton on 5/12/17.
//  Copyright © 2017 james. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WeatherMainController: WeatherBaseController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate,UITableViewDataSource
/**
 * This is the main front end UIViewController
 * It handles all UI and front end activities
 * Map and location services are also part of this
 */
{
    //Map outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    //Location manger
    let manager = CLLocationManager()
    
    //API
    let api = APIManager.sharedManager
    
    //Weather object
    var weather: Weather!
    var userLocation: CLLocation!
    var locationName: String?
    
    //Map data
    var city: String?
    var state: String?
    var country: String?
    var latitude: String?
    var longitude: String?
    
    var tableViewSign: UILabel!
    
    var isSignViewEnabled: Bool!
    var needUpdateTableView: Bool!
    var isAPICalled: Bool!

//MARK: - Life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("Weather Main View Controller")
        self.tableView.backgroundColor = UIColor.clear
        self.mapView.delegate = self
        
        //Init vars
        self.city = String.init()
        self.state = String.init()
        self.country = String.init()
        self.latitude = String.init()
        self.longitude = String.init()
        
        self.needUpdateTableView = false //Turn off button update boolean
        self.isAPICalled = false
        
        self.weather = Weather.init() //Init weather class
        self.weather.FetchWeatherDataFromCoreData() //Fetch Data from weather class which from CoreData
        
        self.tableView.register(UINib(nibName: WeatherTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.cellIdentifier())
        
        if self.weather.weatherDataForController!.count == 0
        { //If the CoreData has no Data then create sign to notify user why there is no table view
            self.isSignViewEnabled = true
            
            self.tableViewSign = UILabel.init()
            self.tableViewSign.frame = CGRect.init(x: self.tableView.frame.width/4, y: self.tableView.frame.height/4, width: self.tableView.frame.width/2, height: 100)
            self.tableViewSign.text = "No History Data"
            self.tableViewSign.textAlignment = NSTextAlignment.center
            self.tableViewSign.font = UIFont.boldSystemFont(ofSize: 18)
            self.tableViewSign.textColor = UIColor.white
            self.tableView.addSubview(tableViewSign)
        }
        else
        {
            self.isSignViewEnabled = false
        }
        
        //Methods must be called once
        self.DisableUI()
        ShowActivityIndicator()
        self.DisableMapUserInteraction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.CheckCurrentLocation() //Check user current location
        self.SetUpUI() //Setup some UI
        self.AdjustUI() //Adjust some UI
    }
    
    //MARK: - Buttons
    @IBAction func RefreshButtonClieck (sender: Any)
    { //Button for refresh location and tableview upon user request
        if self.isSignViewEnabled == true
        {
            self.tableViewSign.removeFromSuperview()
            self.isSignViewEnabled = false
        }
        self.manager.startUpdatingLocation()
        self.needUpdateTableView = true
        self.isAPICalled = false
    }
    
    //MARK: - Table view methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected + \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x:0, y:0, width:10, height:5))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x:0, y:0, width:10, height:5))
        returnedView.backgroundColor = UIColor.clear
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.weather.weatherDataForController!.count > 0
        {
            return WeatherTableViewCell.cellHeight()
        }
        else
        {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.weather.weatherDataForController!.count > 0
        {
            return self.weather.weatherDataForController!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView() //remove unuse tableview part
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellIdentifier(), for: indexPath) as! WeatherTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none //Remove tableview seperator
        
        if self.weather.weatherDataForController!.count > 0
        { //Set up and update the UI for display data if data exist
            let dictForCell = self.weather.weatherDataForController![(self.weather.weatherDataForController!.count-1)-indexPath.row] as! [String: AnyObject]
            cell.SetImage(imageURLString: (dictForCell["historyimage"] as? String)!)
            let tempDateTime = dictForCell["historydatetime"] as? String
            cell.dateTime.text = self.ConvertDateTime(dateTime: tempDateTime!)
            cell.name.text = dictForCell["historyname"] as? String
            let temperatureF = dictForCell["historytempf"] as? String
            cell.tempF.text =  temperatureF! + "°F"
            let tempHumidity = dictForCell["historyhumidity"] as? String
            cell.humidity.text = "Humidity: " + tempHumidity!
            cell.condition.text = dictForCell["historycondition"] as? String
        }
         
         return cell
    }
    
    //MARK: - Location methods
    func DisableMapUserInteraction ()
    {
        self.mapView.isZoomEnabled = false; //Disable map zoom
        self.mapView.isScrollEnabled = false; //Disable map scroll
        self.mapView.isUserInteractionEnabled = false; //Disable map user interaction
    }
    
    func CheckCurrentLocation()
    {
        self.manager.delegate = self //Assign delegate to viewcontroller
        self.manager.desiredAccuracy = kCLLocationAccuracyBest //Increase accuraccy of the location
        self.manager.requestWhenInUseAuthorization() 
        self.manager.startUpdatingLocation() //Start to updating location to map
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locations.count > 0
        {
            let location = locations[0]
            
            //save latitude and longitude for API usage
            self.latitude = String(location.coordinate.latitude)
            self.longitude = String(location.coordinate.longitude)
            self.userLocation = location
            
            if self.userLocation != nil //If location is exist then stop automatically update location
            {
                self.manager.stopUpdatingLocation()
            }
            
            //Call API///////////
            if self.isAPICalled == false
            {
                self.MakeAPICallForWeatherData()
                self.isAPICalled = true
            }
            ///////////////////////
            
            //Create component for map
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
            let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
            self.mapView.setRegion(region, animated: false)
            
            //Display current location on map
            self.mapView.showsUserLocation = true
        }
        else
        {
            print("Cannnot find location !!!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if CLLocationManager.locationServicesEnabled() //Check if location service available on device
        {
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied //Check if app can access location through device
            {
                ShowQuiAppAlertView(inputController: self, warningType: "ERROR", msg: "Please allow this app to use location service in device Settings")
            }
        }
        else
        {
            ShowQuiAppAlertView(inputController: self, warningType: "ERROR", msg: "Please enable location service on your device")
        }
    }
    
    func SetCurrentLocation()
    {
        //Use locaion to find actual address for display current data
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.userLocation) { (placemarks, error) -> Void in
            if error != nil {
                print("Error getting location: \(String(describing: error))")
            } else {
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                self.UpdateMapUI(localName: placeMark!)
            }
        }
    }
    
    //MARK: - Map methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? //add the new annotion instead default annotation
    {
        let annotationReuseId = "Place"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView?.annotation = annotation
        }
        
        anView?.image = UIImage(named: "annotation")
        anView?.centerOffset = CGPoint(x:0, y:-15); //Move annotation image up
        anView?.backgroundColor = UIColor.clear
        anView?.canShowCallout = false
        return anView
    }
    
    //MARK: - Update UI methods
    func UpdateMapUI (localName: CLPlacemark!) //Update map related UI component
    {
        HideActivityIndicator()
        self.MakeAPICallForWeatherIcon(url: self.weather.locationIconImageURL!)
        let tempFC = self.weather.locationTempF! + "°F  "
        self.weatherStatus.text = tempFC
        self.weatherStatus.text?.append(localName.locality!)
        self.EnableUI()
    }
 
    //MARK: - Helper methods
    func EnableUI () //Enable UI
    {
        UIView.animate(withDuration: 1.0, animations: {void in
            self.mapView.alpha = 1.0
            self.iconImage.alpha = 1.0
            self.weatherStatus.alpha = 1.0
            self.refreshButton.alpha = 1.0
        })
        self.tableView.isUserInteractionEnabled = true
        self.refreshButton.isUserInteractionEnabled = true
    }
    
    func SetUpUI () //Set up UI
    {
        self.iconImage.layer.masksToBounds = true
        self.iconImage.layer.cornerRadius = 15
        self.iconImage.clipsToBounds = true
        
        self.weatherStatus.layer.masksToBounds = true
        self.weatherStatus.layer.cornerRadius = 15
        self.weatherStatus.clipsToBounds = true
    }
    
    func AdjustUI () //Adjust UI
    {
        //Map
        self.mapView.layer.borderWidth = 3.0
        self.mapView.layer.masksToBounds = true
        self.mapView.layer.borderColor = (UIColor.init(red: 255.0/255, green: 250.0/255, blue: 205.0/255, alpha: 1.0)).cgColor
        self.mapView.layer.cornerRadius = 10
        self.mapView.clipsToBounds = true
        
        //TableView
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func DisableUI () //Disable UI
    {
        self.mapView.alpha = 0
        self.iconImage.alpha = 0
        self.weatherStatus.alpha = 0
        self.refreshButton.alpha = 0
        self.refreshButton.isUserInteractionEnabled = false
        self.tableView.isUserInteractionEnabled = false
    }
    
    func ConvertDateTime (dateTime: String?) -> String //Convert Data and time to 12 hrs, original is 24 hrs
    {
        var normalHour: Int?
        var newDateTime: String?
        
        let stringArr = dateTime!.components(separatedBy: " ")
        let hourlyArr = stringArr[1].components(separatedBy: ":")
        let hour = Int(hourlyArr[0])
        
        if (hour! < 12 && hour! >= 0) || hour! == 24
        {
            if hour! == 24 || hour! == 0
            {
                normalHour = 12
                newDateTime = stringArr[0] + " " + String(normalHour!) + ":" + hourlyArr[1] + " am"
            }
            else
            {
                newDateTime = stringArr[0] + " " + String(hour!) + ":" + hourlyArr[1] + " am"
            }
        }
        else if hour! >= 12 && hour! < 24
        {
            if hour! == 12 {
                normalHour = 12
            } else if hour! == 13 {
                normalHour = 1
            } else if hour! == 14 {
                normalHour = 2
            } else if hour! == 15 {
                normalHour = 3
            } else if hour! == 16 {
                normalHour = 4
            } else if hour! == 17 {
                normalHour = 5
            } else if hour! == 18 {
                normalHour = 6
            } else if hour! == 19 {
                normalHour = 7
            } else if hour! == 20 {
                normalHour = 8
            } else if hour! == 21 {
                normalHour = 9
            } else if hour! == 22 {
                normalHour = 10
            } else if hour! == 23 {
                normalHour = 11
            }
            
            newDateTime = stringArr[0] + " " + String(normalHour!) + ":" + hourlyArr[1] + " pm"
        }
        
        return newDateTime!
    }
}

//MARK: - Private methods
private extension WeatherMainController {
    func MakeAPICallForWeatherData () //API call to download data from Http
    {
        let absolutePin = (self.latitude! + "," + self.longitude!) as String
        self.api.DownloadWeatherData(location: absolutePin, completion: {(data) in
            self.SetCurrentLocation()
            self.weather.ParseJSONDataForStorage(dictionary: data)
            
            if self.needUpdateTableView == true
            {
                print("--- Update table view")
                self.weather.FetchWeatherDataFromCoreData()
                self.tableView.reloadData()
                self.needUpdateTableView = false
            }
        })
    }
    
    func MakeAPICallForWeatherIcon (url: String) //Downaload weather condition icon
    {
        self.api.DownloadImageData(urlString: url, completion: {(data) in
            self.iconImage.image = UIImage.init(data: data!) //Assign new image to UI
        })
    }
}






