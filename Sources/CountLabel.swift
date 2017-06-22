import UIKit

open class CountLabel: UILabel {
    open var postfix: String?
    open var prefix: String?

    var currentValue: Int {
        set {

        }
        get {
            if self.progress >= self.totalTime {

                return Int(self.endValue)
            }

            let percent = CGFloat(self.progress / self.totalTime)

            return Int(self.startValue + (percent * (self.endValue - self.startValue)))
        }
    }

    fileprivate var animationDuration = 0.2
    fileprivate var startValue: CGFloat = 0.0
    fileprivate var endValue: CGFloat = 0.0
    fileprivate var progress: TimeInterval = 0.0
    fileprivate var lastUpdate: TimeInterval = 0.0
    fileprivate var totalTime: TimeInterval = 0.0
    fileprivate var easingRate: CGFloat = 0.0

    fileprivate var timer: CADisplayLink?

    open func count(from startValue: CGFloat, to endValue: CGFloat, withDuration duration: Double = 2.0) {
        self.startValue = startValue
        self.endValue = endValue

        self.timer?.invalidate()
        self.timer = nil

        self.easingRate = 3.0
        self.progress = 0
        self.totalTime = duration
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



        self.text = "\(self.prefix ?? "")\(self.currentValue)\(self.postfix ?? "")"
    }
}
