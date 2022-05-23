//
//  LineView.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 18.05.2022.
//

import Foundation
import UIKit

public class LineView : UIView {

    public var colors : [UIColor?] = [UIColor?]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var values : [CGFloat] = [CGFloat]() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func draw(_ rect: CGRect) {

        let r = self.bounds
        let numberOfSegments = values.count

        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        var cumulativeValue:CGFloat = 0

        for i in 0..<numberOfSegments {

            ctx.setFillColor(colors[i]?.cgColor ?? UIColor.clear.cgColor)
            ctx.fill(CGRect(x: cumulativeValue * r.size.width, y: 0, width: values[i] * r.size.width, height: r.size.height ))
            cumulativeValue += values[i]
        }
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}
