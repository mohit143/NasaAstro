//
//  PictureViewModelTests.swift
//  PictureViewModelTests
//
//  Created by Mohit Mathur on 01/12/21.
//

import XCTest
@testable import MohitMathurWalE

class PictureViewModelTests: XCTestCase {

    var sut: PictureViewModel!
    var mockAPIService: MockApiService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPIService = MockApiService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        mockAPIService = nil
        sut = nil
        try super.tearDownWithError()
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
    func testFetchPicture() {
        // Given
        mockAPIService.pictureData = Data()

        // When
        sut = PictureViewModel(serviceObject: mockAPIService)
        
        // Assert
        XCTAssert(mockAPIService!.isFetchPictureCalled)
    }
    
    func testParsingModel() {
        // Given
        let pictureData = StubGenerator().stubPicture()
        let decoder = JSONDecoder()
        do
        {
            let pictureObject = try decoder.decode(PictureModel.self, from: pictureData)
            XCTAssertEqual(pictureObject.title, "Space Station Silhouette on the Moon")
            XCTAssertEqual(pictureObject.explanation, "What's that unusual spot on the Moon? It's the International Space Station. Using precise timing, the Earth-orbiting space platform was photographed in front of a partially lit gibbous Moon last month. The featured composite, taken from Payson, Arizona, USA last month, was intricately composed by combining, in part, many 1/2000-second images from a video of the ISS crossing the Moon. A close inspection of this unusually crisp ISS silhouette will reveal the outlines of numerous solar panels and trusses.  The bright crater Tycho is visible on the upper left, as well as comparatively rough, light colored terrain known as highlands, and relatively smooth, dark colored areas known as maria.  On-line tools can tell you when the International Space Station will be visible from your area.")
            XCTAssertEqual(pictureObject.url, "https://apod.nasa.gov/apod/image/2112/IssMoon_McCarthy_960.jpg")
            XCTAssertEqual(pictureObject.hdurl, "https://apod.nasa.gov/apod/image/2112/IssMoon_McCarthy_1663.jpg")
            
        } catch {
            // deal with error from JSON decoding!
            fatalError("Data is nil")
        }
        
    }
    

}
class MockApiService: APIServiceProtocol {
    
    var isFetchPictureCalled = false
    
    var pictureData : Data!
    var completeClosure: ((Result<Data, Error>) -> Void)!
    
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        isFetchPictureCalled = true
        completeClosure = completionBlock
        
    }
    
    func fetchSuccess() {
        completeClosure(.success(pictureData))
    }
    
    func fetchFail(error: Error?) {
        completeClosure(.failure(error!))
    }
    
}
class StubGenerator {
    func stubPicture() -> Data {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return data
    }
}
