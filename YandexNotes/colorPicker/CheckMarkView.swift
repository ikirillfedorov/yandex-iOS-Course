//
//  CheckMarkView.swift
//  Notes
//
//  Created by Kirill Fedorov on 07/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CheckMarkView: UIView {
    
    var isHasCheckMark = false
    
    override func draw(_ rect: CGRect) {
        if isHasCheckMark {
            super.draw(rect)
            //draw circle
            let center  = CGPoint(x: self.bounds.width * 0.8, y: self.bounds.width * 0.15)
            let circlePath = UIBezierPath()
            circlePath.addArc(withCenter: center, radius: self.bounds.width * 0.1, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            circlePath.lineWidth = 2
            circlePath.stroke()
            
            //draw check mark
            let checkMarkPath = UIBezierPath()
            checkMarkPath.lineWidth = 2
            checkMarkPath.move(to: CGPoint(x: self.bounds.width * 0.75, y: self.bounds.width * 0.15))
            checkMarkPath.addLine(to: CGPoint(x: self.bounds.width * 0.8, y: self.bounds.width * 0.2))
            checkMarkPath.addLine(to: CGPoint(x: self.bounds.width * 0.85, y: self.bounds.width * 0.1))
            checkMarkPath.stroke()
        }
    }
}
