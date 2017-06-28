import UIKit

open class CountLabel: UILabel {

    public typealias VoidCompletionBlock = (() -> ())?

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

            let updateVal = 1.0-pow(CGFloat(1.0 - percent), self.easingRate)

            return Int(CGFloat(self.startValue) + (updateVal * CGFloat(self.endValue - self.startValue)))
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

    open func count(from startValue: Int, to endValue: Int, withDuration duration: Double = 2.0, completion: VoidCompletionBlock) {
        self.completion = completion

        self.startValue = startValue
        self.endValue = endValue

        self.timer?.invalidate()
        self.timer = nil

        if duration <= 0.0 {
            self.setTextValue(self.endValue)
            self.completion?()
        }

        //100 = 3.0   3235203 = 6.0
        self.easingRate =  CGFloat(abs(endValue - startValue)).map(0...100000, 2.0...5.0)
        self.progress = 0
        print(self.easingRate)
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

extension CGFloat {

    func map(_ from: ClosedRange<CGFloat>, _ to: ClosedRange<CGFloat>) -> CGFloat {
        return ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    }
}
