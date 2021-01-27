//
//  TARegisterViewController.swift
//  The Ant
//
//  Created by Anh Quan on 7/1/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Toaster
import DatePickerDialog
import GoogleSignIn
import FBSDKLoginKit
import DropDown
enum GENDER : Int{
    case MEN = 0 // Mới
    case WOMEN = 1 // Đang chạy, show hoàn thành và huỷ
    case CANCEL = 2 // show đặt lại
    case NONE = -1
    func des() -> String {
        switch self {
        case .MEN:
            return "Nam"
        case .WOMEN:
            return "Nữ"
        case .CANCEL:
            return "Khác"
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
    @IBOutlet weak var txtBirthday: SSTextField!
    @IBOutlet weak var txtPassword: SSTextField!
    @IBOutlet weak var txtRePassword: SSTextField!
    @IBOutlet weak var checkPhone: UIImageView!
    @IBOutlet weak var checkEmail: UIImageView!
    @IBOutlet weak var btnDangky: UIButton!
    @IBOutlet weak var viewPass: UIView!
    @IBOutlet weak var viewRePass: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lbHoac: UILabel!
    @IBOutlet weak var stLoginSc: UIStackView!
    var listGender = [GENDER.MEN,GENDER.WOMEN,GENDER.CANCEL]
    var currenGender:GENDER?
    var birthday:Date = Date()
    var fbUserInfo:MQFacebookInfoObj?
    var isCheckEdit:Bool = false
    var ggUserInfo:GIDGoogleUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        //isShowBackButton = true
        txtPhone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //txtName.becomeFirstResponder()
        txtPhone.isNumberField = true
        //isShowHeader = true
        isHideNavigation = true
        isHiddenBottomBar = true
        //isShowBackButton = true
        txtPhone.delegate = self
        self.title = "Đăng ký"
//        lbHoac.isHidden = !isCheckEdit
//        stLoginSc.isHidden = !isCheckEdit
//        viewPass.isHidden = !isCheckEdit
//        viewPhone.isHidden = !isCheckEdit
//        viewRePass.isHidden = !isCheckEdit
//        if btnDangky.isSelected == !isCheckEdit{
//            btnDangky.setTitle("Đăng ký", for: .normal)
//        }else{
//            self.title = "Cập nhật thông tin"
//            btnDangky.setTitle("Cập nhật", for: .normal)
//        }
        
        // Do any additional setup after loading the view.
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
            self.currenGender = self.listGender[index]
//                self.currentStatus = self.listStatus[index]
        }
        dropDown.show()
        
    }
    func goHome(){
        self.navigationController?.navigationBar.isHidden = true
        let mainTabbar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TAMainTabBarViewController") as! TAMainTabBarViewController
        self.navigationController?.viewControllers = [mainTabbar]
    }
    @IBAction func onGioiTinh(_ sender: Any) {
        self.showDropdown(data: listGender.map{$0.des()}, target: self.txtGioiTinh, selectIndex: nil)
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
    @IBAction func onBirthDay(_ sender: Any) {
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show(
            "Thời gian",
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            maximumDate:Date(),
            datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    self.birthday = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    self.txtBirthday.text = formatter.string(from: dt)
                }
        }
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onRegister(_ sender: Any) {
        if isValid() {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Services.shareInstance.postRegister(
                name:txtName.text ?? "",
                password: Utilitys.encryptAES256(txtPassword.text ?? "") ?? "" ,
                re_password: Utilitys.encryptAES256(txtRePassword.text ?? "") ?? "" ,
                phone: txtPhone.text ?? "",
                email: txtEmail.text ?? "",
                address: txtAddress.text ?? "",
                birthday: Utilitys.stringToDate(withFormat: "dd-MM-yyyy",strDate: txtBirthday.text ?? "") ?? Date(),
                type_id: fbUserInfo != nil ? 1 : (ggUserInfo != nil ? 0 : nil),
                sid: fbUserInfo != nil ? (fbUserInfo?.internalIdentifier ?? "") : (ggUserInfo != nil ? (ggUserInfo?.userID ?? "") : nil),
                sub_type: currenGender ?? GENDER.CANCEL ){ (response, message, errorCode) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.handleLogin(response: response, message: message, errorCode: errorCode)
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
    func Login() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Services.shareInstance.login(phone: txtPhone.text ?? "", password:Utilitys.encryptAES256(txtPassword.text ?? "") ?? "" ) { (response, message, errorCode) in
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

    func isValid() -> Bool{
        if txtName.text == ""{
            self.view.showToast(message: "Mời bạn nhập họ tên.", position: .top)
            txtName.becomeFirstResponder()
            return false
        }
        if txtPhone.text == "" {
            self.view.showToast(message: "Mời bạn nhập số điện thoại.", position: .top)
            txtPhone.becomeFirstResponder()
            return false
        }
        if txtPhone.text?.count != 10 {
            self.view.showToast(message: "Số điện thoại không đúng.", position: .top)
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
        if txtBirthday.text == ""{
            self.view.showToast(message: "Mời bạn nhập ngày sinh.", position: .top)
            txtBirthday.becomeFirstResponder()
            return false
        }
        if txtAddress.text == ""{
            self.view.showToast(message: "Mời bạn nhập địa chỉ.", position: .top)
            txtAddress.becomeFirstResponder()
            return false
        }
        if txtGioiTinh.text == ""{
            self.view.showToast(message: "Mời bạn chọn giới tính.", position: .top)
            txtGioiTinh.becomeFirstResponder()
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
        }
        return true
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


