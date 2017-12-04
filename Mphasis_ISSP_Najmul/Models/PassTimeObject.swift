//
//  PassTimeObject.swift
//  Mphasis_ISSP_Najmul
//
//  Created by Najmul Hasan on 12/4/17.
//  Copyright © 2017 Najmul Hasan. All rights reserved.
//

import Foundation

class PassTimeObject: NSObject {
    
    public var duration: String?
    public var risetime: String?
    
    public init(with aObject: AnyObject){
        
        super.init()
        
        self.duration = DataOrganizer.formateDuration(aObject["duration"] as! Double)
        self.risetime = DataOrganizer.formateDateFromTimeStamp(aObject["risetime"] as! Double)
    }
}
