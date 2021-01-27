//
//  TALoginViewController.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/27/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Toaster
import Toast_Swift
import FBSDKLoginKit
import GoogleSignIn
class TALoginViewController: BaseViewController {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var CheckPhone: UIImageView!
    @IBOutlet weak var btRememberAccount: UIButton!
    @IBOutlet weak var CheckRemember: UIImageView!
    @IBOutlet weak var btForgot: UIButton!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var viewLinePassword: UIView!
    @IBOutlet weak var btLoginFB: UIButton!
    @IBOutlet weak var btLoginGG: UIButton!
    @IBOutlet weak var heightLinePhone: NSLayoutConstraint!
    @IBOutlet weak var heightLinePassword: NSLayoutConstraint!
    var isRemember = true
    var fbUserInfo:MQFacebookInfoObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPhone.delegate = self
        txtPassword.delegate = self
        //txtPhone.becomeFirstResponder()
        isHideNavigation = true
        AppDelegate.sharedInstance.mainNavigation = self.navigationController
        if UserDefaults.resultTokenLogin() != ""{
            DataCenter.sharedInstance.token = UserDefaults.resultTokenLogin()
            goHome()
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btRemember(_ sender: Any) {
        isRemember = !isRemember
//        ic_uncheck
        if isRemember{
            CheckRemember.image = UIImage.init(named: "ic_checked")
        }
        else{
            CheckRemember.image = UIImage.init(named: "ic_uncheck")
        }
    }
    @IBAction func btLoginFB(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled) ?? false{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.returnUserData()
                }
            }
        }
        self.view.endEditing(true)
    }
    func isValiPhone()->Bool{
        if txtPhone.text == ""{
            self.view.showToast(message: "Mời bạn nhập vào số điện thoại", position: .top)
            txtPhone.becomeFirstResponder()
            return false
        }else{
            return true
        }
    }
    @IBAction func btLoginGG(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    @IBAction func btLogin(_ sender: Any) {
        self.view.endEditing(true)
        
            if isValid(){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                Services.shareInstance.login(phone: txtPhone.text ?? "", password:Utilitys.encryptAES256(txtPassword.text ?? "") ?? "" ) { (response, message, errorCode) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.handleLogin(response: response, message: message, errorCode: errorCode)
                }
                //goHome()
            }
        
    }
    func sendOtp(status:ACCOUNT_TYPE){
        if isValiPhone(){
            Services.shareInstance.forgotPass(phone: txtPhone.text ?? "", type: status.rawValue){ (response, message, errorCode) in
                Toast(text: message, duration: 2.0).show()
                if errorCode == SUCCESS_CODE{
                    let forgotVC:TAChangePassViewController = DuongStoryBoard.instantiateViewController(withIdentifier: "TAChangePassViewController") as! TAChangePassViewController
                    forgotVC.isChangePassword = false
                    forgotVC.phone = self.txtPhone.text ?? ""
                    self.navigationController?.pushViewController(forgotVC, animated: true)
                }
            }
        }
    }
    @IBAction func btNewRemember(_ sender: Any) {
    }
    @IBAction func btRegister(_ sender: Any) {
        let registerVC:TARegisterViewController = AccountStoryBoard.instantiateViewController(withIdentifier: "TARegisterViewController") as! TARegisterViewController
        registerVC.isCheckEdit = true
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func btForgot(_ sender: Any) {
        if isValiPhone(){
            sendOtp(status:ACCOUNT_TYPE.Worker)
        }
    }
    func isValid()->Bool{
        if txtPhone.text == ""{
            self.view.showToast(message: "Mời bạn nhập vào số điện thoại", position: .top)
            txtPhone.becomeFirstResponder()
            return false
        }else if txtPhone.text?.count ?? 0 != 10{
            self.view.showToast(message: "Số điện thoại không hợp lệ", position: .top)
            txtPhone.becomeFirstResponder()
            return false
        }else if txtPassword.text == ""{
            self.view.showToast(message: "Mời bạn nhập vào mật khẩu", position: .top)
            txtPassword.becomeFirstResponder()
            return false
        }
        else{
            return true
        }
    }
    func goHome(){
        self.navigationController?.navigationBar.isHidden = true
        let mainTabbar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAMainTabBarViewController") as! TAMainTabBarViewController
        self.navigationController?.viewControllers = [mainTabbar]
    }
    func handleLogin(response:Any?,message:String?,errorCode:Int){
        if errorCode == SUCCESS_CODE
        {
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:UserObj = UserObj.init(json: resJson[KEY.KEY_API.data][KEY.KEY_API.data])
                DataCenter.sharedInstance.currentUser = userInfo
                //                        UserDefaults.saveUserObj(obj: userInfo)
                DataCenter.sharedInstance.token = resJson[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? ""
                //                if userInfo.status == 1
                //                {
                if resJson[KEY.KEY_API.data][KEY.KEY_API.data]["is_expire"].bool ?? false{ //hết hạn mật khẩu
                    let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu của bạn đã hết hạn, vui lòng đổi mật khẩu để tiếp tục sử dụng hệ thống", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                        //                                    let changePassVC = AccountStoryBoard.instantiateViewController(withIdentifier: "POCChangePassViewController") as! PChangePassViewController
                        //                                    changePassVC.isFirstLogin = true
                        //                                    self.navigationController?.pushViewController(changePassVC, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    if self.isRemember{
                    UserObj.saveUserName(username: self.txtPhone?.text ?? "")
                    UserObj.savePassWord(password: self.txtPassword?.text ?? "")
                    UserDefaults.saveTokenLogin(DataCenter.sharedInstance.token)
                    }
                    
                    self.goHome()
                }
                //                }
                //                else
                //                {
                //                    self.view.makeToast("Tài khoản đã ngừng hoạt động.")
                //                    self.navigationController?.popToRootViewController(animated: true)
                //                }
            }
            else
            {
                self.view.makeToast("Thông tin không đúng.")
            }
        }
        else
        {
            self.view.makeToast(message)
        }
    }
    @IBAction func onLoginFb(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                //                if (result?.isCancelled) ?? false{
                //                    return
                //                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.returnUserData()
                }
            }
        }
        self.view.endEditing(true)
    }
    func returnUserData()
    {
        let accessToken = AccessToken.current
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"], tokenString: accessToken?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
        MBProgressHUD.showAdded(to: self.view, animated: true)
        _ = req.start(completionHandler: { (connection, result, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if result != nil{
                    //                    let data = result as! NSDictionary
                    self.fbUserInfo = MQFacebookInfoObj.init(object: result!)
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    //                    self.loginFbBtn?.isHidden = true
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    Services.shareInstance.checkLoginSocial(sid: self.fbUserInfo?.internalIdentifier ?? "", socialType: 1, block: { (response, message, errorCode) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if errorCode == SUCCESS_CODE{
                            if response != nil{
                                UserObj.saveFbCode(fbCode: self.fbUserInfo?.internalIdentifier ?? "")
                                let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAMainTabBarViewController") as! TAMainTabBarViewController
                                self.navigationController?.viewControllers = [homeVC]
                            }
                            else{
                                let registerVC:TARegisterViewController = AccountStoryBoard.instantiateViewController(withIdentifier: "TARegisterViewController") as! TARegisterViewController
                                registerVC.fbUserInfo = self.fbUserInfo
                                self.navigationController?.pushViewController(registerVC, animated: true)
                            }
                        }
                        else{
                            let registerVC:TARegisterViewController = AccountStoryBoard.instantiateViewController(withIdentifier: "TARegisterViewController") as! TARegisterViewController
                            registerVC.fbUserInfo = self.fbUserInfo
                            self.navigationController?.pushViewController(registerVC, animated: true)
                        }
                    })
                }
            }
            else
            {
                self.view.showToast(message: error?.localizedDescription ?? "Lấy thông tin facebook thất bại", position: .bottom)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TALoginViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPhone{
            viewPhone.backgroundColor = UIColor.init(red: 211/255  , green: 223/255, blue: 239/255, alpha:  1.0)
            heightLinePhone.constant = 1
        }
        else{
            viewLinePassword.backgroundColor = UIColor.init(red: 211/255, green: 223/255, blue: 239/255, alpha: 1.0)
            heightLinePassword.constant = 1
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtPhone{
            viewPhone.backgroundColor = UIColor.init(red: 58/255, green: 210/255, blue: 159/255, alpha:  1.0)
//            viewLinePassword.backgroundColor = UIColor.init(red: 211/255, green: 223/255, blue: 239/255, alpha: 1.0)
            heightLinePhone.constant = 2
//            heightLinePassword.constant = 1
        }
        else{
            viewPhone.backgroundColor = UIColor.init(red: 211/255  , green: 223/255, blue: 239/255, alpha:  1.0)
            viewLinePassword.backgroundColor = UIColor.init(red: 58/255, green: 210/255, blue: 159/255, alpha: 1.0)
            heightLinePhone.constant = 1
            heightLinePassword.constant = 2
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone{
            //đang nhập thêm chữ thứ 10
            if textField.text?.count == 9 && string != ""{
                //show nút v
               CheckPhone.isHidden = false
            }
            if textField.text?.count == 10 && string != ""{
                return false
            }
            if textField.text?.count == 10 && string == ""{
                CheckPhone.isHidden = true
            }
            return true
        }
        return true
    }
}
extension TALoginViewController:GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.checkLoginSocial(sid: userId ?? "", socialType: 0, block: { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE{
                if response != nil{
                    UserObj.saveGGId(userCode: userId ?? "")
                    let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAMainTabBarViewController") as! TAMainTabBarViewController
                    self.navigationController?.viewControllers = [homeVC]
                }
                else{
                    let registerVC:TARegisterViewController = AccountStoryBoard.instantiateViewController(withIdentifier: "TARegisterViewController") as! TARegisterViewController
                    registerVC.ggUserInfo = user
                    self.navigationController?.pushViewController(registerVC, animated: true)
                }
            }
            else{
                let registerVC:TARegisterViewController = AccountStoryBoard.instantiateViewController(withIdentifier: "TARegisterViewController") as! TARegisterViewController
                registerVC.ggUserInfo = user
                self.navigationController?.pushViewController(registerVC, animated: true)
            }
        })
        // ...
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
}
