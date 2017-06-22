import UIKit
import CountLabel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let countLabel = CountLabel(frame: CGRect(x: (self.view.bounds.width * 0.5) - 22, y: (self.view.bounds.height * 0.5) - 50, width: 100, height: 44))
        self.view.addSubview(countLabel)

        countLabel.count(from: 0, to: 100)
    }
}
