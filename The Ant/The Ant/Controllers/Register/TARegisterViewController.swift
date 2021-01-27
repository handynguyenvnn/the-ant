//
//  TARegisterViewController.swift
//  The Ant
//
//  Created by Anh Quan on 7/1/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD
import SwiftyJSON
import GoogleSignIn
import FBSDKLoginKit
import DropDown
enum CUSTOMTYPE : Int{
    case GROUP = 0
    case PRESON = 1
    case CANCEL = 2
    case NONE = -1
    func des() -> String {
        switch self {
        case .GROUP:
            return "Doanh nghiệp"
        case .PRESON:
            return "Cá nhân"
        case .CANCEL:
            return "Tổ chức"
        default:
            return ""
        }
    }
}
class TARegisterViewController: BaseViewController {
    @IBOutlet weak var txtGioiTinh: SSTextField!
    @IBOutlet weak var txtName: SSTextField!
    @IBOutlet weak var txtPhone: SSTextField!
    @IBOutlet weak var txtEmail: SSTextField!
    @IBOutlet weak var txtAddress: SSTextField!
    @IBOutlet weak var txtPassword: SSTextField!
    @IBOutlet weak var txtRePassword: SSTextField!
    @IBOutlet weak var checkPhone: UIImageView!
    @IBOutlet weak var checkEmail: UIImageView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lbRegister: UILabel!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewRePassword: UIView!
    @IBOutlet weak var lbGioiTinh: UILabel!
    @IBOutlet weak var lbHoac: UILabel!
    @IBOutlet weak var btnDangKy: UIButton!
    @IBOutlet weak var stLoginSocial: UIStackView!
    var profile:UserObj?
    var listGender = [CUSTOMTYPE.GROUP,CUSTOMTYPE.PRESON,CUSTOMTYPE.CANCEL]
    var curentGender:CUSTOMTYPE?
    var fbUserInfo:MQFacebookInfoObj?
    var isCheckEdit:Bool = false
    var ggUserInfo:GIDGoogleUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        //isShowHeader = true
        isHideNavigation = true
        isHiddenBottomBar = true
        //isShowBackButton = true
        txtPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtName.becomeFirstResponder()
        txtPhone.isNumberField = true
        txtPhone.delegate = self
        //self.title = "Đăng ký"
        
