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
        
        let urlComponents = NSURLComponents(string: mainUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(loc.latitude)),
            URLQueryItem(name: "lon", value: String(loc.longitude))
        ]
        
        let remoteService = RemoteService()
        remoteService.fetchItems(from: urlComponents.url!) { passes in
            
            self.passTimes = passes
            
            //Switch to main thread and update table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        
        let passTime = passTimes [indexPath.row] as? PassTimeObject
        
//        cell.durationLabel.text = "Duration: " + (passTime?.duration)!
//         cell.risetimeLabel.text = "Date: " + (passTime?.risetime)!
        
        let dFormat = NSLocalizedString("Duration: %@", comment: "Duration of the pass") //Localization support
        cell.durationLabel.text = String.localizedStringWithFormat(dFormat, (passTime?.duration)!)
        
        let rFormat = NSLocalizedString("Date: %@", comment: "Date of the pass") //Localization support
        cell.risetimeLabel.text = String.localizedStringWithFormat(rFormat, (passTime?.risetime)!)
        
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
