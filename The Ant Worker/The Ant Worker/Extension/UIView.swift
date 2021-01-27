//
//  UIViewExtension.swift
//  xMedical
//
//  Created by longhm on 11/3/17.
//  Copyright © 2017 . All rights reserved.
//


import UIKit

extension UIView{
    // Set Corner Radius for UIView
    @IBInspectable var cornerRadius:CGFloat {
        set{
            self.layer.cornerRadius = newValue
            self.clipsToBounds = newValue > 0
        }
        get {
            return self.layer.cornerRadius
        }
    }
    // Set Border Color for UIView
    @IBInspectable var borderColor:UIColor? {
        set {
            self.layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }else {
                return nil
            }
        }
    }
    // Set border width for UIView
    @IBInspectable var borderWidth:CGFloat {
        set{
            self.layer.borderWidth = newValue
        }
        get{
            return layer.borderWidth
        }
    }
    
    // Set Shadow Color for UIView
    @IBInspectable var shadowColor:UIColor? {
        set{
            self.layer.shadowColor = newValue!.cgColor
        }
        get {
            if let shadowColor = layer.shadowColor{
                return UIColor(cgColor: shadowColor)
            }else{
                return nil
            }
        }
    }
    // Set Shadow Opacity
    @IBInspectable var shadowOpacity:Float {
        set{
            self.layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    // Set Shadow Radius for UIView
    @IBInspectable var shadowRadius:CGFloat {
        set{
            self.layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
    // Set Shadow Offset for UIview
    @IBInspectable var shadowOffset:CGSize{
        set{
            self.layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    @IBInspectable var maskToBounds:Bool{
        set{
            self.layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
    
    func addBorders(to edges: UIRectEdge, withColor color: UIColor, heightOrWidth width: CGFloat) {
        
        if edges.contains(.all) {
            layer.borderColor = color.cgColor
            layer.borderWidth = width
            return
        }
        
        if edges.contains(.top) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
            layer.addSublayer(border)
        }
        
        if edges.contains(.left) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
            layer.addSublayer(border)
        }
        
        if edges.contains(.right) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
            layer.addSublayer(border)
        }
        
        if edges.contains(.bottom) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
            layer.addSublayer(border)
        }
    }
    /**
     Thực hiện add tapgesture
     - Parameter tapNumber: Số lần chạm
     - Parameter target: context
     - Parameter action: Event của tap
     */
    func addTapGesture(tapNumber: Int, target: Any, action:Selector){
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    func dropShadow(color: UIColor = UIColor.lightGray, opacity:Float  = 1, radius:CGFloat = 2, offset:CGSize = CGSize(width:0, height:2), scale:Bool = true){
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func shadowForCellView(radius:CGFloat)
    {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = CGSize(width: -2, height: 4)
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.07).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 50
    }
    func shadowForTextField()
    {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowOffset = CGSize(width: -2, height: 4)
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.07).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 50
    }
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func showToast(message:String)
    {
        self.hideAllToasts()
        self.makeToast(message)
    }
    func roundCorners( corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIAlertAction{
    @NSManaged var image:UIImage?
    convenience init(title:String?, style:UIAlertAction.Style, image:UIImage?, handle:((UIAlertAction) -> Swift.Void)? = nil) {
        self.init(title: title, style: style, handler: handle)
        self.image = image
    }
}

extension UIView {
    func addBlur(with style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
class CurrencyField: UITextField {
    var indexPath:IndexPath = IndexPath.init(row: 0, section: 0)
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999_999.99
    private var lastValue: String = ""
    override func willMove(toSuperview newSuperview: UIView?) {
        // you can make it a fixed locale currency if if needed
        Formatter.currency.locale = Locale(identifier: "vi_VN") // or "en_US", "fr_FR", etc
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        editingChanged()
    }
    override func deleteBackward() {
        text = string.digits.dropLast().string
        editingChanged()
    }
    @objc func editingChanged() {
        guard decimal <= maximum else {
            text = lastValue
            text = (lastValue as NSString).replacingOccurrences(of: "₫", with: "")
            return
        }
        lastValue = Formatter.currency.string(for: decimal) ?? ""
        text = lastValue
        text = (lastValue as NSString).replacingOccurrences(of: "₫", with: "")
        //        print("integer:", integerValue)
        //        print("double:", doubleValue)
        //        print("decimal:", decimal)
        //        print("currency:", lastValue)
    }
}
class CurrencyFieldNoEnd: UITextField {
    var type = 0
    var indexPath:IndexPath = IndexPath.init(row: 0, section: 0)
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999_999.99
    let maximumPercent: Decimal = 100.00
    private var lastValue: String = ""
    override func willMove(toSuperview newSuperview: UIView?) {
        // you can make it a fixed locale currency if if needed
        Formatter.currency.locale = Locale(identifier: "vi_VN") // or "en_US", "fr_FR", etc
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        editingChanged()
    }
    override func deleteBackward() {
        text = string.digits.dropLast().string
        editingChanged()
    }
    @objc func editingChanged() {
        var max:Decimal = maximumPercent
        if type == 1 {
            max = maximum
        }
        guard decimal <= max else {
            if type == 0
            {
                text = (lastValue as NSString).replacingOccurrences(of: "₫", with: "%")
            }
            else
            {
                text = lastValue
            }
            return
        }
        lastValue = Formatter.currency.string(for: decimal) ?? ""
        if type == 0
        {
            text = (lastValue as NSString).replacingOccurrences(of: "₫", with: "%")
        }
        else
        {
            text = lastValue
        }
    }
}
extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
    static let decimal = NumberFormatter(numberStyle: .decimal)
    static let percent = NumberFormatter(numberStyle: .percent)
}
extension String {
//    var digits: [UInt8] { return .compactMap{ UInt8(String($0)) } }
    // For Swift 4 or later just remove characters
    var digits: [UInt8] { return compactMap{ UInt8(String($0)) } }
}
extension Collection where Iterator.Element == UInt8 {
    var string: String { return map(String.init).joined() }
    var decimal: Decimal { return Decimal(string: string) ?? 0 }
}
extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}

import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
