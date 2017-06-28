import UIKit
import CountLabel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let countLabel = CountLabel(frame: CGRect(x: (self.view.bounds.width * 0.5) - 22, y: 50, width: 100, height: 44))
        self.view.addSubview(countLabel)

        countLabel.count(from: 0, to: 10) {}

        let countLabel2 = CountLabel(frame: CGRect(x: (self.view.bounds.width * 0.5) - 22, y: 150, width: 100, height: 44))
        self.view.addSubview(countLabel2)

        countLabel2.count(from: 0, to: 100) {}

        let countLabel3 = CountLabel(frame: CGRect(x: (self.view.bounds.width * 0.5) - 22, y: 250, width: 100, height: 44))
        self.view.addSubview(countLabel3)

        countLabel3.count(from: 0, to: 1000) {}

        let countLabel4 = CountLabel(frame: CGRect(x: (self.view.bounds.width * 0.5) - 22, y: 350, width: 100, height: 44))
        self.view.addSubview(countLabel4)

        countLabel4.count(from: 0, to: 10000) {}

        let countLabel5 = CountLabel(frame: CGRect(x: (self.view.bounds.width * 0.5) - 22, y: 450, width: 100, height: 44))
        self.view.addSubview(countLabel5)

        countLabel5.count(from: 0, to: 100000) {}
    }
}