        fillData()
    }
    override func initData() {
        if fbUserInfo != nil{
            txtName.text = fbUserInfo?.name
            txtEmail.text = fbUserInfo?.email
        }
        else if ggUserInfo != nil{
            txtName.text = ggUserInfo?.profile.name
            txtEmail.text = ggUserInfo?.profile.email
        }
    }
    func showDropdown(data:[String],target:UITextField?,selectIndex:Int?) {
        let dropDown = DropDown()
        dropDown.anchorView = target
        dropDown.dataSource = data
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height) ?? 0)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height ?? 0.0))
        if selectIndex != nil && selectIndex ?? 0 < data.count
        {
            dropDown.selectRow(selectIndex ?? 0)
        }
        
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 14.0){
            dropDown.textFont = font
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            target?.text = item
            self.curentGender = self.listGender[index]
        }
        dropDown.show()
        
    }
    @IBAction func onGioiTinh(_ sender: Any) {
        showDropdown(data: listGender.map{$0.des()}, target: txtGioiTinh, selectIndex: nil)
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtPhone{
            if textField.text?.count == 10{
                //show nút v
                checkPhone.isHidden = false
            }
            else{
                //ẩn nút v
                checkPhone.isHidden = true
            }
        }
        if textField == txtEmail{
            if Utilitys.isValidEmail(testStr: txtEmail.text ?? ""){
                //show nút v
                checkEmail.isHidden = false
            }
            else{
                //ẩn nút v
                checkEmail.isHidden = true
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtName.setupLine()
        txtEmail.setupLine()
        txtPhone.setupLine()
        txtAddress.setupLine()
        txtPassword.setupLine()
        txtRePassword.setupLine()
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
                    Toast(text: message, duration: 2.0).show()
                    UserObj.saveUserName(username: self.txtPhone?.text ?? "")
                    UserObj.savePassWord(password: self.txtPassword?.text ?? "")
                    UserDefaults.saveTokenLogin(DataCenter.sharedInstance.token)
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
    func isValidEdit() -> Bool{
        if txtName.text == ""{
            self.view.showToast(message: "Mời bạn nhập họ và tên.", position: .top)
            txtName.becomeFirstResponder()
            return false
        }
        if txtEmail.text == ""{
            self.view.showToast(message: "Mời bạn nhập email.", position: .top)
            txtEmail.becomeFirstResponder()
            return false
        }
        if txtAddress.text == ""{
            self.view.showToast(message: "Mời bạn nhập ngày sinh.", position: .top)
            txtAddress.becomeFirstResponder()
            return false
        }
        return true
    }
    @IBAction func onRegister(_ sender: Any){
        self.view.endEditing(true)
        if isValid() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Services.shareInstance.postRegister(
            name:txtName.text ?? "",
            password: Utilitys.encryptAES256(txtPassword.text ?? "") ?? "",
            re_password: Utilitys.encryptAES256(txtRePassword.text ?? "") ?? "",
            phone: txtPhone.text ?? "",
            email: txtEmail.text ?? "",
            address: txtAddress.text ?? "",
            birthday: nil,
            type_id: fbUserInfo != nil ? 1 : (ggUserInfo != nil ? 0 : nil),
            sid: fbUserInfo != nil ? (fbUserInfo?.internalIdentifier ?? "") : (ggUserInfo != nil ? (ggUserInfo?.userID ?? "") : nil), sub_type: curentGender ?? CUSTOMTYPE.CANCEL
            ) { (response, message, errorCode) in
                MBProgressHUD.hide(for: self.view, animated: true)
                //self.view.makeToast(message)
//                self.view.showToast(message: message ?? "", position: .top)
                self.handleLogin(response: response, message: message, errorCode: errorCode)
            }
        }
    }
    func Login() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.login(phone: txtPhone.text ?? "", password: Utilitys.encryptAES256(txtPassword.text ?? "") ?? "") { (response, message, errorCode) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorCode == SUCCESS_CODE
            {
                if  response != nil{
                    let resJson = JSON.init(response!)
                    let userInfo:UserObj = UserObj.init(json: resJson[KEY.KEY_API.data][KEY.KEY_API.data])
                    DataCenter.sharedInstance.currentUser = userInfo
                    //UserDefaults.saveUserObj(obj: userInfo)
                    DataCenter.sharedInstance.token = resJson[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? ""
                    UserObj.saveUserName(username: self.txtPhone?.text ?? "")
                    UserObj.savePassWord(password: self.txtPassword?.text ?? "")
                    UserDefaults.saveTokenLogin(DataCenter.sharedInstance.token)
                    self.goHome()
                }
            }
            else
            {
                self.view.makeToast(message)
            }
        }
    }
    func isValid() -> Bool{
        if txtName.text == ""{
            self.view.showToast(message: "Mời bạn nhập họ và tên.", position: .top)
            txtName.becomeFirstResponder()
            return false
        }
        if txtPhone.text == "" {
            self.view.showToast(message: "Mời bạn nhập số điện thoại", position: .top)
            txtPhone.becomeFirstResponder()
            return false
        }
        if txtEmail.text == ""{
            self.view.showToast(message: "Mời bạn nhập vào email.", position: .top)
            txtEmail.becomeFirstResponder()
            return false
        }
        if !Utilitys.isValidEmail(testStr:txtEmail.text ?? ""){
            self.view.showToast(message: "Email không đúng định dạng.", position: .top)
            txtEmail.becomeFirstResponder()
            return false
        }
        if txtAddress.text == ""{
            self.view.showToast(message: "Mời bạn nhập địa chỉ.", position: .top)
            txtAddress.becomeFirstResponder()
            return false
        }
        if txtGioiTinh.text == ""{
            self.view.showToast(message: "Mời bạn nhập địa chỉ.", position: .top)
            //txtAddress.becomeFirstResponder()
            return false
        }
        if txtPassword.text == ""{
            self.view.showToast(message: "Mời bạn nhập mật khẩu.", position: .top)
            txtPassword.becomeFirstResponder()
            return false
        }
        if txtRePassword.text != txtPassword.text{
            self.view.showToast(message: "Nhập lại mật khẩu không khớp.", position: .top)
            txtRePassword.becomeFirstResponder()
            return false
        }
        return true
    }
    func fillData(){
        if profile != nil {
            txtName.text = self.profile?.name ?? ""
            txtEmail.text = self.profile?.email ?? ""
            txtAddress.text = self.profile?.address ?? ""
        }
    }
    @IBAction func onLoginFB(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.returnUserData()
                }
            }
        }
        self.view.endEditing(true)
    }
    @IBAction func onLoginGG(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.delegate = self
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
                    self.initData()
                }
            }
            else
            {
                self.view.showToast(message: error?.localizedDescription ?? "Lấy thông tin facebook thất bại", position: .bottom)
            }
        })
    }
//    func editInfo(){
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        Services.shareInstance.updateProfile(
//            name: txtName.text ?? "",
//            email: txtEmail.text ?? "",
//            address: txtAddress.text ?? ""){ (response, message, errorCode) in
//                MBProgressHUD.hide(for: self.view, animated: true)
//                Toast(text: message, duration: 2.0).show()
//                if errorCode == SUCCESS_CODE{
//                    let resJson = JSON.init(response!)
//                    let userInfo:UserObj = UserObj.init(json: resJson["data"])
//                    self.profile = userInfo
//                    DataCenter.sharedInstance.currentUser = self.profile
//                    if self.profile != nil{
//                        UserDefaults.saveUserObj(obj: self.profile!)
//                    }
//                    self.navigationController?.popViewController(animated: true)
//                }
//        }
//    }
}
extension TARegisterViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhone{
            //đang nhập thêm chữ thứ 10
            if textField.text?.count == 9 && string != ""{
                //show nút v
                checkPhone.isHidden = false
            }
            if textField.text?.count == 10 && string != ""{
                return false
            }
            if textField.text?.count == 10 && string == ""{
                checkPhone.isHidden = true
            }
            return true
        }
        
        return true
    }
}
extension TARegisterViewController:GIDSignInDelegate{
    
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
        self.ggUserInfo = user
        self.initData()
        // ...
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
}



