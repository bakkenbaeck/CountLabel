import Foundation
import XCTest
import CountLabel

class CountLabelTests: XCTestCase {
    func testCountLabel() {
        let expect = self.expectation(description: "fetch overview")
        
        let countLabel = CountLabel()
        countLabel.count(from: 0, to: 1, withDuration: 0.0) {
            XCTAssertTrue(countLabel.text == "1.0")
            expect.fulfill()
        }

        self.waitForExpectations(timeout: 5)
    }
}
