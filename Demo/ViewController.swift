import UIKit
import CountLabel

class ViewController: UIViewController {

    lazy var countLabel: CountLabel = {
        let countLabel = CountLabel(frame: CGRect(x: 22 , y: 50, width: self.view.bounds.width - 44, height: 200))  //Why do i need self here?
        countLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 148, weight: 10)
        countLabel.textColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 20.0/255.0, blue: 147.0/255.0, alpha: 1.0)

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        numberFormatter.negativeSuffix = " kr"
        numberFormatter.positiveSuffix = " kr"

//        countLabel.numberFormatter = numberFormatter

        return countLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(countLabel)

        count()
    }

    @objc private func count() {
        countLabel.count(from: 0, to: 2500000) {
            self.perform(#selector(self.countBack), with: nil, afterDelay: 1.0)
        }
    }

    @objc private func countBack() {
        countLabel.count(from: 2500, to: 0) {
            self.perform(#selector(self.count), with: nil, afterDelay: 1.0)
        }
    }
}
