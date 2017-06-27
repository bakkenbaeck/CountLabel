import UIKit

open class CountLabel: UILabel {
    open var postfix: String?
    open var prefix: String?

    var currentValue: Int {
        set {
        }
        get {
            if self.progress >= self.totalTime {

                return self.endValue
            }

            let percent: Double = self.progress / self.totalTime

            let updateVal = 1.0-pow((1.0 - percent), 3.0)

            return Int(Double(self.startValue) + (updateVal * Double(self.endValue - self.startValue)))
        }
    }

    fileprivate var startValue = 0
    fileprivate var endValue = 0
    fileprivate var progress: TimeInterval = 0.0
    fileprivate var lastUpdate: TimeInterval = 0.0
    fileprivate var totalTime: TimeInterval = 0.0
    fileprivate var easingRate: CGFloat = 0.0

    fileprivate var timer: CADisplayLink?

    private var completion: ((Void) -> Void)?

    open func count(from startValue: Int, to endValue: Int, withDuration duration: Double = 2.0, completion: @escaping(Void) -> Void) {
        self.completion = completion

        self.startValue = startValue
        self.endValue = endValue

        self.timer?.invalidate()
        self.timer = nil

        if duration <= 0.0 {
            self.setTextValue(self.endValue)
            self.completion?()
        }

        self.easingRate = 3.0
        self.progress = 0
        self.totalTime =  duration
        self.lastUpdate = Date.timeIntervalSinceReferenceDate

        let timer = CADisplayLink(target: self, selector: #selector(updateValue))
        timer.preferredFramesPerSecond = 24
        timer.add(to: .current, forMode: .defaultRunLoopMode)

        self.timer = timer
    }

    func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        self.progress = self.progress + (now - self.lastUpdate)

        self.lastUpdate = now

        if self.progress >= self.totalTime {
            self.timer?.invalidate()
            self.timer = nil
            self.progress = self.totalTime
        }

        self.setTextValue(self.currentValue)

        if self.progress == self.totalTime {
            self.completion?()
        }
    }

    private func setTextValue(_ value: Int) {
        self.text = "\(self.prefix ?? "")\(value)\(self.postfix ?? "")"
    }
}
