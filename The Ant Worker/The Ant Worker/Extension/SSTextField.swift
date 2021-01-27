//
//  SSTextField.swift
//
//
//  Created by SS on 2019-02-20.
//  Copyright © 2019 Hoang Mai Long. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
public class SSTextField: UITextField {
    @IBInspectable open var keyName: String = "Textfield"
    @IBInspectable open var isRequired: Bool = false
    @IBInspectable open var isNumberField: Bool = false
    var valueText:String?
    @IBInspectable open var msgWhenEmpty:String = "Không được để trống"
    var messageTextInValid:String?
    var indexTextFiend:NSInteger?
    var maxCharacter:NSInteger?
    var viewLine = UIView()
   
    public override func awakeFromNib() {
        super.awakeFromNib()
        viewLine.frame = CGRect.init(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 1)
        viewLine.backgroundColor = UIColor.init(hexString: "#D3DFEF")
        self.addSubview(viewLine)
        self.delegate = self
    }
    func setupLine(){
        viewLine.frame.size.width = self.frame.width
    }
    
    func isEmpTy() -> Bool {
        var check:Bool = false
        if self.text == nil {
            return true
        }
        if ((self.text? .isKind(of: NSNull.classForCoder()))! || self.text?.count == 0)
        {
            check = true
        }
        return check
    }
  
}
extension SSTextField:UITextFieldDelegate
{
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //kiểm tra so
        if textField is SSTextField && isNumberField
        {
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            if Int(string) == nil && string != "" {
                return false
            }
        }
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewLine.backgroundColor = UIColor.init(hexString: "#3AD29F")
        viewLine.frame.size.height = 2
        return true
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        viewLine.backgroundColor = UIColor.init(hexString: "#D3DFEF")
        viewLine.frame.size.height = 1
        return true
    }
}

