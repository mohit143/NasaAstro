//
//  PictureSessionSlowTests.swift
//  MohitMathurWalETests
//
//  Created by Mohit Mathur on 06/12/21.
//

import XCTest
@testable import MohitMathurWalE

class PictureSessionSlowTests: XCTestCase {

    var sessionUnderTest: URLSession!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       try super.setUpWithError()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUnderTest = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: Our test cases
    // Asynchronous test: success fast, failure slow
    func testValidCallNasaApodGetsHTTPStatusCode200() {
        
        // given
        let url = URL(string: ApiUrls.nasaApodApi)
        
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            
            promise.fulfill()
        }
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
