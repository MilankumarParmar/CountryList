import XCTest
@testable import CountryList
class CountryListTests: XCTestCase {
    var vc: ViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        vc = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testSuccessfulNetworkCall() {
        // Mock successful network response
        vc = ViewController()
        let mockData = [Country(abbreviation: nil, capital: nil, currency: nil, name: "USA", phone: nil, population: 330000000, media: nil, id: 12)]
        let mockNetworkService = MockNetworkService(result: .success(mockData))
        vc.dataRepository = DataRepository(networkService: mockNetworkService)

        vc.getCountryList()

        XCTAssertEqual(vc.data.count, 1)
        XCTAssertEqual(vc.filteredData.count, 1)
        XCTAssertEqual(vc.filteredData.first?.name, "USA")
    }

    // Test failed network call
    func testFailedNetworkCall() {
        vc = ViewController()
        let mockNetworkService = MockNetworkService(result: .failure(NSError(domain: "Network Error", code: -1001, userInfo: nil)))
        vc.dataRepository = DataRepository(networkService: mockNetworkService)

        vc.getCountryList()

        XCTAssertEqual(vc.data.count, 0)
        XCTAssertEqual(vc.filteredData.count, 0)
        // You might want to assert that an error message is displayed to the user here
    }
    
    func testSearchByName() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.loadViewIfNeeded()
        let mockData = [
            Country(abbreviation: nil, capital: nil, currency: nil, name: "USA", phone: nil, population: 330000000, media: nil, id: 12),
            Country(abbreviation: nil, capital: nil, currency: nil, name: "Canada", phone: nil, population: 38000000, media: nil, id: 12),
        ]
        vc.data = mockData
        vc.filteredData = mockData
        
        vc.searchBar(_: vc.searchBar, textDidChange: "Canada")

        XCTAssertEqual(vc.filteredData.count, 1)
        XCTAssertEqual(vc.filteredData.first?.name, "Canada")
    }
    
}


class MockNetworkService: NetworkServiceProtocol {
    
    let result: Result<[Country], Error>
    
    init(result: Result<[Country], Error>) {
        self.result = result
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<[Country], Error>) -> Void) {
        completion(result)
    }
}
