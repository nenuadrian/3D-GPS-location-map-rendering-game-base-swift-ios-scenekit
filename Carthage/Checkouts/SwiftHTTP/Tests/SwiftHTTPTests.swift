//
//  SwiftHTTPTests.swift
//  SwiftHTTPTests
//
//  Created by Austin Cherry on 9/16/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//

import XCTest
import SwiftHTTP

class SwiftHTTPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRequest() {
        let expectation = self.expectation(description: "testGetRequest")
        
        do {
            let opt = try HTTP.GET("https://google.com", parameters: nil)
            opt.start { response in
                if response.error != nil {
                    XCTAssert(false, "Failure")
                }
                XCTAssert(true, "Pass")
                expectation.fulfill()
            }
        } catch {
            XCTAssert(false, "Failure")
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
	
	func testGetProgress() {
		let expectation1 = expectation(description: "testGetProgressFinished")
		let expectation2 = expectation(description: "testGetProgressIncremented")

		do {
			let opt = try HTTP.GET("http://photojournal.jpl.nasa.gov/tiff/PIA19330.tif", parameters: nil)
			var alreadyCheckedProgressIncremented: Bool = false
			opt.progress = { progress in
				if progress > 0 && !alreadyCheckedProgressIncremented {
					alreadyCheckedProgressIncremented = true
					XCTAssert(true, "Pass")
					expectation2.fulfill()
				}
			}
			opt.start { response in
				if response.error != nil {
					XCTAssert(false, "Failure")
				}
				XCTAssert(true, "Pass")
				expectation1.fulfill()
			}
		} catch {
			XCTAssert(false, "Failure")
		}

		waitForExpectations(timeout: 30, handler: nil)
	}
	
    func testOperationDependencies() {
        let expectation1 = expectation(description: "testOperationDependencies1")
        let expectation2 = expectation(description: "testOperationDependencies2")
        
        var operation1Finished = false
        
        let urlString1 = "http://photojournal.jpl.nasa.gov/tiff/PIA19330.tif" // (4.32 MB)
        let urlString2 = "http://photojournal.jpl.nasa.gov/jpeg/PIA19330.jpg" // (0.14 MB)
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        
        do {
            let opt1 = try HTTP.GET(urlString1, parameters: nil)
            opt1.onFinish = { response in
                if let err = response.error {
                    XCTFail("request1 failed: \(err.localizedDescription)")
                }
                operation1Finished = true
                expectation1.fulfill()
            }
            
            let opt2 = try HTTP.GET(urlString2, parameters: nil)
            opt2.onFinish = { response in
                if let err = response.error {
                    XCTFail("request2 failed: \(err.localizedDescription)")
                }
                XCTAssert(operation1Finished, "Operation 1 did not finish first")
                expectation2.fulfill()
            }
            
            opt2.addDependency(opt1)
            operationQueue.addOperation(opt1)
            operationQueue.addOperation(opt2)
            
        } catch {
            XCTAssert(false, "Failure")
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
}
