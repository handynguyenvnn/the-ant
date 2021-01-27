//
//  PConstants.swift
//  Pavico
//
//  Created by Tung Nguyen on 4/25/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import Foundation
import UIKit
let SUCCESS_CODE = 200
let ERROR_CODE = 1
let NAVIGATION_COLOR = UIColor.white
let DEFAULT_COLOR = UIColor.init(red: 58/255, green: 210/255, blue: 159/255, alpha: 1)
//let NAVIGATION_COLOR = UIColor.init(hexString: "153BE6")
let FORMAT_DATE = "dd/MM/yyyy"
let FORMAT_DATE_FULL_TIME = "yyyy-MM-dd hh:mm"
let FORMAT_DATE_SERVER = "yyyy-MM-dd"
let MAX_QUANTITY_ORDER = 2000
let MAX_SIZE_IMG_KB = 200.0
let HEIGHT_4S:CGFloat = 960
let HEIGHT_5S:CGFloat = 1136
let MASTER_KEY = "W13hGXqf2c"
let IS_ENCRYPT = true
let LOGOUT_ERROR_CODE = 3
let TOKEN_EXPIRED_CODE = 2
let MIN_RATE = 1.0
let GG_SIGIN_ID = "1092769277367-uc003f4pim80dh02ndd7oai1uej1u6lg.apps.googleusercontent.com"
enum TYPE_NOTI:Int {
    case NEW_JOB = 1 // Thông báo cho người lao động (ở vị trí xung quanh) biết nhà tuyển dụng vừa tạo cộng việc mới
    case ENOUGH_MEMBER = 2 // Thông báo cho người lao động (hoặc nhà tuyển dụng) biết đã hủy nhận công việc
    case CANCEL_JOB = 3 //huỷ công việc
    case JOB_RESOLVED = 4 // Thông báo cho người lao động (hoặc nhà tuyển dụng) biết có người vừa hoàn thành công việc đến thời điểm hiện tại
    case JOB_RESOLVED_CONFIRM = 5  // Thông báo cho nhà tuyển dụng biết người lao động hoàn thành công việc sớm và cần confirm xác nhận
    case JOB_BID = 6 //nhận được yêu cầu hoàn thành sớm công việc
    case JOB_RESOLVED_CONFIRM_YES = 7 // Thông báo cho nhà tuyển dụng biết người lao động vừa nhận công việc của họ
    case JOB_RESOLVED_CONFIRM_NO = 8 // Thông báo cho nhà tuyển dụng biết người lao động vừa nhận công việc của họ
    case JOB_COMING_SOON = 9 // Thông báo cho người lao động và nhà tuyển dụng biết có công việc sắp tới thời gian thực hiện
    case RE_INVITE = 10 // thông báo cho người lao động có muộn nhận job của nhà tuyển dụng mời không
    case CHANGE_PASSWORD = 100//USER FOR DOWNGRADE,DEACT
    case PROMOTION = 101
    case NONE = -1
}
struct KEY {
    struct KEY_API {
        static let rememberLogin = "rememberID"
        static let userName = "username"
        static let id = "id"
        static let dealerName = "dealername"
        static let password = "password"
        static let dealer_id = "dealer_id"
        static let error = "error"
        static let message = "message"
        static let data = "data"
        static let access_token = "access_token"
        static let guidlineLink = "guidlineLink"
    }
}
class DLOG: NSObject {
    class func printfLog(obj:AnyObject)
    {
        #if DEBUG
        print(obj.description ?? "")
        #else
        #endif
    }
}
struct MESSAGE {
    static let ERROR_DATA_SERVER_RETURN_INVALID_FORMAT = "Dữ liệu trả về không đúng định dạng"
}
struct API {
    static let baseUrl = "http://45.76.182.238:8888/api/" // server new
    //    static let baseUrl = "https://gso.honda.com.vn/api/"
    #if DEBUG
//    static let baseUrl = "http://45.76.182.238:1111/api/" // server new
    #else
    //static let baseUrl = "http://171.244.50.103:8888/api/" //base real
    //    static let baseUrl = "http://171.244.50.103:8000/api/" // test
    #endif
    struct PATH {
        static let verification = "auth/verification"
        static let dashboard = "user/dashboard"
        static let register = "auth/register"
        static let login = "auth/login"
        static let logout = "auth/logout"
        static let verify = "auth/verification"
        static let resendOtp = "auth/check-otp"
        static let changePass = "user/password"
        static let forgotPass = "auth/forgot"
        
