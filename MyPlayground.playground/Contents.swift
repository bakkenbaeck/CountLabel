//: Playground - noun: a place where people can play

import CountLabel
import UIKit

let countLabel = CountLabel(frame: CGRect(x: 22 , y: 50, width: 300, height: 200))
countLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 258, weight: 10)
countLabel.textColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 20.0/255.0, blue: 147.0/255.0, alpha: 1.0)
countLabel.count(from: 0, to: 1984)
