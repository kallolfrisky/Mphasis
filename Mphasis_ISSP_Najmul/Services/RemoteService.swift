//
//  RemoteService.swift
//  Mphasis_ISSP_Najmul
//
//  Created by Najmul Hasan on 12/4/17.
//  Copyright © 2017 Najmul Hasan. All rights reserved.
//

import Foundation
import UIKit

public class RemoteService {
    private var urlSession: URLSession!
    private var dataTask: URLSessionDataTask?

    public init() {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func fetchItems(from url: URL, with completion: @escaping ([AnyObject]) -> Void) {

    //Cancel previous ongoing call if any
    if dataTask != nil {
        dataTask?.cancel()
    }
    // enable the network indicator on the status bar to indicate to the user that a network process is running
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    // from the session we created, we initialize a URLSessionDataTask to handle the HTTP GET request.
    // the constructor of URLSessionDataTask takes in the URL that you constructed along with a completion handler to be called when the data task completed
        dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            // invoke the UI update in the main thread and hide the activity indicator to show that the task is completed
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard error == nil else {
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion([AnyObject]())
                return
            }
            
            var passTimes = [PassTimeObject]()
            do {
                if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                    // Get the results array
                    if response ["message"] as! String == "success" { //Check if it got the success message
                        if let array: AnyObject = response["response"] {
                            let pTimes = array as! [AnyObject]
                            passTimes = pTimes.map({ PassTimeObject(with: $0) })
                            
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
            
            completion (passTimes)
        })

        // all tasks start in a suspended state by default, calling resume() starts the data task
        dataTask?.resume()
  }
}