        //MARK: USER
        static let getMyProfileDetail = "user/me"
        static let inActiveUser = "user/inactive-user"
        static let checkOtp = "auth/check-otp"
        static let updateToken = "auth/updateToken"
        static let verifyNewPhone = "user/verify-newphone"
        static let resendOtpNewPhone = "user/resend-otp-phone"
        static let CHECK_LOGIN_SOCIAL = "auth/checkSocial"
        static let updateProfile = "user/edit"
        static let uploadImage = "media/upload"
        static let userProfile = "user/profile"
        static let userOnline = "user/online"
        static let tracking = "user/tracking"
        
        //MARK: NOTIFICATION
        static let getListNotification = "noti/list"
        static let getDetailNotification = "noti/detail"
        static let deleteNotif = "noti/delete"
        static let getCountNotif = "noti/count-unread"
        
        //MARK: SUBMIT CODE
        static let submitCode = "auth/check-code-login"
        static let changePasswordFirstLogin = "auth/change-pass-first-login"
        // MARK:Job
        static let jobDetail = "job/detail"
        static let jobList = "job/list-worker"
        static let jobCancel = "job/cancel-worker"
        static let jobResolved = "job/resolved"
        static let jobCate = "job/cate"
        static let updateCate = "user/updateCate"
        static let resolvedJob = "job/worker-resolved"
        static let deleteJobInvite = "job/destroy-job-invite"
        //MARK:Rate
        static let rateWorker = "rate/worker"
        //Mark:Bid
        static let bidRequest = "bid/request"
        //MARK: POST
        static let postList = "post/list"
        static let postDetail = "post/detail"
        //MARK:report
        static let reportWorker = "report/worker"
        //FAQ
        static let listFAQ = "faq/list"
        static let listAsked = "faq/questionByCate"
        static let verifyJob = "job/verify-job"
        static let postBankInfo = "user/post-bank-info"
        static let bankList = "bank/list"
        static let withdrawalRequest = "withdrawal/request"
        static let userHistory = "userhistory/list"
        static let jobInvite = "job/job-invite"
        static let faqInfo = "faq/info"
        
    }
    static let userHistory = "\(baseUrl)\(PATH.userHistory)"
    static let withdrawalRequest = "\(baseUrl)\(PATH.withdrawalRequest)"
    static let postBankInfo = "\(baseUrl)\(PATH.postBankInfo)"
    static let bankList = "\(baseUrl)\(PATH.bankList)"
    static let verification = "\(baseUrl)\(PATH.verification)"
    static let dashboard = "\(baseUrl)\(PATH.dashboard)"
    static let register = "\(baseUrl)\(PATH.register)"
    static let login = "\(baseUrl)\(PATH.login)"
    static let logout = "\(baseUrl)\(PATH.logout)"
    static let verify = "\(baseUrl)\(PATH.verify)"
    static let resendOtp = "\(baseUrl)\(PATH.resendOtp)"
    static let changePass = "\(baseUrl)\(PATH.changePass)"
    static let forgotPass = "\(baseUrl)\(PATH.forgotPass)"
   
    //MARK: USER
    static let inActiveUser = "\(baseUrl)\(PATH.inActiveUser)"
    static let getMyProfileDetail = "\(baseUrl)\(PATH.getMyProfileDetail)"
    static let checkOtp = "\(baseUrl)\(PATH.checkOtp)"
    static let updateToken = "\(baseUrl)\(PATH.updateToken)"
    static let verifyNewPhone = "\(baseUrl)\(PATH.verifyNewPhone)"
    static let resendOtpNewPhone = "\(baseUrl)\(PATH.resendOtpNewPhone)"
    static let CHECK_LOGIN_SOCIAL = "\(baseUrl)\(PATH.CHECK_LOGIN_SOCIAL)"
    static let updateProfile = "\(baseUrl)\(PATH.updateProfile)"
    static let uploadImage = "\(baseUrl)\(PATH.uploadImage)"
    static let userProfile = "\(baseUrl)\(PATH.userProfile)"
    static let userOnline = "\(baseUrl)\(PATH.userOnline)"
    static let tracking = "\(baseUrl)\(PATH.tracking)"
    static let faqInfo = "\(baseUrl)\(PATH.faqInfo)"
    
    //MARK: NOTIFICATION
    static let getListNotification = "\(baseUrl)\(PATH.getListNotification)"
    static let getDetailNotification = "\(baseUrl)\(PATH.getDetailNotification)"
    static let deleteNotif = "\(baseUrl)\(PATH.deleteNotif)"
    static let getCountNotif = "\(baseUrl)\(PATH.getCountNotif)"
    
