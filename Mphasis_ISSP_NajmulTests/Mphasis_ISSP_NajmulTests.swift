//
//  Mphasis_ISSP_NajmulTests.swift
//  Mphasis_ISSP_NajmulTests
//
//  Created by Najmul Hasan on 11/30/17.
//  Copyright © 2017 Najmul Hasan. All rights reserved.
//

import XCTest
@testable import Mphasis_ISSP_Najmul

class Mphasis_ISSP_NajmulTests: XCTestCase {
    
    var sessionUnderTest: URLSession!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sessionUnderTest  = nil
        super.tearDown()
    }
    
    func testValidCallToApiWithASampleLatLon(){
        
        //given
        let url = URL(string: "http://api.open-notify.org/iss-pass.json?lat=-33.8634&lon=151.211")
        let promise = expectation(description: "Status code 200")
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            
            if let error = error {
                
                XCTFail("Error: \(error.localizedDescription)")
                return
            }else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if statusCode == 200 {
                    promise.fulfill()
                }else {
                    XCTFail("Status Code: \(statusCode)")
                }
            }
        }
        
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
