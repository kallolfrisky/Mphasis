//
//  DataOrganizer.swift
//  Mphasis_ISSP_Najmul
//
//  Created by Najmul Hasan on 11/30/17.
//  Copyright © 2017 Najmul Hasan. All rights reserved.
//

import Foundation

class DataOrganizer: NSObject {

    //Formate timestap to human readable date
   public static func formateDateFromTimeStamp(_ timeStamp: Double)-> String{
        
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that we want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM dd, yyyy     HH:mm" //Specify format that is needed
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    //Formate time interval to MM:SS rather than raw seconds
    public static func formateDuration(_ duration: Double)-> String{
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]  //If the duration is longer then add .hour first
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let formattedDuration = formatter.string(from: duration)
        
        return formattedDuration!
    }
}