    //MARK: SUBMIT CODE
    static let submitCode = "\(baseUrl)\(PATH.submitCode)"
    static let changePasswordFirstLogin = "\(baseUrl)\(PATH.changePasswordFirstLogin)"
    //MARK:Job
    static let jobDetail = "\(baseUrl)\(PATH.jobDetail)"
    static let jobList = "\(baseUrl)\(PATH.jobList)"
    static let jobCancel = "\(baseUrl)\(PATH.jobCancel)"
    static let jobResolved = "\(baseUrl)\(PATH.jobResolved)"
    static let jobCate = "\(baseUrl)\(PATH.jobCate)"
    static let updateCate = "\(baseUrl)\(PATH.updateCate)"
    static let resolvedJob = "\(baseUrl)\(PATH.resolvedJob)"
    static let deleteJobInvite = "\(baseUrl)\(PATH.deleteJobInvite)"
    //MARK:Rate
    static let rateWorker = "\(baseUrl)\(PATH.rateWorker)"
    //MARK:Bid
    static let bidRequest = "\(baseUrl)\(PATH.bidRequest)"
    //MARK: POST
    static let postList = "\(baseUrl)\(PATH.postList)"
    static let postDetail = "\(baseUrl)\(PATH.postDetail)"
    //MARK : report
    static let reportWorker = "\(baseUrl)\(PATH.reportWorker)"
    // MARK: FAQ
    static let listFAQ = "\(baseUrl)\(PATH.listFAQ)"
    static let listAsked = "\(baseUrl)\(PATH.listAsked)"
    static let verifyJob = "\(baseUrl)\(PATH.verifyJob)"
    static let jobInvite = "\(baseUrl)\(PATH.jobInvite)"

    
}

extension UserDefaults {
    class func saveTokenFB(token:String){
        self.standard.set(token, forKey: "tokenFB")
    }
    class func resultTokenFB() -> String{
        return (self.standard.value(forKey: "tokenFB") as? String) ?? ""
    }
    class func saveTokenLogin(_ token:String){
        self.standard.set(token, forKey: "TOKEN")
        self.standard.synchronize()
    }
    class func saveUUID(_ uuid:String){
        self.standard.set(uuid, forKey: "UUID")
        self.standard.synchronize()
    }
    class func resultUUID() -> String{
        if let token = self.standard.object(forKey: "UUID") {
            return token as! String
        }
        if let tokenUUID:String = UIDevice.current.identifierForVendor?.uuidString {
            return tokenUUID
        }
        return "SIMULATOR"
    }
    class func saveDeviceToken(token:String){
        //token hand noti
        self.standard.set(token, forKey: "deviceToken")
    }
    class func resultDeviceToken() -> String{
        return (self.standard.value(forKey: "deviceToken") as? String) ?? "Simulator"
    }
    class func resultTokenLogin() -> String{
        if let token = self.standard.object(forKey: "TOKEN") {
            return token as! String
        }
        return ""
    }
    class func saveID(_ id:String){
        self.standard.set(id, forKey: KEY.KEY_API.userName)
        self.standard.synchronize()
    }
    class func resultID() -> String{
        if let id = self.standard.object(forKey: KEY.KEY_API.userName) {
            return id as! String
        }
        return ""
    }
    class func saveDealerName(_ id:String){
        self.standard.set(id, forKey: KEY.KEY_API.dealerName)
        self.standard.synchronize()
    }
    class func savePassword(_ id:String){
        self.standard.set(id, forKey: KEY.KEY_API.password)
        self.standard.synchronize()
    }
    class func resultPassword() -> String{
        if let id = self.standard.object(forKey: KEY.KEY_API.password) {
            return id as! String
        }
        return ""
    }
    class func saveDealer(_ id:Int){
        self.standard.set(id, forKey: KEY.KEY_API.dealer_id)
        self.standard.synchronize()
    }
    class func saveGuidlineLink(_ link:String){
        self.standard.set(link, forKey: KEY.KEY_API.guidlineLink)
        self.standard.synchronize()
    }
    class func resultGuidlineLink() -> String{
        return (self.standard.value(forKey: KEY.KEY_API.guidlineLink) as! String) ?? ""
    }
    class func saveRememberLogin(_ id:Bool){
        self.standard.set(id, forKey: KEY.KEY_API.rememberLogin)
        self.standard.synchronize()
    }
    class func resultRememberLogin() -> Bool{
        return (self.standard.value(forKey: KEY.KEY_API.rememberLogin) as? Bool) ?? false
    }
    class func resultDealer() -> String{
        if let id = self.standard.object(forKey: KEY.KEY_API.dealer_id) {
            return id as! String
        }
        return ""
    }
    class func resultUserObj() -> UserObj?{
        if let data = UserDefaults.standard.data(forKey: "save_user_obj"),
            let myUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserObj {
            DataCenter.sharedInstance.currentUser = myUser
            return myUser
        } else {
            print("There is an issue")
        }
        return nil
    }
    class func saveUserObj(obj:UserObj){
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: obj)
        UserDefaults.standard.set(encodedData, forKey: "save_user_obj")
    }
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding:  DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
