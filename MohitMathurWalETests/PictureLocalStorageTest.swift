//
//  PictureLocalStorageTest.swift
//  MohitMathurWalETests
//
//  Created by Mohit Mathur on 06/12/21.
//

import XCTest
import CoreData
@testable import MohitMathurWalE

class PictureLocalStorageTest: XCTestCase {

    /*creating a LocalDbManager object, we will use this object to test operations like insert, update & delete*/
      var coreDataManager: LocalDbManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       try super.setUpWithError()
       coreDataManager = LocalDbManager.sharedManager
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    /*this test case test for the proper initialization of CoreDataManager class :)*/
        func test_init_coreDataManager(){
          
          let instance = LocalDbManager.sharedManager
          /*Asserts that an expression is not nil.
           Generates a failure when expression == nil.*/
          XCTAssertNotNil( instance )
        }
      
      /*test if NSPersistentContainer(the actual core data stack) initializes successfully
       */
      func test_coreDataStackInitialization() {
        let coreDataStack = LocalDbManager.sharedManager.persistentContainer
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( coreDataStack )
      }
    
    /*This test case inserts a picture record*/
        func testCreatePicture() {
          
          //Given the picture model
            let pictureModel = PictureModel(date: "2021-12-06",explanation: "What's that unusual spot on the Moon? It's the International Space Station. Using precise timing, the Earth-orbiting space platform was photographed in front of a partially lit gibbous Moon last month. The featured composite, taken from Payson, Arizona, USA last month, was intricately composed by combining, in part, many 1/2000-second images from a video of the ISS crossing the Moon. A close inspection of this unusually crisp ISS silhouette will reveal the outlines of numerous solar panels and trusses.  The bright crater Tycho is visible on the upper left, as well as comparatively rough, light colored terrain known as highlands, and relatively smooth, dark colored areas known as maria.  On-line tools can tell you when the International Space Station will be visible from your area.", hdurl: "https://apod.nasa.gov/apod/image/2112/IssMoon_McCarthy_1663.jpg", mediaType: "image",serviceVersion: "v1",title: "Space Station Silhouette on the Moon", url: "https://apod.nasa.gov/apod/image/2112/IssMoon_McCarthy_960.jpg")
            
          let picture = coreDataManager.savePicture(pictureModel: pictureModel)
          
          /*Asserts that an expression is not nil.
           Generates a failure when expression == nil.*/
          XCTAssertNotNil( picture )
        }
    
    /*This test case fetches all picture records*/
        func testFetchByDate() {
          
        let date = "2021-12-06"
        let title = "Space Station Silhouette on the Moon"
          //get pictureRecord already saved
          
            let result = coreDataManager.fetchPicture(date: date)
          
          //Assert return numbers of todo items
          //Asserts that two optional values are equal.
            XCTAssertEqual(result?.title, title)
            XCTAssertEqual(result?.date, date)
        }
}
