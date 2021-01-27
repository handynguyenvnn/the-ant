//
//  TAChangePassViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
import SwiftyJSON
class TAChangePassViewController: BaseViewController {
    @IBOutlet weak var txtPass: SSTextField!
    @IBOutlet weak var txtNewPass1: SSTextField!
    @IBOutlet weak var txtNewPass2: SSTextField!
    @IBOutlet weak var viewOldPass: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var txtOtp: SSTextField!
    var phone:String = ""
    var code:String  = ""
    var isChangePassword:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeader = true
        self.title = "Đổi mật khẩu"
        viewOldPass.isHidden = !isChangePassword
        viewOtp.isHidden = isChangePassword
        // Do any additional setup after loading the view.
    }
    func isValidOtp() -> Bool{
        if txtOtp.text == ""{
            self.view.showToast(message: "Mời bạn nhập mã otp.", position: .top)
            txtOtp.becomeFirstResponder()
            return false
        }
        if txtNewPass1.text == ""{
            self.view.showToast(message: "Mời bạn nhập mật khẩu mới.", position: .top)
            txtNewPass1.becomeFirstResponder()
            return false
        }
        if txtNewPass2.text != txtNewPass2.text{
            self.view.showToast(message: "Mời bạn nhập lại mật khẩu mới.", position: .top)
            txtNewPass2.becomeFirstResponder()
        }
        return true
    }
    func verift(){
        if isValidOtp(){
            Services.shareInstance.verify(code: txtOtp.text ?? "", phone: phone, newPass: Utilitys.encryptAES256(txtNewPass1.text ?? "") ?? "" , password: Utilitys.encryptAES256(txtNewPass2.text ?? "") ?? "" ){ (response, message, errorCode) in
                Toast.init(text: message, duration: 2.0).show()
                if errorCode == SUCCESS_CODE{
                    self.goForPassword()
                }
            }
        }
    }
    func isValidateChangPas() -> Bool{
        if txtPass.text == ""{
            self.view.showToast(message: "Mời bạn nhập mật khẩu hiện tại.", position: .top)
            txtPass.becomeFirstResponder()
            return false
        }
        if txtNewPass1.text == ""{
            self.view.showToast(message: "Mời bạn nhập mật khẩu mới.", position: .top)
            txtNewPass1.becomeFirstResponder()
            return false
        }
        if txtNewPass2.text != txtNewPass1.text{
            self.view.showToast(message: "Mời bạn nhập lại mật khẩu mới.", position: .top)
            txtNewPass2.becomeFirstResponder()
            return false
        }
        return true
    }
    func goForPassword(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func bntChangePass(_ sender: Any) {
        
        if !isChangePassword{
            //dổi pass truoc login
            verift()
        }else{
            //dổi pass sau login
            changPassWord()
        }
    }
    func changPassWord(){
        if isValidateChangPas(){
            self.view.endEditing(true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let oldPass = Utilitys.encryptAES256(txtPass!.text ?? "") ?? ""
            let newPassword = Utilitys.encryptAES256(txtNewPass1!.text ?? "") ?? ""
            let reNewPassword = Utilitys.encryptAES256(txtNewPass2!.text ?? "") ?? ""
            Services.shareInstance.changePassword(password: oldPass, newPass: newPassword, confirmPass: reNewPassword) { (result, message, errorCode) in
                MBProgressHUD.hide(for: self.view, animated: true)
                Toast.init(text: message).show()
                if errorCode == SUCCESS_CODE && result != nil
                {
                    UserObj.savePassWord(password:reNewPassword)
                    let resJson = JSON.init(result!)
                    DataCenter.sharedInstance.token = resJson[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? ""
                    UserDefaults.saveTokenLogin(DataCenter.sharedInstance.token)
                    //DataCenter.sharedInstance.currentUser?.isFirstLogin = false
                    if DataCenter.sharedInstance.currentUser != nil
                    {
                        UserDefaults.saveUserObj(obj: DataCenter.sharedInstance.currentUser!)
                    }
//                    if self.isFirstLogin
//                    {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    else
//                    {
                        self.tapLeft()
//                    }
                }
                else
                {
                    Toast.init(text: message, delay: 0, duration: 2.0).show()
                }
            }
        }
    }
}
