//
//  colorPickerView.swift
//  IndependentColorPicker
//
//  Created by Kirill Fedorov on 08/07/2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation
import UIKit

internal protocol chosenColorDelegate : NSObjectProtocol {
    func changeColor(color: UIColor)
    func doneButtonTapped(sender: UIButton)
}

@IBDesignable
class ColorPickerView: UIView {
    
    weak var delegate: chosenColorDelegate?
    
    var colorFromPallete: UIColor = .white
    
    @IBOutlet weak var chosenColorView: UIView!
    @IBOutlet weak var palletColorView: HSBColorPicker!
    @IBOutlet weak var chosenColorTextLabel: UILabel!
    @IBOutlet weak var brightnessSliderValue: UISlider!
    @IBOutlet weak var targetImageView: UIImageView!
    
    @IBAction func brightnessSliderAction(_ sender: UISlider) {
        chosenColorView.backgroundColor = colorFromPallete.colorWithBrightness(brightness: CGFloat(sender.value))
        chosenColorTextLabel.text = chosenColorView.backgroundColor?.getStringFrom()
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        if let color = chosenColorView.backgroundColor {
            delegate?.changeColor(color: color)
            delegate?.doneButtonTapped(sender: sender)

        }
//        self.isHidden = true
    }
    
    //MARK: - load view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        settingsViews()
    }
    
    private func settingsViews() {
        palletColorView.delegate = self
        
        chosenColorView.layer.borderColor = UIColor.black.cgColor
        chosenColorView.layer.borderWidth = 1
        chosenColorView.layer.cornerRadius = 5
        
        palletColorView.layer.borderColor = UIColor.black.cgColor
        palletColorView.layer.borderWidth = 1
        
        chosenColorTextLabel.layer.borderColor = UIColor.black.cgColor
        chosenColorTextLabel.layer.borderWidth = 1
        chosenColorTextLabel.layer.cornerRadius = 5
    }
    
    private func loadViewFromXib() -> UIView {
        let bunble = Bundle(for: type(of: self))
        let nib = UINib(nibName: "colorPickerView", bundle: bunble)
        guard let view = nib.instantiate(withOwner: self, options: nil).first else { return UIView()}
        return view as! UIView
    }
}


//MARK: - Color pallete
internal protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizer.State)
}

@IBDesignable
class HSBColorPicker : UIView {
    
    weak internal var delegate: HSBColorPickerDelegate?
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3
    
    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for y: CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            for x: CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        if saturation < 0 || brightness < 0 || hue < 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 1.0)
        } else {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)

        }
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos: CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
    }
}


//MARK: - extensions
extension ColorPickerView: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        chosenColorView.backgroundColor = color.colorWithBrightness(brightness: CGFloat(brightnessSliderValue.value))
        colorFromPallete = color
        chosenColorTextLabel.text = color.getStringFrom()
        targetImageView.center = point
    }
}

extension UIColor {
    func getStringFrom() -> String {
        guard let components = self.cgColor.components else { return "" }
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return String(format: "#%02X%02X%02X", arguments: [Int(r * 255), Int(g * 255), Int(b * 255)])
    }
}

extension UIColor {
    func colorWithBrightness(brightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            B += (brightness - 1.0)
            B = max(min(B, 1.0), 0.0)
            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        return self
    }
}
