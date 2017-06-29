import UIKit

open class CountLabel: UILabel {

    public typealias VoidCompletionBlock = (() -> Void)

    open var numberFormatter: NumberFormatter?

    var currentValue: Int {
        set {
        }
        get {
            if progress >= totalTime {

                return endValue
            }

            let percent: Double = progress / totalTime

            var updateVal = easOut(for: percent)
            if span > 9999 {
                updateVal = exponentialEaseInOut(for: percent)
            }

            return Int(Double(startValue) + (updateVal * Double(endValue - startValue)))
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
            setTextValue(endValue)
            completion?()
        }

        easingRate = Double(abs(endValue - startValue)).map(0 ... 9999, 1.1 ... 3.0)
        span = abs(endValue - startValue)
        progress = 0
        totalTime = duration
        lastUpdate = Date.timeIntervalSinceReferenceDate

        let timer = CADisplayLink(target: self, selector: #selector(updateValue))
        timer.preferredFramesPerSecond = 24
        timer.add(to: .current, forMode: .defaultRunLoopMode)

        self.timer = timer
    }

    func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)

        lastUpdate = now

        if progress >= totalTime {
            timer?.invalidate()
            timer = nil
            progress = totalTime
        }

        setTextValue(currentValue)

        if progress == totalTime {
            completion?()
        }
    }

    private func setTextValue(_ value: Int) {
        if let formattedValue = numberFormatter?.string(from: NSNumber(integerLiteral: value)) {
            text = "\(formattedValue)"
        } else {
            text = "\(value)"
        }
    }

    private func easOut(for time: Double) -> Double {
        return 1.0 - pow((1.0 - time), easingRate)
    }

    private func exponentialEaseInOut(for time: Double) -> Double {
        if time == 0 || time == 1 { return time }

        if time < 1 / 2 {
            return 1 / 2 * (((20 * time) - 10).powerOfTwo)
        } else {
            return -1 / 2 * (((-20 * time) + 10 / 1).powerOfTwo) + 1
        }
    }
}

public protocol FloatingPointMath: FloatingPoint {

    /// The mathematical sine of a floating-point value.
    var sine: Self { get }

    /// The mathematical cosine of a floating-point value.
    var cosine: Self { get }

    /** 
     The power base 2 of a floating-point value.
     In the next example 'y' has a value of '3.0'.
     The powerOfTwo of 'y' is therefore '8.0'.

     let y: Double = 3.0
     let p = y.powerOfTwo
     print(p)  // "8.0"
     */
    var powerOfTwo: Self { get }
}

extension Float: FloatingPointMath {

    public var sine: Float { return sin(self) }
    public var cosine: Float { return cos(self) }
    public var powerOfTwo: Float { return pow(2, self) }
}

// MARK: - FloatingPointMath extension for Double.
extension Double: FloatingPointMath {

    public var sine: Double { return sin(self) }
    public var cosine: Double { return cos(self) }
    public var powerOfTwo: Double { return pow(2, self) }
}

// MARK: - FloatingPointMath extension for CGFloat.
extension CGFloat: FloatingPointMath {

    public var sine: CGFloat { return sin(self) }
    public var cosine: CGFloat { return cos(self) }
    public var powerOfTwo: CGFloat { return pow(2, self) }
}

extension Double {

    func map(_ from: ClosedRange<Double>, _ to: ClosedRange<Double>) -> Double {
        return ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    }
}
