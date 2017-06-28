import UIKit

open class CountLabel: UILabel {

    public typealias VoidCompletionBlock = (() -> Void)

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

            var updateVal = self.easOut(for: percent)
            if self.span > 9999 {
                updateVal =  self.exponentialEaseInOut(for: percent)
            }

            return Int(Double(self.startValue) + (updateVal * Double(self.endValue - self.startValue)))
        }
    }

    fileprivate var startValue = 0
    fileprivate var endValue = 0
    fileprivate var progress: TimeInterval = 0.0
    fileprivate var lastUpdate: TimeInterval = 0.0
    fileprivate var totalTime: TimeInterval = 0.0
    fileprivate var easingRate = 3.0
    fileprivate var span = 0

    fileprivate var timer: CADisplayLink?

    fileprivate var completion: VoidCompletionBlock?

    open func count(from startValue: Int, to endValue: Int, withDuration duration: Double = 2.25, completion: VoidCompletionBlock? = nil) {
        self.completion = completion

        self.startValue = startValue
        self.endValue = endValue

        self.timer?.invalidate()
        self.timer = nil

        if duration <= 0.0 {
            self.setTextValue(self.endValue)
            self.completion?()
        }

        self.easingRate = Double(abs(endValue - startValue)).map(0...9999, 1.1...3.0)
        self.span = abs(endValue - startValue)
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

        self.setTextValue(self.currentValue)

        if self.progress == self.totalTime {
            self.completion?()
        }
    }

    private func setTextValue(_ value: Int) {
        self.text = "\(self.prefix ?? "")\(value)\(self.postfix ?? "")"
    }

    private func easOut(for time: Double) -> Double {
        return 1.0 - pow((1.0-time), self.easingRate)
    }

    private func exponentialEaseInOut(for time: Double) -> Double {
        if time == 0 || time == 1 { return time }

        if time < 1/2 {
            return 1/2 * (  ((20 * time) - 10).powerOfTwo  )
        }
        else{
            return -1/2 * (  ((-20 * time) + 10/1).powerOfTwo  ) + 1
        }
    }
}

public protocol FloatingPointMath: FloatingPoint{

    /// The mathematical sine of a floating-point value.
    var sine: Self {get}

    /// The mathematical cosine of a floating-point value.
    var cosine: Self {get}

    /**
     The power base 2 of a floating-point value.
     In the next example 'y' has a value of '3.0'.
     The powerOfTwo of 'y' is therefore '8.0'.

     let y: Double = 3.0
     let p = y.powerOfTwo
     print(p)  // "8.0"
     */
    var powerOfTwo: Self {get}
}

extension Float : FloatingPointMath {

    public var sine : Float {return sin(self)}
    public var cosine : Float {return cos(self)}
    public var powerOfTwo: Float {return pow(2, self)}
}

// MARK: - FloatingPointMath extension for Double.
extension Double : FloatingPointMath {

    public var sine : Double {return sin(self)}
    public var cosine : Double {return cos(self)}
    public var powerOfTwo: Double {return pow(2, self)}
}

// MARK: - FloatingPointMath extension for CGFloat.
extension CGFloat : FloatingPointMath {

    public var sine : CGFloat {return sin(self)}
    public var cosine : CGFloat {return cos(self)}
    public var powerOfTwo: CGFloat {return pow(2, self)}
}

extension Double {
    func map(_ from: ClosedRange<Double>, _ to: ClosedRange<Double>) -> Double {
        return ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    }
}