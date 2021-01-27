//
//  PServices.swift
//  POC
//
//  Created by Tung Nguyen on 1/19/19.
//  Copyright © 2019 "". All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD
typealias CompletionBlock = (_ result: Any?, _ message: String?, _ errorCode: Int) -> Void
typealias CompletionBlockDouble = (_ result1: Any?,_ result2: Any?, _ message: String?, _ errorCode: Int) -> Void
typealias CompletionBlockLoadpage = (_ result: Any?, _ message: String?,_ isNextPage:Bool?, _ errorCode: Int) -> Void
typealias ProgressBlock = (_ currentProgress: Double) -> Void
let SIMULATOR_TOKEN = "278322981"
class Services: NSObject {
    static let shareInstance = Services()
    func post(_ url:URL,parameter:[String:Any]?, header:HTTPHeaders?,block:@escaping CompletionBlock){
        postToServiceWith(url, parameter: parameter, httpMethod: .post, header: header, block: block)
    }
    func postWithBody(_ url:URL,parameter:[String:Any]?, header:HTTPHeaders?,block:@escaping CompletionBlock){
        postToServiceBodyWith(url, parameter: parameter, httpMethod: .post, header: header, block: block)
    }
    func get(_ url:URL,parameter:[String:Any]?, header:HTTPHeaders?,block:@escaping CompletionBlock){
        postToServiceWith(url, parameter: parameter, httpMethod: .get, header: header, block: block)
    }
    func getWithStringUrl(_ urlString:String,parameter:[String:Any]?, header:HTTPHeaders?,block:@escaping CompletionBlock){
        var newUrlParam = ""
        var newUrl = urlString
        if parameter != nil {
            var i = 0
            for item in parameter!
            {
                if i == 0
                {
                    if item.value is String
                    {
                        let text = (item.value as! String).addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
                        newUrlParam = newUrlParam + "?\(item.key)=\(text)"
                    }
                    else
                    {
                        newUrlParam = newUrlParam + "?\(item.key)=\(item.value)"
                    }
                    
                }
                else
                {
                    if item.value is String
                    {
                        let text = (item.value as! String).addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
                        newUrlParam = newUrlParam + "&\(item.key)=\(text)"
                    }
                    else
                    {
                        newUrlParam = newUrlParam + "&\(item.key)=\(item.value)"
                    }
                }
                i += 1
            }
            newUrlParam += "&uuid=" + UserDefaults.resultUUID() + "&platform=1"
        }
        else
        {
            newUrlParam = "?uuid=" + UserDefaults.resultUUID() + "&platform=1"
        }
        newUrl = newUrl + newUrlParam
        postToServiceWith(URL.init(string: newUrl)!, parameter: nil, httpMethod: .get, header: header, block: block)
    }
    func put(_ url:URL,parameter:[String:Any]?, header:HTTPHeaders?,block:@escaping CompletionBlock){
        postToServiceBodyWith(url, parameter: parameter, httpMethod: .put, header: header, block: block)
    }
    func delete(_ url:URL,parameter:[String:Any]?, header:HTTPHeaders?,block:@escaping CompletionBlock){
        postToServiceBodyWith(url, parameter: parameter, httpMethod: .delete, header: header, block: block)
    }
    func upload(_ url:String,parameter:[String:Any], header:HTTPHeaders?,block:@escaping CompletionBlock){
        uploadWithMultiPart(url, parameter: parameter, httpMethod: .delete, header: header, block: block)
    }
    func isLoadMore(data:JSON) -> Bool {
        return data["nextPage"].bool == true
    }
    //    JSONEncoding.default
    private  func postToServiceWith(_ url:URL,parameter:[String:Any]?, httpMethod:HTTPMethod, header:HTTPHeaders?,block:@escaping CompletionBlock){
        var newParams:[String:Any]? = parameter
        if httpMethod == .post
        {
            if newParams == nil {
                newParams = ["uuid":  UserDefaults.resultUUID()]
            }
            else
            {
                newParams!["uuid"] = UserDefaults.resultUUID()
            }
            newParams!["platform"] = 1
        }
        Alamofire.request(url, method: httpMethod, parameters: newParams, encoding: URLEncoding.httpBody, headers: header).responseJSON { (response) in
            if response.result.isSuccess && response.data != nil {
                do {
                    let resJson = try JSON.init(data: response.data!)
                    if resJson[KEY.KEY_API.error].int == TOKEN_EXPIRED_CODE{
                        let userName = (UserObj.getUserName())
                        let password = Utilitys.encryptAES256(UserObj.getPassWord())
                        let socialId = UserObj.getFbCode()
                        let ggId = UserObj.getGGId()
                        if userName != ""{
                            self.login(phone: userName, password: password ?? "", block: { (response2, message2, errorCode2) in
                                if errorCode2 == SUCCESS_CODE{
                                    let resJson = JSON.init(response2!)
                                    UserDefaults.saveTokenLogin(resJson[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                    self.postToServiceWith(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                }
                                else{
                                    AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                }
                            })
                        }
                        else if socialId != ""{
                            self.checkLoginSocial(sid: socialId, socialType: 1, block: { (response2, message2, errorCode2) in
                                let resJson2 = response2 as? JSON
                                if resJson2?[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                                    UserDefaults.saveUserObj(obj: UserObj.init(json: resJson2?[KEY.KEY_API.data][KEY.KEY_API.data] ?? JSON.init(parseJSON: "")))
                                    UserDefaults.saveTokenLogin(resJson2?[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                    self.postToServiceWith(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                }
                                else{
                                    AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                }
                            })
                        }
                        else if ggId != ""{
                            self.checkLoginSocial(sid: ggId, socialType: 0, block: { (response2, message2, errorCode2) in
                                let resJson2 = response2 as? JSON
                                if resJson2?[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                                    UserDefaults.saveUserObj(obj: UserObj.init(json: resJson2?[KEY.KEY_API.data][KEY.KEY_API.data] ?? JSON.init(parseJSON: "")))
                                    UserDefaults.saveTokenLogin(resJson2?[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                    self.postToServiceWith(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                }
                                else{
                                    AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                }
                            })
                        }
                    }
                    else if resJson[KEY.KEY_API.error].int == LOGOUT_ERROR_CODE{
                        AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                    }
                    else{
                        block(resJson, resJson[KEY.KEY_API.message].string, resJson[KEY.KEY_API.error].int  ?? ERROR_CODE)
                    }
                }
                catch{
                    block(nil, response.error?.localizedDescription, ERROR_CODE)
                }
            } else {
                block(nil, response.error?.localizedDescription, ERROR_CODE)
            }
        }
    }
    
    private  func postToServiceBodyWith(_ url:URL,parameter:[String:Any]?, httpMethod:HTTPMethod, header:HTTPHeaders?,block:@escaping CompletionBlock){
        var newParams:[String:Any]? = parameter
        if httpMethod == .post
        {
            if newParams == nil {
                newParams = ["uuid":  UserDefaults.resultUUID()]
            }
            else
            {
                newParams!["uuid"] = UserDefaults.resultUUID()
            }
        }
        Alamofire.request(url, method: httpMethod, parameters: newParams, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.isSuccess && response.data != nil {
                do {
                    let resJson = try JSON.init(data: response.data!)
                    if resJson[KEY.KEY_API.error].int == TOKEN_EXPIRED_CODE{
                        let userName = (UserObj.getUserName())
                        let password = Utilitys.encryptAES256(UserObj.getPassWord())
                        let socialId = UserObj.getFbCode()
                        let ggId = UserObj.getGGId()
                        if userName != ""{
                            self.login(phone: userName, password: password ?? "", block: { (response2, message2, errorCode2) in
                                if errorCode2 == SUCCESS_CODE{
                                    let resJson = JSON.init(response2!)
                                    UserDefaults.saveTokenLogin(resJson[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                    self.postToServiceBodyWith(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                }
                                else{
                                    AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                }
                            })
                        }
                        else if socialId != ""{
                            self.checkLoginSocial(sid: socialId, socialType: 1, block: { (response2, message2, errorCode2) in
                                let resJson2 = response2 as? JSON
                                if resJson2?[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                                    UserDefaults.saveUserObj(obj: UserObj.init(json: resJson2?[KEY.KEY_API.data][KEY.KEY_API.data] ?? JSON.init(parseJSON: "")))
                                    UserDefaults.saveTokenLogin(resJson2?[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                    self.postToServiceBodyWith(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                }
                                else{
                                    AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                }
                            })
                        }
                        else if ggId != ""{
                            self.checkLoginSocial(sid: ggId, socialType: 0, block: { (response2, message2, errorCode2) in
                                let resJson2 = response2 as? JSON
                                if resJson2?[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                                    UserDefaults.saveUserObj(obj: UserObj.init(json: resJson2?[KEY.KEY_API.data][KEY.KEY_API.data] ?? JSON.init(parseJSON: "")))
                                    UserDefaults.saveTokenLogin(resJson2?[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                    self.postToServiceBodyWith(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                }
                                else{
                                    AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                }
                            })
                        }
                    }
                    else if resJson[KEY.KEY_API.error].int == LOGOUT_ERROR_CODE{
                        AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                    }
                    else{
                        block(resJson, resJson[KEY.KEY_API.message].string, resJson[KEY.KEY_API.error].int  ?? ERROR_CODE)
                    }
                }
                catch{
                    block(nil, response.error?.localizedDescription, ERROR_CODE)
                }
            } else {
                block(nil, response.error?.localizedDescription, ERROR_CODE)
            }
        }
    }
    
    private func uploadWithMultiPart(_ url:String,parameter:[String:Any], httpMethod:HTTPMethod, header:HTTPHeaders?,block:@escaping CompletionBlock){
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: header) { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    do {
                        let resJson = try JSON.init(data: response.data!)
                        if resJson[KEY.KEY_API.error].int == TOKEN_EXPIRED_CODE{
                            let userName = (UserObj.getUserName())
                            let password = Utilitys.encryptAES256(UserObj.getPassWord())
                            let socialId = UserObj.getFbCode()
                            let ggId = UserObj.getGGId()
                            if userName != ""{
                                self.login(phone: userName, password: password ?? "", block: { (response2, message2, errorCode2) in
                                    if errorCode2 == SUCCESS_CODE{
                                        let resJson = JSON.init(response2!)
                                        UserDefaults.saveTokenLogin(resJson[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                        self.uploadWithMultiPart(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                        
                                    }
                                    else{
                                        AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                    }
                                })
                            }
                            else if socialId != ""{
                                self.checkLoginSocial(sid: socialId, socialType: 1, block: { (response2, message2, errorCode2) in
                                    let resJson2 = response2 as? JSON
                                    if resJson2?[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                                        UserDefaults.saveUserObj(obj: UserObj.init(json: resJson2?[KEY.KEY_API.data][KEY.KEY_API.data] ?? JSON.init(parseJSON: "")))
                                        UserDefaults.saveTokenLogin(resJson2?[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                        self.uploadWithMultiPart(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                    }
                                    else{
                                        AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                    }
                                })
                            }
                            else if ggId != ""{
                                self.checkLoginSocial(sid: ggId, socialType: 0, block: { (response2, message2, errorCode2) in
                                    let resJson2 = response2 as? JSON
                                    if resJson2?[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                                        UserDefaults.saveUserObj(obj: UserObj.init(json: resJson2?[KEY.KEY_API.data][KEY.KEY_API.data] ?? JSON.init(parseJSON: "")))
                                        UserDefaults.saveTokenLogin(resJson2?[KEY.KEY_API.data][KEY.KEY_API.access_token].string ?? "")
                                        self.uploadWithMultiPart(url, parameter: parameter, httpMethod: httpMethod, header: HDHeader.headerToken(), block: block)
                                    }
                                    else{
                                        AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                                    }
                                })
                            }
                        }
                        else if resJson[KEY.KEY_API.error].int == LOGOUT_ERROR_CODE{
                            AppDelegate.sharedInstance.logout(message: "Phiên đăng nhập hết hạn.")
                        }
                        else{
                            block(resJson, resJson[KEY.KEY_API.message].string, resJson[KEY.KEY_API.error].int  ?? ERROR_CODE)
                        }
                    }
                    catch{
                        block(nil, response.error?.localizedDescription, ERROR_CODE)
                    }
                }
            case .failure(let error):
                block(nil, error.localizedDescription, ERROR_CODE)
            }
        }
        
    }
//    //MARK: ACCOUNT
//    func register(name:String,password:String,rePassword:String,phone:String,birthday:String,email:String?,ava:UIImage?,socialId:String?,block:@escaping CompletionBlock){
//        var param = [
//            "name":name,
//            "password":password,
//            "re-password":rePassword,
//            "phone":phone,
//            "birthday":birthday,
//            "uuid": UserDefaults.resultUUID(),
//            ] as [String:Any]
//        if email != nil{
//            param["email"] = email ?? ""
//        }
//        if socialId != nil{
//            param["sid"] = socialId ?? ""
//        }
//        if ava == nil{
//            self.post(URL.init(string: API.register)!, parameter: param, header: nil, block: block)
//        }
//        else{
//            self.registerWithAva(selectedImages: ava ?? UIImage(), param: param, block: block)
//        }
//    }
    func postRegister(
        name:String,
        password:String,
        re_password:String,
        phone:String,
        email:String?,
        address:String?,
        birthday:String?,
        type_id:Int?,
        sid:String?,
        sub_type:CUSTOMTYPE,
        block:@escaping CompletionBlock){
        var param = [
            "name":name,
            "password":password,
            "re-password":re_password,
            "phone":phone,
            "type":0,
            "uuid":UserDefaults.resultUUID(),
            "token":UserDefaults.resultDeviceToken(),
            "platform" : 1,
            "sub_type" : sub_type.rawValue
        ] as [String:Any]
        if email != nil{
            param["email"] = email ?? ""
        }
        if birthday != nil{
            param["birthday"] = birthday ?? ""
        }
        if sid != nil{
            param["sid"] = sid ?? ""
        }
        if type_id != nil{
            param["type_id"] = type_id ?? ""
        }
        self.postWithBody(URL.init(string: API.register)!, parameter: param, header: nil, block: block)
    }
    func registerWithAva(selectedImages:UIImage,param:[String:Any],block:@escaping CompletionBlock){
        //let data = selectedImages.jpegData(compressionQuality: PUtilitys.getCompressQuanlity(image: selectedImages))
        if let data = selectedImages.jpegData(compressionQuality: Utilitys.getCompressQuanlity(image: selectedImages)) {
            //let strUrl = "\(API.POST_UPLOAD_IMAGE)?deviceId=\(UserDefaults.resultUDID())"
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in param {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                multipartFormData.append(data, withName: "file", fileName: "avartar", mimeType: "image/*")
                
            }, usingThreshold: UInt64.init(), to: API.register, method: .post, headers: HDHeader.headerTokenForUpload()) { (result) in
                
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        do {
                            let resJson = try JSON.init(data: response.data!)
                            block(resJson["data"]["avatar"].string, resJson["message"].string,resJson["error"].int ?? ERROR_CODE)
                            
                        }
                        catch{
                            block(nil, "Lỗi upload ảnh", ERROR_CODE)
                        }
                    }
                case .failure(let error):
                    block(nil, error.localizedDescription,ERROR_CODE)
                }
            }
        }
    }
    func login(phone:String,password:String,block:@escaping CompletionBlock){
        let param = [
            "phone":phone,
            "password":password,
            "uuid":  UserDefaults.resultUUID(),
            "token": UserDefaults.resultDeviceToken(),
            "type":0,
            "platform": 1

            ] as [String:Any]
        self.post(URL.init(string: API.login)!, parameter: param, header: nil, block: block)
    }
    
    func checkLoginSocial(sid:String,block:@escaping CompletionBlock){
        let url = "\(API.CHECK_LOGIN_SOCIAL)?stype=1&sid=\(sid)&uuid=\(UserDefaults.resultUUID())&token=\(UserDefaults.resultDeviceToken())&platform=\(1)"
        Services.shareInstance.get(URL.init(string: url)!, parameter: nil, header: nil) { (response, message, errorCode) in
            if response != nil {
                if errorCode == SUCCESS_CODE {
                    let resJson = JSON.init(response!)
                    if resJson[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                        UserDefaults.saveUserObj(obj: UserObj.init(json: resJson[KEY.KEY_API.data][KEY.KEY_API.data]))
                        UserDefaults.saveTokenLogin(resJson[KEY.KEY_API.data]["access_token"].string ?? "")
                        DataCenter.sharedInstance.token = resJson[KEY.KEY_API.data]["access_token"].string ?? ""
                        block(resJson, message, errorCode)
                    }
                    else{
                        block(nil, message, errorCode)
                    }
                } else {
                    block(nil, message, errorCode)
                }
            } else {
                block(nil, message, errorCode)
            }
            
        }
    }
//    func resendOtp(phone:String,code:String,block:@escaping CompletionBlock){
//        let param = ["phone":phone,"code":code]
//        self.post(URL.init(string:API.resendOtp)!, parameter: param, header: HDHeader.headerToken(), block: {(response, message, errorCode) in
//            if response != nil{
//                let resJson = JSON.init(response!)
//                block(resJson,resJson["message"].string,resJson["error"].int ?? ERROR_CODE)
//            }
//            else{
//                block(response,message,errorCode)
//            }
//        })
//    }


    func changePassword(password:String,newPass:String,confirmPass:String,block:@escaping CompletionBlock){
        let param = ["oldPassword":password,
                     "newPassword":newPass,
                     "re-password":confirmPass,
                     "uuid":UserDefaults.resultUUID()
        ]
        self.post(URL.init(string: API.changePass)!, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                let resJson = JSON.init(response!)
                DataCenter.sharedInstance.token = "\(resJson["data"]["access_token"].string ?? "")"
                block(response,resJson["message"].string,resJson["error"].int ?? ERROR_CODE)
            }
            else{
                block(nil,message,ERROR_CODE)
            }
        }
    }
    func logout(block:@escaping CompletionBlock){
        var uuidString:String = UserDefaults.resultUUID()
        if uuidString == "" {
            uuidString = SIMULATOR_TOKEN
        }
        let param = [
            "uuid":  UserDefaults.resultUUID(),
            "token": UserDefaults.resultDeviceToken(),
            "platform": 1] as [String:Any]
        self.post(URL.init(string: API.logout )!, parameter: param, header: HDHeader.headerToken(),block: { (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
//                AppDelegate.sharedInstance.unSubcribeTopicAll()
            }
//            Messaging.messaging().unsubscribe(fromTopic: "topic_all") { error in
//                print("Subscribed to topic_all")
//            }
            block(response,message,errorCode)
        })
    }
    func forgotPass(phone:String,type:NSInteger,block:@escaping CompletionBlock){
        let param = ["phone":phone,"type":type] as [String : Any]
        self.post(URL.init(string:API.forgotPass)!, parameter: param, header: nil, block: {(response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson,resJson["message"].string,resJson["error"].int ?? ERROR_CODE)
            }
            else{
                block(response,message,errorCode)
            }
        })
    }
    func updateFBToken(token:String,block:@escaping CompletionBlock){
        self.post(URL.init(string: API.updateToken)!, parameter: ["token":token], header: HDHeader.headerToken(), block: block)
    }
    func verify(code:String,phone:String,newPass:String,password:String,block:@escaping CompletionBlock){
        var deviceToken:String = Utilitys.getDefaultString(originString: UserDefaults.resultUUID() as AnyObject)
        if deviceToken == "" {
            deviceToken = SIMULATOR_TOKEN
        }
        let param:[String:Any] = ["code":code,"phone":phone,"password":newPass,"re-password":newPass]
        self.post(URL.init(string: API.verification)!, parameter: param, header: nil, block: block)

    }
    

    
    //MARK: USER
    //getMyProfileDetai
    func getMyProfileDetai(block:@escaping CompletionBlock){
        self.get(URL.init(string: API.getMyProfileDetail)!, parameter: nil, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:UserObj = UserObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    func getFAQINFO(page:Int = 1,block:@escaping CompletionBlock){
        var  param = ["page":page ?? 1] as [String:Any]
        self.getWithStringUrl(API.faqInfo,parameter: param, header: HDHeader.headerToken()){ (response, message, error) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:UserObj = UserObj.init(json: resJson["data"])
                block(userInfo,message,error)
            }
            else
            {
                block(response,message,error)
            }
        }
    }
    // get thông tin người lao động
    func getProfile(uid:String,block:@escaping CompletionBlock){
        let param = ["uid":uid] as [String:Any]
        self.getWithStringUrl(API.userProfile,parameter: param, header: HDHeader.headerToken()){ (response, message, error) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:UserObj = UserObj.init(json: resJson["data"])
                block(userInfo,message,error)
            }
            else
            {
                block(response,message,error)
            }
        }
    }
    func reportHr(date:String,block:@escaping CompletionBlock){
        let param = ["date":date] as [String:Any]
        self.getWithStringUrl(API.reportHR,parameter: param, header: HDHeader.headerToken()){ (response, message, error) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:DataReport = DataReport.init(json: resJson["data"])
                block(userInfo,message,error)
            }
            else
            {
                block(response,message,error)
            }
        }
//        self.getWithStringUrl(API.reportHR, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
//            if response != nil {
//                let resJson = JSON.init(response!)
//                if errorCode == SUCCESS_CODE {
//                    let datas = resJson["data"].array
//                    var result = [ReportWorkerObj]()
//                    for data in datas ?? [] {
//                        result.append(ReportWorkerObj.init(json: data))
//                    }
//                    block(result, message, errorCode)
//                } else {
//                    block(nil, message, errorCode)
//                }
//            } else {
//                block(nil, message,errorCode)
//            }
//
//        }
    }
    func updateProfile(name:String?,email:String?,address:String?,images:[ImageObj?],birthday:Date?,description:String?,sub_type:CUSTOMTYPE,block:@escaping CompletionBlock){
        let idImg:[String] = images.map{$0?.internalIdentifier ?? ""}
        var param = ["sub_type" : sub_type.rawValue] as [String:Any]
        if address != nil{
            param["address"] = address
        }
        if name != nil{
            param["name"] = name
        }
        if email != nil{
            param["email"] = email
        }
        if birthday != nil{
            param["birthday"] = Utilitys.getTextFromDate("YYYY-MM-dd", birthday) ?? "" //birthday 
        }
        if images != nil{
            param["images"] = Utilitys.jsonParser(parameters: idImg)
        }
        if description != nil{
            param["description"] = description
        }
        self.postWithBody(URL.init(string: API.updateProfile)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    func geInActiveUser(userID:NSInteger,parentID:NSInteger?,block:@escaping CompletionBlock){
        var param = ["id":userID]
        if parentID != nil {
            param["parent_id_many"] = parentID
        }
        self.getWithStringUrl(API.inActiveUser, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson["data"],resJson["message"].string,errorCode)
            }
            else{
                block(nil,message,errorCode)
            }
        }
    }
//    func getProfile(uid:String,block:@escaping CompletionBlock){
//          let param = ["uid":uid]
//        self.getWithStringUrl(API.userProfile, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
//            if  response != nil{
//                let resJson = JSON.init(response!)
//                let userInfo:UserObj = UserObj.init(json: resJson["data"])
//                block(userInfo,message,errorCode)
//            }
//            else
//            {
//                block(response,message,errorCode)
//            }
//        }
//    }
    func checkOtp(otp:String,phone:String,block:@escaping CompletionBlock){
        let param = ["phone":phone,"code":otp]
        self.post(URL.init(string: API.checkOtp ?? "")!, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson["data"],resJson["message"].string,errorCode)
            }
            else{
                block(nil,message,errorCode)
            }
        }
    }
    func resendOtpNewPhone(newPhone:String,block:@escaping CompletionBlock){
        let param = ["phone":newPhone]
        self.post(URL.init(string:API.resendOtpNewPhone)!, parameter: param, header: HDHeader.headerToken(), block: {(response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson,resJson["message"].string,resJson["error"].int ?? ERROR_CODE)
            }
            else{
                block(response,message,errorCode)
            }
        })
    }
    func verifyNewPhone(otp:String,newPhone:String,block:@escaping CompletionBlock){
        let param = ["phone":newPhone,"code":otp]
        self.post(URL.init(string: API.verifyNewPhone )!, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson["data"],resJson["message"].string,errorCode)
            }
            else{
                block(nil,message,errorCode)
            }
        }
    }
//    func getListUser(page:NSInteger,block:@escaping CompletionBlockLoadpage) {
//        self.getWithStringUrl(API.getListUser, parameter: ["page":page], header: HDHeader.headerToken()) { (response, message, errorCode) in
//            if response != nil {
//                let resJson = JSON.init(response!)
//                if errorCode == SUCCESS_CODE {
//                    let datas = resJson["data"].array
//                    var result = [PUserObj]()
//                    for data in datas ?? [] {
//                        result.append(PUserObj.init(json: data))
//                    }
//                    block(result, message,PServices.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
//                } else {
//                    block(nil, message,PServices.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
//                }
//            } else {
//                block(nil, message, false,errorCode)
//            }
//        }
//    }
    func getListAbout(page: Int?,block: @escaping CompletionBlockLoadpage){
        var params:[String:Any] = [String:Any]()
        if page != nil
        {
            params["page"] = page ?? 0
        }
        self.getWithStringUrl(API.listFAQ, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [ListAboutObj]()
                    for data in datas ?? [] {
                        result.append(ListAboutObj.init(json: data))
                    }
                    block(result, message,Services.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,Services.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }

        }
    }
    func getListBank(page: Int?,block: @escaping CompletionBlockLoadpage){
        var params:[String:Any] = [String:Any]()
        if page != nil
        {
            params["page"] = page ?? 0
        }
        self.getWithStringUrl(API.bankList, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [ListBankObj]()
                    for data in datas ?? [] {
                        result.append(ListBankObj.init(json: data))
                    }
                    block(result, message,Services.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,Services.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }
            
        }
    }
    func getListAsked(fid:String,block:@escaping CompletionBlockLoadpage) {
        var params:[String:Any] = [String:Any]()
        params["fid"] = fid
        
        self.getWithStringUrl(API.listAsked, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [ListAskObj]()
                    for data in datas ?? [] {
                        result.append(ListAskObj.init(json: data))
                    }
                    block(result, message,self.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,false, errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }
        }
    }

    func deleteNotif(id:String,block:@escaping CompletionBlock) {
        var params:[String:Any] = [String:Any]()
        params["id"] = id
        self.post(URL.init(string: API.deleteNotif)!, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson["data"],resJson["message"].string,errorCode)
            }
            else{
                block(nil,message,errorCode)
            }
        }
    }
// "\(selectedImages.getSize())"
    func uploadImg(selectedImages:UIImage,block:@escaping CompletionBlock){
        //let data = selectedImages.jpegData(compressionQuality: PUtilitys.getCompressQuanlity(image: selectedImages))
        DispatchQueue.main.async {
            if let data = selectedImages.jpegData(compressionQuality: Utilitys.getCompressQuanlity(image: selectedImages)) {
                //let strUrl = "\(API.POST_UPLOAD_IMAGE)?deviceId=\(UserDefaults.resultUDID())"
                let parameters = [
                    :] as [String : Any]
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    multipartFormData.append(data, withName: "file", fileName: "img", mimeType: "image/*")

                }, usingThreshold: UInt64.init(), to: API.mediaUpload, method: .post, headers: HDHeader.headerTokenForUpload()) { (result) in

                    switch result{
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            do {
                                let resJson = try JSON.init(data: response.data!)
                                var img = ImageObj(json: resJson["data"])
                                
                                //block(listData,message,errorCode)
                                block(img, resJson["message"].string,resJson["error"].int ?? ERROR_CODE)
                            }
                            catch{
                                block(nil, "Lỗi upload ảnh", ERROR_CODE)
                            }
                        }
                    case .failure(let error):
                        block(nil, error.localizedDescription,ERROR_CODE)
                    }
                }
            }
        }
    }
    //MARK: NOTIFICATION
    func getListNotification(page:NSInteger,type:Int?,block:@escaping CompletionBlockLoadpage) {
        var params:[String:Any] = [String:Any]()
        params["page"] = page
        if type != nil {
            params["type"] = 1
        }
        self.getWithStringUrl(API.getListNotification, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [NotificationObj]()
                    for data in datas ?? [] {
                        result.append(NotificationObj.init(json: data))
                    }
                    block(result, message,self.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,false, errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }
        }
    }
    func getNotifDetail(notifId:String,block:@escaping CompletionBlock){
        let param = ["id":notifId]
        self.getWithStringUrl(API.getDetailNotification, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE
                {
                    let notifObj:NotificationObj = NotificationObj.init(json: resJson["data"])
                    block(notifObj,resJson["message"].string,errorCode)
                }
                else
                {
                    block(nil,resJson["message"].string,errorCode)
                }
            }
            else{
                block(nil,message,errorCode)
            }
        }
    }
    
    func getCountNotif(block:@escaping CompletionBlock){
        self.getWithStringUrl(API.getCountNotif, parameter: nil, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                block(resJson["data"],resJson["message"].string,errorCode)
            }
            else{
                block(nil,message,errorCode)
            }
        }
    }
    //MARK: ----------------------POST----------------------
    func getListPost(page:NSInteger,block:@escaping CompletionBlockLoadpage) {
        var params:[String:Any] = [String:Any]()
        params["page"] = page
       
        self.getWithStringUrl(API.postList, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [TAPostObj]()
                    for data in datas ?? [] {
                        result.append(TAPostObj.init(json: data))
                    }
                    block(result, message,self.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,false, errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }
        }
    }
    func getPostDetail(postId:String,block:@escaping CompletionBlock){
        let param = ["id":postId]
        self.getWithStringUrl(API.postDetail, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let news:TAPostObj = TAPostObj.init(json: resJson["data"])
                block(news,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    //MARK: LIST JOB
    // get list JOB và vào param để check từng cái thành phần trong list
    //status:Int?
    func getListJob(page:Int?,cate:String?,status:[STATUS_JOB],uid:String?,name:String?,block:@escaping CompletionBlockLoadpage){
        //let startTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.startDate)}
        var statusStr = ""
        for item in status{
            if statusStr == ""{
                statusStr = "\(item.rawValue)"
            }
            else{
                statusStr = "\(statusStr),\(item.rawValue)"
            }
        }
        //let statusJSON = Utilitys.jsonParser(parameters: status.map{$0.rawValue})
        
        var param = [String:Any]()
        if page != nil{
            param["page"] = page ?? 0
        }
        if cate != nil{
            param["cate"] = cate ?? ""
        }
            param["status"] = statusStr
        if uid != nil{
            param["uid"] = uid ?? ""
        }
        if name != nil{
            param ["name"] = name ?? ""
        }
        self.getWithStringUrl(API.jobList, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [TAJobObj]()
                    for data in datas ?? [] {
                        result.append(TAJobObj.init(json: data))
                    }
                    block(result, message,self.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,false, errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }
        }
    }
    func deleteJob(jid:String,block:@escaping CompletionBlock){
        let param = [
            "jid":jid
            ] as [String : Any]
        self.post(URL.init(string: API.deleteJob)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [TAJobObj]()
                    if let items = resJson["data"].array { listData = items.map { TAJobObj.init(json: $0) } }
                    block(listData,message,errorCode)
                }
                else{
                    block(nil,message,errorCode)
                }
            }
        }
    }
    func getListRequest(block:@escaping CompletionBlockLoadpage){
        self.get(URL.init(string: API.listRequest)!, parameter: nil, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [ListRequestObj]()
                    if let items = resJson["data"].array { listData = items.map { ListRequestObj.init(json: $0) } }
                    block(listData,message,self.isLoadMore(data: resJson["dataPage"]),errorCode)
                }
                else{
                    block(nil,message,false,errorCode)
                }
            }
            else{
                block(nil,message,false,errorCode)
            }
        }
    }
    func getListUserHistory(page: Int?,block: @escaping CompletionBlockLoadpage){
        var params:[String:Any] = [String:Any]()
        if page != nil
        {
            params["page"] = page ?? 0
        }
        self.getWithStringUrl(API.userHistory, parameter: params, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [PayMentHistoryOBj]()
                    for data in datas ?? [] {
                        result.append(PayMentHistoryOBj.init(json: data))
                    }
                    block(result, message,Services.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
                } else {
                    block(nil, message,Services.shareInstance.isLoadMore(data: resJson["dataPage"]), errorCode)
                }
            } else {
                block(nil, message, false,errorCode)
            }
            
        }
    }
    func getListRateHistory(uid:String?,jid:String?,page:Int?,block:@escaping CompletionBlockLoadpage){
        var param:[String:Any] = [String:Any]()
        if uid != nil{
            param["uid"] = uid
        }
        if page != nil{
            param["page"] = page ?? 0
        }
        if jid != nil{
            param["jid"] = jid
        }
        self.getWithStringUrl(API.rateHistory, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [RateHistoryObj]()
                    if let items = resJson["data"].array { listData = items.map { RateHistoryObj.init(json: $0) } }
                    block(listData,message,self.isLoadMore(data: resJson["dataPage"]),errorCode)
                }
                else{
                    block(nil,message,false,errorCode)
                }
            }
            else{
                block(nil,message,false,errorCode)
            }
        }
    }
    
    /// xác nhận hoàn thành sớm
    ///
    /// - Parameters:
    ///   - idUsers: mảng id của người lao động
    ///   - isAccpept: Accpent hay không
    ///   - jid: id công việc
    func verifyJob(idUsers:[String],isAccpept:Bool,jid:String,block:@escaping CompletionBlock){
        let param = [
            "id": idUsers.joined(separator:","),
            "type":isAccpept ? 1 : 0,
            "jid":jid
            ] as [String : Any]
        self.post(URL.init(string: API.verifyJob)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    //MARK:Job
    func   create(name:String,cid:String,person:Int,address:String,content:String,condition:[ConditionObj?],pictures:[ImageObj?],timeWork:[TimeWorkObj],list_invite:String?,status:JOB_TRANGTHAI,lat:Double,lng:Double,hr_name:String,hr_phone:String,address_component:String,block:@escaping CompletionBlock){
//        let startTime = timeWork.map{$0.startTime?.show()}
//        let endTime = timeWork.map{$0.endTime?.show()}
        let startTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.startDate)}
        let endTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.endDate)}
        let priceShift = timeWork.map{$0.price_shift ?? 0}
        let idImg = pictures.map{$0?.internalIdentifier ?? ""}
        let idCodition = condition.map{$0?.internalIdentifier ?? ""}
        var param = [
            "hr_name": hr_name,
            "hr_phone": hr_phone,
            "name": name,
            "cid": cid,
            "person": person,
            "address": address,
            "content": content,
            "status":status.rawValue,
            "start_time": Utilitys.jsonParser(parameters: startTime),
            "end_time": Utilitys.jsonParser(parameters: endTime),
            "lng":lng,
            "lat":lat,
            "address_component":address_component,
            "price_shift": Utilitys.jsonParser(parameters: priceShift)
            ] as [String:Any]
        if !(list_invite?.isEmpty ?? true){
            param["list_invite"] =  list_invite
        }
        if condition != nil{
            param["condition"] = Utilitys.jsonParser(parameters: idCodition)
        }
        if pictures != nil{
            param["pictures"] = Utilitys.jsonParser(parameters: idImg)
        }
        self.post(URL.init(string: API.jobCreate)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:TAJobObj = TAJobObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    func jobPrice(cid:String,person:Int,condition:[ConditionObj?],timeWork:[TimeWorkObj],block:@escaping CompletionBlock){
        let startTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.startDate)}
        let endTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.endDate)}
        let idCodition = condition.map{$0?.internalIdentifier ?? ""}
        var param = [
            "cid":cid,
            "person":person,
            "condition":idCodition,
            "start_time": Utilitys.jsonParser(parameters: startTime),
            "end_time": Utilitys.jsonParser(parameters: endTime),
            ] as [String : Any]
        if condition != nil{
            param["condition"] = Utilitys.jsonParser(parameters: idCodition)
        }
        self.post(URL.init(string: API.estimatedPrice)!, parameter: param, header: HDHeader.headerToken()) {(response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:PriceObj = PriceObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
                //block(resJson["data"].int64,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
            
        }
    }
    func   editJob(id:String,name:String,cid:String,person:Int,address:String,content:String,condition:[ConditionObj],pictures:[ImageObj],timeWork:[TimeWorkObj],status:JOB_TRANGTHAI,lat:Double,lng:Double,hr_name:String,hr_phone:String,address_component:String,block:@escaping CompletionBlock){
//        let startTime = timeWork.map{$0.startTime?.show()}
//        let endTime = timeWork.map{$0.endTime?.show()}
        let startTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.startDate)}
        let endTime = timeWork.map{Utilitys.getTextFromDate("yyyy-MM-dd HH:mm", $0.endDate)}
        let priceShift = timeWork.map{$0.price_shift ?? 0}
        let idImg = pictures.map{$0.internalIdentifier ?? ""}
        let idCodition = condition.map{$0.internalIdentifier ?? ""}
        var param = [
            "hr_name": hr_name,
            "hr_phone": hr_phone,
            "id":id,
            "name": name,
            "cid": cid,
            "person": person,
            "address": address,
            "content": content,
            "status":status.rawValue,
            "start_time": Utilitys.jsonParser(parameters: startTime),
            "end_time": Utilitys.jsonParser(parameters: endTime),
            "lng":lng,
            "lat":lat,
            "address_component":address_component,
            "price_shift": Utilitys.jsonParser(parameters: priceShift)
            ] as [String:Any]
        
        if condition.count > 0{
            param["condition"] = Utilitys.jsonParser(parameters: idCodition)
        }
        if pictures.count > 0{
            param["pictures"] = Utilitys.jsonParser(parameters: idImg)
        }
        self.post(URL.init(string: API.jobEdit)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:TAJobObj = TAJobObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    func   publishJob(id:String,block:@escaping CompletionBlock){
        //        let startTime = timeWork.map{$0.startTime?.show()}
        //        let endTime = timeWork.map{$0.endTime?.show()}
        
//        let idImg = pictures.map{$0.internalIdentifier ?? ""}
        var param = [
            "jid":id,
            ] as [String:Any]
        
//        if pictures.count > 0{
//            param["pictures"] = Utilitys.jsonParser(parameters: idImg)
//        }
        self.post(URL.init(string: API.publishJob)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:TAJobObj = TAJobObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    func getWorkerByRadius(jid:String,block:@escaping CompletionBlock){
        let param = ["jid": jid ] as [String:Any]
        self.getWithStringUrl(API.getWorkerByRadius, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [WorkerByRadiusObj]()
                    if let items = resJson["data"].array { listData = items.map { WorkerByRadiusObj.init(json: $0) } }
                    block(listData,message,errorCode)
                }
                else{
                    block(nil,message,errorCode)
                }
            }
        }
    }
    func userRequest(jid:String,block:@escaping CompletionBlockLoadpage){
        let param = ["jid": jid ] as [String:Any]
        self.getWithStringUrl(API.listUserRequest, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [ListUser]()
                    if let items = resJson["data"].array { listData = items.map { ListUser.init(json: $0) } }
                    block(listData,message,false,errorCode)
                }
                else{
                    block(nil,message,false,errorCode)
                }
            }
        }
    }
    func getCondition(block:@escaping CompletionBlock){
        self.get(URL.init(string: API.jobCondition)!, parameter: nil, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [ConditionObj]()
                    if let items = resJson["data"].array { listData = items.map { ConditionObj.init(json: $0) } }
                    block(listData,message,errorCode)
                }
                else{
                    block(nil,message,errorCode)
                }
            }
        }
    }
    func getCate(uid:String?,block:@escaping CompletionBlock){
        var param: [String:Any]?
        if uid != nil{
            param = [:]
            param?["uid"] = uid
        }
        self.getWithStringUrl(API.jobCate, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if errorCode == SUCCESS_CODE{
                if let resJson = response as? JSON{
                    var listData = [CateObj]()
                    if let items = resJson["data"].array { listData = items.map { CateObj.init(json: $0) } }
                    block(listData,message,errorCode)
                }
                else{
                    block(nil,message,errorCode)
                }
            }
        }
    }
    func getjobDetail(id:String,block:@escaping CompletionBlock){
        let param = ["id": id ] as [String:Any]
        self.getWithStringUrl(API.jobDetail, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:TAJobObj = TAJobObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    //,idWorker:[String]
    func CancelHR(jid:String,block:@escaping CompletionBlock){
        let param =
            [
                "jid":jid,
                //"uids": Utilitys.jsonParser(parameters: idWorker)
            ] as [String:Any]
        self.post(URL.init(string: API.jobCancel)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    
    func resolveJob(idJob:String,idWorker:[String],type:TypeCompleteWork,block:@escaping CompletionBlock) {
        let param =
        [
            "jid":idJob,
            "type":type.rawValue,
            "uids": Utilitys.jsonParser(parameters: idWorker)
        ] as [String:Any]
        self.post(URL.init(string: API.jobResolve)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let result:TAJobObj = TAJobObj.init(json: resJson["data"])
                block(result,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    func updateCate(cate_ids:[CateObj],block:@escaping CompletionBlock){
        let idCate = cate_ids.map{$0.internalIdentifier ?? ""}
        let param =
            [
                "cate_ids": Utilitys.jsonParser(parameters: idCate)
                ] as [String:Any]
        self.post(URL.init(string: API.updateCate)!, parameter: param, header: HDHeader.headerToken()){(response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let result:TAJobObj = TAJobObj.init(json: resJson["data"])
                block(result,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    //MARK:Rate
    func rateHr(jid:String,rate:String,desc:String,target_user:String,block:@escaping CompletionBlock){
        let param = [
            "jid":jid,
            "rate":rate,
            "desc":desc,
            "target_user":target_user
        ] as [String:Any]
        self.post(URL.init(string: API.rateHr)!, parameter: param, header: HDHeader.headerToken()){(response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let userInfo:UserObj = UserObj.init(json: resJson["data"])
                block(userInfo,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
    }
    //MARK:Bid
    //    MARK: GOOGLE MAP
    //tim kiem dia diem
    func searchPlaceByKeyGGM(input:String,block:@escaping CompletionBlock) {
        let key = GGMAP.key_search
        let ip = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let strUrl = "\(GGMAP.SEARCH_PLACE_BY_KEY)?key=\(key)&input=\(ip!)"
        let url = URL.init(string: strUrl)
        self.post(url!, parameter: nil, header: nil) { (response, message, errorCode) in
            if response == nil
            {
                block(nil,message,ERROR_CODE)
            }
            else
            {
                let resJson = JSON.init(response!)
                let places = resJson["predictions"].array
                
                if places?.count ?? 0 == 0
                {
                    block(nil,message,ERROR_CODE)
                }
                else
                {
                    var arrPlace = [GGPlaceObj]()
                    for data in places! {
                        let place = GGPlaceObj()
                        let adr = data["description"].string ?? ""
                        //let adrComponents = data["address_components"]
                        place.addr  = adr.replacingOccurrences(of: ", Vietnam", with: "")
                        place.placeId = data["place_id"].string ?? ""
                        //place.adressComponent = adrComponents
                        arrPlace.append(place)
                    }
                    block(arrPlace,message,SUCCESS_CODE)
                }
            }
        }
    }
    // lay thong tin dia diem theo id
    func getInfoPlaceByIdGGM(placeId:String,block:@escaping CompletionBlock) {
        let key = GGMAP.key_search
        let strUrl = "\(GGMAP.INFO_BY_ID)?key=\(key)&placeid=\(placeId)"
        let url = URL.init(string: strUrl)
        
        self.post(url!, parameter: nil, header: nil) { (response, message, errorCode) in
            if response == nil
            {
                block(nil,message,ERROR_CODE)
            }
            else
            {
                let resJson = JSON.init(response!)
                let locationData = resJson["result"]
                let place = GGPlaceObj()
                place.lat = locationData["geometry"]["location"]["lat"].double ?? 0.0
                place.long = locationData["geometry"]["location"]["lng"].double ?? 0.0
                place.adressComponent = resJson["result"]["address_components"]
                block(place,message,SUCCESS_CODE)
            }
        }
    }
    // lay thong tin theo geo code
    func getInfoPlaceByGeoCodeGGM(lat:String,log:String,block:@escaping CompletionBlock) {
        let key = GGMAP.key_search
        let strUrl = "\(GGMAP.INFO_BY_GEOCODE)?key=\(key)&latlng=\(lat),\(log)"
        let url = URL.init(string: strUrl)
        
        self.post(url!, parameter: nil, header: nil) { (response, message, errorCode) in
            if response == nil {
                block(nil,message,ERROR_CODE)
            } else {
                let resJson = JSON.init(response!)
                let data = resJson["results"].array
                
                if data?.count ?? 0 == 0 {
                    block(nil,message,ERROR_CODE)
                } else {
                    let locationData = data?.first
                    let place = GGPlaceObj()
                    place.lat = locationData!["geometry"]["location"]["lat"].double ?? 0.0
                    place.long = locationData!["geometry"]["location"]["lng"].double ?? 0.0
                    let adr = locationData!["formatted_address"].string ?? ""
                    let adrComponents = locationData!["address_components"]
                    place.adressComponent = adrComponents
                    place.addr  = adr.replacingOccurrences(of: ", Vietnam", with: "")
                    block(place,message,SUCCESS_CODE)
                }
            }
        }
    }
    // GET tuyến đường
    func getRouteGGM(departure: GGPlaceObj,destination: GGPlaceObj,block:@escaping CompletionBlock) {
        let from = "\(departure.lat ?? 0),\(departure.long ?? 0)"
        let to = "\(destination.lat ?? 0),\(destination.long ?? 0)"
        
        let urlStr = "\(GGMAP.GET_ROUTE)?origin=\(from)&destination=\(to)&mode=driving&key=\(GGMAP.key_map)"
        let url = URL(string: urlStr)
        get(url!, parameter: nil, header: nil) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                let routes = resJson["routes"].array
                if routes?.count ?? 0 > 0 {
                    block(routes,resJson["error_message"].string,SUCCESS_CODE)
                }
                block(nil,resJson["error_message"].string,ERROR_CODE)
            } else {
                block(nil,message,ERROR_CODE)
            }
        }
    }
    ///
    ///
    /// - Parameters:
    ///   - sid: id social
    ///   - socialType: 1: facebook, 0:google
    ///   - block:
    func checkLoginSocial(sid:String,socialType:Int,block:@escaping CompletionBlock){
        let url = "\(API.CHECK_LOGIN_SOCIAL)?type_id=\(socialType)&sid=\(sid)&uuid=\(UserDefaults.resultUUID())&token=\(UserDefaults.resultDeviceToken())&platform=\(1)&type=0"
        Services.shareInstance.get(URL.init(string: url)!, parameter: nil, header: nil) { (response, message, errorCode) in
            if response != nil {
                if errorCode == SUCCESS_CODE {
                    let resJson = JSON.init(response!)
                    if resJson[KEY.KEY_API.data][KEY.KEY_API.data].dictionary != nil{
                        UserDefaults.saveUserObj(obj: UserObj.init(json: resJson[KEY.KEY_API.data][KEY.KEY_API.data]))
                        UserDefaults.saveTokenLogin(resJson[KEY.KEY_API.data]["access_token"].string ?? "")
                        DataCenter.sharedInstance.token = resJson[KEY.KEY_API.data]["access_token"].string ?? ""
                        block(resJson, message, errorCode)
                    }
                    else{
                        block(nil, message, errorCode)
                    }
                } else {
                    block(nil, message, errorCode)
                }
            } else {
                block(nil, message, errorCode)
            }
            
        }
    }
    func postBankInfo(bank_name:String,account_name:String,branch_name:String?,bank_code:String,bank_short_name:String,account_number:String,block:@escaping CompletionBlock){
        var param = [
            "bank_name":bank_name,
            "account_name":account_name,
            "bank_code":bank_code,
            "bank_short_name":bank_short_name,
            "account_number":account_number
            ] as [String:Any]
        if !(branch_name?.isEmpty ?? true){
            param["branch_name"] = branch_name
        }
        self.post(URL.init(string: API.postBankInfo)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
            if  response != nil{
                let resJson = JSON.init(response!)
                let result:UserObj = UserObj.init(json: resJson["data"])
                block(result,message,errorCode)
            }
            else
            {
                block(response,message,errorCode)
            }
        }
        
    }
}
class HDHeader {
    class func headerTokenForUpload()-> HTTPHeaders{
        return ["Authorization":"Bearer \(UserDefaults.resultTokenLogin())",
                "Content-type": "multipart/form-data"]
    }
    class func headerTokenTitle()-> HTTPHeaders{
        return ["Authorization":"Bearer \(UserDefaults.resultTokenLogin())",
                "Content-Type":"application/x-www-form-urlencoded"]
    }
    class  func headerToken() -> HTTPHeaders{
        return ["Authorization":"Bearer \(UserDefaults.resultTokenLogin())"]
    }
    class func  headerForLogin() -> HTTPHeaders  {
        return [
            "Content-Type" : "application/x-www-form-urlencoded",
            "deviceid":(UIDevice.current.identifierForVendor?.uuidString)!]
    }
    
 }

