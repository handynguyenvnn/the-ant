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
                            self.login(phone: userName, password:password ?? "", block: { (response2, message2, errorCode2) in
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
    func register(name:String,password:String,rePassword:String,phone:String,birthday:String,email:String?,ava:UIImage?,socialId:String?,block:@escaping CompletionBlock){
        var param = [
            "name":name,
            "password":password,
            "re-password":rePassword,
            "phone":phone,
            "birthday":birthday,
            "uuid": UserDefaults.resultUUID(),
            ] as [String:Any]
        if email != nil{
            param["email"] = email ?? ""
        }
        if socialId != nil{
            param["sid"] = socialId ?? ""
        }
//        if social_type != nil{
//            param["social_type"] = social_type
//        }
//        if social_id != nil{
//            param["social_id"] = social_id ?? ""
//        }
        if ava == nil{
            self.post(URL.init(string: API.register)!, parameter: param, header: nil, block: block)
        }
        else{
            self.registerWithAva(selectedImages: ava ?? UIImage(), param: param, block: block)
        }
    }
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
    func reportWorker(date:String, block:@escaping CompletionBlock) {
        let param = ["date": date] as [String:Any]
        self.getWithStringUrl(API.reportWorker, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil{
                let resJson = JSON.init(response!)
                if errorCode ==  SUCCESS_CODE
                {
                    let datas = resJson["data"].array
                    var result = [ReportWorkerObj]()
                    for data in datas ?? []
                    {
                        result.append(ReportWorkerObj.init(json: data))
                    }
                    block(result, message, errorCode)
                }
                else{
                    block(nil, message, errorCode)
                }
            }
            else{
                block(nil, message, errorCode)
            }
        }
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
    func verify(code:String,phone:String,newPass:String,password:String,block:@escaping CompletionBlock){
        var deviceToken:String = Utilitys.getDefaultString(originString: UserDefaults.resultUUID() as AnyObject)
        if deviceToken == "" {
            deviceToken = SIMULATOR_TOKEN
        }
        let param:[String:Any] = ["code":code,"phone":phone,"password":newPass,"re-password":newPass]
        self.post(URL.init(string: API.verification)!, parameter: param, header: nil, block: block)
        
    }
    func login(phone:String,password:String,block:@escaping CompletionBlock){
        let param = [
            "phone":phone,
            "password":password,
            "uuid":  UserDefaults.resultUUID(),
            "token": UserDefaults.resultDeviceToken(),
            "platform": 1,
            "type":1
            ] as [String:Any]
        self.post(URL.init(string: API.login)!, parameter: param, header: nil, block: block)
    }
    func postRegister(
        name:String,
        password:String,
        re_password:String,
        phone:String,
        email:String?,
        address:String?,
        birthday:Date?,
        type_id:Int?,
        sid:String?,
        sub_type:GENDER,
        block:@escaping CompletionBlock){
        var param = [
            "name":name,
            "password":password,
            "re-password":re_password,
            "phone":phone,
            "type":1,
            "uuid":UserDefaults.resultUUID(),
            "token":UserDefaults.resultDeviceToken(),
            "platform" : 1,
            "sub_type" : sub_type.rawValue
            ] as [String:Any]
        if email != nil{
            param["email"] = email ?? ""
        }
        if birthday != nil{
            param["birthday"] = Utilitys.getTextFromDate("YYYY-MM-dd", birthday) ?? ""
        }
        if sid != nil{
            param["sid"] = sid ?? ""
        }
        if type_id != nil{
            param["type_id"] = type_id ?? ""
        }
        self.postWithBody(URL.init(string: API.register)!, parameter: param, header: nil, block: block)
    }
    
    ///
    ///
    /// - Parameters:
    ///   - sid: id social
    ///   - socialType: 1: facebook, 0:google
    ///   - block: 
    func checkLoginSocial(sid:String,socialType:Int,block:@escaping CompletionBlock){
        let url = "\(API.CHECK_LOGIN_SOCIAL)?type_id=\(socialType)&sid=\(sid)&uuid=\(UserDefaults.resultUUID())&token=\(UserDefaults.resultDeviceToken())&platform=\(1)&type=1"
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
    func forgotPass(phone:String,block:@escaping CompletionBlock){
        let param = ["phone":phone]
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
//    func verify(code:String,phone:String,newPass:String,password:String,block:@escaping CompletionBlock){
//        var deviceToken:String = Utilitys.getDefaultString(originString: UserDefaults.resultUUID() as AnyObject)
//        if deviceToken == "" {
//            deviceToken = SIMULATOR_TOKEN
//        }
//        let param:[String:Any] = ["code":code,"phone":phone,"password":newPass,"re-password":newPass]
//        self.post(URL.init(string: API.verification)!, parameter: param, header: nil, block: block)
//
//    }
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
    func checkOnline(online:Int, block:@escaping CompletionBlock){
        let param = ["online":online] as [String:Any]
        self.post(URL.init(string: API.userOnline)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }

    func getProfile(uid:String,block:@escaping CompletionBlock){
        let param = ["uid":uid] as [String:Any]
        self.getWithStringUrl(API.userProfile, parameter: param, header: HDHeader.headerToken()){ (response, message, error) in
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
    func updateProfile(name:String,email:String,address:String?,birthday:Date?,images:[ImageObj?],description:String?,sub_type:GENDER,block:@escaping CompletionBlock){
        let idImg = images.map{$0?.internalIdentifier ?? ""}
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
            param["birthday"] = Utilitys.getTextFromDate("YYYY-MM-dd", birthday) ?? ""
        }
        if !images.isEmpty{
            param["images"] = Utilitys.jsonParser(parameters: idImg)
        }
        if !(description?.isEmpty ?? true){
            param["description"] = description
        }
        self.post(URL.init(string: API.updateProfile)!, parameter: param, header: HDHeader.headerToken(), block: block)
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
    func trackingLocation(lat:String,lng:String,block:@escaping CompletionBlock){
        self.post(URL.init(string: API.tracking)!, parameter: ["lat":lat,"lng":lng], header: HDHeader.headerToken(), block: block)
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
    func getListJob(page:Int?,cate:String?,status:[STATUS_JOB],type:Int,name:String?,block:@escaping CompletionBlockLoadpage){
        var statusStr = ""
        for item in status{
            if statusStr == ""{
                statusStr = "\(item.rawValue)"
            }
            else{
                statusStr = "\(statusStr),\(item.rawValue)"
            }
        }
        var param = ["type":type] as [String:Any]
        if page != nil{
            param["page"] = page ?? 0
        }
        if cate != nil{
            param["cate"] = cate ?? ""
        }
            param["status"] = statusStr
//        if name != nil{
//            param ["name"] = name ?? ""
//        }
        self.getWithStringUrl(API.jobList, parameter: param.count > 0 ? param : nil, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [TAJobObj]()
                    for data in datas ?? [] {
                        let job = TAJobObj.init(json: data)
                        if job.internalIdentifier != nil
                        {
                            result.append(job)
                        }
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
                    multipartFormData.append(data, withName: "file", fileName: "avartar", mimeType: "image/*")

                }, usingThreshold: UInt64.init(), to: API.uploadImage, method: .post, headers: HDHeader.headerTokenForUpload()) { (result) in

                    switch result{
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            do {
                                let resJson = try JSON.init(data: response.data!)
                                var img = ImageObj(json: resJson["data"])
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
    //MARK:Rate
    func rateWorker(jid:String,rate:String,desc:String,block:@escaping CompletionBlock){
        let param = [
            "jid":jid,
            "rate":rate,
            "desc":desc
            ] as [String:Any]
        self.post(URL.init(string: API.rateWorker)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    //MARK:Job
    func deleteJobInvite(invite_id:String,block:@escaping CompletionBlock){
        let param = [
            "invite_id":invite_id
            ] as [String : Any]
        self.post(URL.init(string: API.deleteJobInvite)!, parameter: param, header: HDHeader.headerToken()){ (response, message, errorCode) in
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
            else{
                block(nil,message,errorCode)
            }
        }
    }
    func cancelWorker(jid:String,block:@escaping CompletionBlock){
        let param = ["jid":jid] as [String:Any]
        self.post(URL.init(string: API.jobCancel)!, parameter: param, header: HDHeader.headerToken(), block: block)
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
    func jobSolved(jid:String,type:Int,uids:[UserObj],block:@escaping CompletionBlock){
        let idUser = uids.map{$0.internalIdentifier ?? ""}
        let param = [
            "jid":jid,
            "type":type,
            "uids":idUser
            ] as [String : Any]
        self.post(URL.init(string: API.jobResolved)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    func verifyJob(bid:String,isAccpept:Bool,block:@escaping CompletionBlock){
        let param = [
            "bid":bid,
            "type":isAccpept ? 1 : 0,
            ] as [String : Any]
        self.post(URL.init(string: API.verifyJob)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    //Mark:bid
    func bidRequest(jid:String,decs:String?,block:@escaping CompletionBlock){
        var param = [
            "jid":jid,
            ] as [String : Any]
        if decs != nil
        {
            param["decs"] = decs
        }
        self.post(URL.init(string: API.bidRequest)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
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
    func updateCate(cate_ids:[CateObj],block:@escaping CompletionBlock){
        let idCate = cate_ids.map{$0.internalIdentifier ?? ""}
        let param =
            [
                "cate_ids": Utilitys.jsonParser(parameters: idCate)
                ] as [String:Any]
        self.post(URL.init(string: API.updateCate)!, parameter: param, header: HDHeader.headerToken()){(response, message, errorCode) in
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
    //Marrk:reposst
    func reportHr(date:String,block:@escaping CompletionBlock){
        let param = ["date":date] as [String:Any]
        self.getWithStringUrl(API.reportWorker, parameter: param, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [ReportWorkerObj]()
                    for data in datas ?? [] {
                        result.append(ReportWorkerObj.init(json: data))
                    }
                    block(result, message, errorCode)
                } else {
                    block(nil, message, errorCode)
                }
            } else {
                block(nil, message,errorCode)
            }
            
        }
    }
    func resolvedJob(jid:String,isDone:Bool,block:@escaping CompletionBlock){
        let param = ["jid":jid,
                     "type": isDone ? 1 : 0] as [String : Any]
        self.post(URL.init(string: API.resolvedJob)!, parameter: param, header: HDHeader.headerToken(), block: block)
    }
    func postBankInfo(bank_id:String,account_name:String,branch_name:String?,account_number:String,block:@escaping CompletionBlock){
        var param = [
            "bank_id":bank_id,
            "account_name":account_name,
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
    func withdrawalRequest(user_id:String,price:String,note:String,block:@escaping CompletionBlock){
        var param = [
            "user_id":user_id,
            "price":price,
            "note":note
            ] as [String:Any]
//        if user_id != nil{
//            param["user_id"] = user_id
//        }
//        if price != nil{
//            param["price"] = price
//        }
//        if note != nil{
//            param["note"] = note
//        }
        self.post(URL.init(string: API.withdrawalRequest)!, parameter: param, header: HDHeader.headerToken(),block: block)
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
    func getListInvite(block: @escaping CompletionBlockLoadpage){
        self.get(URL.init(string: API.jobInvite)!,parameter: nil, header: HDHeader.headerToken()) { (response, message, errorCode) in
            if response != nil {
                let resJson = JSON.init(response!)
                if errorCode == SUCCESS_CODE {
                    let datas = resJson["data"].array
                    var result = [TAJobObj]()
                    for data in datas ?? [] {
                        result.append(TAJobObj.init(json: data))
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
