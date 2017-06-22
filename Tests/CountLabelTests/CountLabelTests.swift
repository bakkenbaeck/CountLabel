import Foundation
import XCTest
import CountLabel

class CountLabelTests: XCTestCase {
    func testCountLabel() {
        let expect = self.expectation(description: "fetch overview")
        
        let countLabel = CountLabel()
        countLabel.count(from: 0, to: 1, withDuration: 0.0) {
            XCTAssertEqual(countLabel.text ?? "", "1.0")
            expect.fulfill()
        }

        self.waitForExpectations(timeout: 5)
    }

    func testPrefix() {
        let expect = self.expectation(description: "fetch overview")

        let countLabel = CountLabel()
        countLabel.prefix = "At the next beep it will be: "
        countLabel.count(from: 0, to: 1, withDuration: 0.0) {
            XCTAssertEqual(countLabel.text ?? "", "At the next beep it will be: 1.0")
            expect.fulfill()
        }

        self.waitForExpectations(timeout: 5)
    }

    func testPostfix() {
        let expect = self.expectation(description: "fetch overview")

        let countLabel = CountLabel()
        countLabel.postfix = " seconds before universe implodes"
        countLabel.count(from: 0, to: 1, withDuration: 0.0) {
            XCTAssertEqual(countLabel.text ?? "", "1.0 seconds before universe implodes")
            expect.fulfill()
        }

        self.waitForExpectations(timeout: 5)
    }
}
