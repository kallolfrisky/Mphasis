//
//  ViewController.swift
//  Mphasis_ISSP_Najmul
//
//  Created by Najmul Hasan on 11/30/17.
//  Copyright © 2017 Najmul Hasan. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Decleare location manager for pulling current location
    let locationManager = CLLocationManager()
    
    //Create a urlsession with default configuration
    var defaultSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    var passTimes = [AnyObject]()
    let mainUrl = "http://api.open-notify.org/iss-pass.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //Configure the location manager for accuracy, invoke delegation and start updating location if permission is available
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    //Fetch data by service call using DataTask operation, we could make it from a seperate object, here its simple enough
    func fetchData(with loc: CLLocationCoordinate2D){
        
        //Cancel previous ongoing call if any
        if dataTask != nil {
            dataTask?.cancel()
        }
        // enable the network indicator on the status bar to indicate to the user that a network process is running
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let urlComponents = NSURLComponents(string: mainUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(loc.latitude)),
            URLQueryItem(name: "lon", value: String(loc.longitude))
        ]
        
        // from the session we created, we initialize a URLSessionDataTask to handle the HTTP GET request.
        // the constructor of URLSessionDataTask takes in the URL that you constructed along with a completion handler to be called when the data task completed
        dataTask = defaultSession.dataTask(with: urlComponents.url!) {
            data, response, error in
            // invoke the UI update in the main thread and hide the activity indicator to show that the task is completed
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            // if HTTP request is successful you call updateSearchResults(_:) which parses the response NSData into Tracks and updates the table view
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.processRawData(data) //Serialize the raw data
                }
            }
        }
        // all tasks start in a suspended state by default, calling resume() starts the data task
        dataTask?.resume()
    }
    
    //Serialize the JSON data to make some Dictionary object
    func processRawData(_ data: Data?) {
        passTimes.removeAll() //Clear array
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                // Get the results array
                if response ["message"] as! String == "success" { //Check if it got the success message
                    if let array: AnyObject = response["response"] {
                        passTimes = array as! [AnyObject]
                    } else {
                        print("Results key not found in dictionary")
                    }
                }
                
            } else {
                print("JSON Error") //Error found
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)") //Localized error
        }
        
        //Switch to main thread and update table view
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ISSPCell", for: indexPath) as! ISSPCell
        
        let passTime = passTimes [indexPath.row] as? [String : Any]
        let duration = passTime!["duration"] as! Double
        let riseTime = passTime!["risetime"] as! Double
        
        cell.durationLabel.text = String.init(format: "Duration: \(DataOrganizer.formateDuration(duration))")
        cell.risetimeLabel.text = String.init(format: "Date: \(DataOrganizer.formateDateFromTimeStamp(riseTime))")
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
    
    //We are not handling details operation here
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    //On debug are press the location icon to simulate the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        fetchData(with: locValue)
    }
}
