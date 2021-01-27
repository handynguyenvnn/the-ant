//
//  TAForgotPasswordViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
enum ACCOUNT_TYPE:Int
{
    case HR = 0
    case Worker = 1
}
class TAForgotPasswordViewController: BaseViewController {
    @IBOutlet weak var txtPhone: SSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeader = true
        txtPhone.delegate = self
        self.navigationItem.title = "Quên mật khẩu"
        
        // Do any additional setup after loading the view.
    }
    func isValidate() -> Bool {
        if txtPhone.text == ""{
            self.view.showToast(message: "Mời bạn nhập vào số điện thoại", position: .top)
            txtPhone.becomeFirstResponder()
            return false
        }else{
            return true
        }
    }
    func sendOtp(status:ACCOUNT_TYPE){
        if isValidate(){
            Services.shareInstance.forgotPass(phone: txtPhone.text ?? "", type: status.rawValue){ (response, message, errorCode) in
                Toast(text: message, duration: 2.0).show()
                if errorCode == SUCCESS_CODE{
                    self.goForPassword()
                }
            }
        }
    }
    func goForPassword(){
        let forgotPassWordVC:TAPassAuthViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAPassAuthViewController") as! TAPassAuthViewController
        self.navigationController?.pushViewController(forgotPassWordVC, animated: true)
        forgotPassWordVC.phone = txtPhone.text ?? ""
    }
    
    

    @IBAction func bntRestore(_ sender: Any) {
        sendOtp(status: ACCOUNT_TYPE.Worker)
    }
    

}
extension TAForgotPasswordViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone{
            //đang nhập thêm chữ thứ 10
            if textField.text?.count == 9 && string != ""{
            }
            if textField.text?.count == 10 && string != ""{
                return false
            }
            if textField.text?.count == 10 && string == ""{
            }
            return true
        }
        return true
    }
}
