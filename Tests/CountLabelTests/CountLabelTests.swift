import Foundation
import XCTest
import CountLabel

class CountLabelTests: XCTestCase {

    func testCountLabel() {
        let expect = self.expectation(description: "Label changes count")

        let countLabel = CountLabel()
        countLabel.count(from: 0, to: 1, withDuration: 0.0) {
            XCTAssertEqual(countLabel.text ?? "", "1")
            expect.fulfill()
        }

        self.waitForExpectations(timeout: 5)
    }

    func testNumberFormatter() {
        let expect = self.expectation(description: "Label uses numberformat")

        let countLabel = CountLabel()

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        numberFormatter.negativeSuffix = " kr"
        numberFormatter.positiveSuffix = " kr"

        countLabel.numberFormatter = numberFormatter

        countLabel.count(from: 0, to: 1000000, withDuration: 0.0) {
            XCTAssertEqual(countLabel.text ?? "", "1 000 000 kr")
            expect.fulfill()
        }

        self.waitForExpectations(timeout: 5)
    }
}
