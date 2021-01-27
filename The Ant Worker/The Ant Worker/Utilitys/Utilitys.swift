//
//  PUtilitys.swift
//  POC
//
//  Created by longhm on 1/18/19.
//  Copyright © 2019 "". All rights reserved.
//

import UIKit
import CommonCrypto
import RNCryptor
import Toaster
import Toast_Swift
import MapKit
let REG_PHONE_VN = "^0\\d{9,10}$"
//import Toast_Swift
class Utilitys: NSObject {
    //MARK :String
    class func getDefaultString(originString:AnyObject?)->String {
        if originString == nil || (originString is NSNull) || (originString?.isKind(of: NSNull.classForCoder()))!
        {
            return ""
        }
        else
        {
            if originString is String {
                return originString as! String
            }
            else
            {
                let str = String.init(format:"%0.0f",(originString as? Float) ?? 0)
                return str
            }
        }
    }
    //MARK: Validate data
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func getTextFromDate(_ FormatDate:String?,_ date:Date?)->String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        if self.isEmptyString(textCheck: FormatDate)
        {
            dateFormatter.dateFormat = "dd-MM-yyyy"
        }else
        {
            dateFormatter.dateFormat = FormatDate
        }
        if date == nil
        {
            return ""
        }
        let stringDate: String = dateFormatter.string(from: date! as Date)
        return stringDate
    }
    class func backgroundGradient(colorTop:UIColor,colorBottom:UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 0)
        
        return gradientLayer
    }
    class func stringToDate(withFormat: String = "dd-MM-yyyy",strDate:String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        var date:Date?  = Date.init()
        do {
            try date = dateFormatter.date(from: strDate ?? "")
        } catch  {
            return nil
        }
        return date
    }
    class func isEmptyStringOrIncludeAllWhitespace(textCheck:String?) -> Bool {
        var check:Bool? = false
        if textCheck == nil {
            return true
        }
        if ((textCheck? .isKind(of: NSNull.classForCoder()))! || textCheck?.count == 0)
        {
            check = true
        }
        if (textCheck?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count)! <= 0 {
            check = true
        }
        return check!
    }
    class func isEmptyString(textCheck:String?) -> Bool {
        var check:Bool? = false
        if textCheck == nil {
            return true
        }
        if ((textCheck? .isKind(of: NSNull.classForCoder()))! || textCheck?.count == 0)
        {
            check = true
        }
        return check!
    }
    ///tính khoảng time giữa 2 date
    class func getRangeTimeReturnString(dateRangeStart:Date,dateRangeEnd:Date)->String{
        let components = Calendar.current.dateComponents([.day,.hour, .minute], from: dateRangeStart, to: dateRangeEnd)
        return "\(components.day ?? 0) ngày \(components.hour ?? 0) giờ \((components.minute ?? 0)) phút"
    }
    /// tính khoangnr thời gian giữa 2 date trả về kiểu date components
    class func getRangeTimeDateComponents(dateRangeStart:Date,dateRangeEnd:Date)->DateComponents{
        return Calendar.current.dateComponents([.day,.hour, .minute], from: dateRangeStart, to: dateRangeEnd)
    }
    class func getRangeTimeAll(dateRangeStart:Date,dateRangeEnd:Date)->String{
        let components = Calendar.current.dateComponents([.hour, .minute], from: dateRangeStart, to: dateRangeEnd)
        return "\(components.hour ?? 0) giờ \(components.minute ?? 0) phút"
    }
    class func getRangeTimeMinute(dateRangeStart:Date,dateRangeEnd:Date)->String{
        let components = Calendar.current.dateComponents([ .minute], from: dateRangeStart, to: dateRangeEnd)
        return "\((components.minute ?? 0)) phút"
    }
    class func timeToWork(dateRangeStart:Date,dateRangeEnd:Date) ->[String:NSInteger]{
        let components = Calendar.current.dateComponents([.hour, .minute], from: dateRangeStart, to: dateRangeEnd)
        return ["hours":(components.hour ?? 0),"minutes":(components.minute ?? 0)]
    }
    class func isValidFullName(Input:String) -> Bool {
        let RegEx = "^[a-zA-Z_ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶ" +
            "ẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợ" +
        "ụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\\s]+$"
        //        let RegEx = "[A-Z a-z]"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    class func isPhoneNumber (strPhone:String) -> Bool{
        let REG_FIRST_NUMBER_PHONE = "((03[2|3|4|5|6|7|8|9])|(05[6|8|9])|(07[0|9|7|6|8])|(08[1|2|3|4|5|8|9])|(09[1|2|3|4|6|7|8|9|0])|(02)[0-9])+([0-9]{7})\\b"
        if strPhone.count != 10 {
            return false
        }
        var valid = NSPredicate(format: "SELF MATCHES %@", REG_FIRST_NUMBER_PHONE).evaluate(with: strPhone)
        guard valid else {
            return false
        }
        // check do dai sdt
        valid = NSPredicate(format: "SELF MATCHES %@", REG_PHONE_VN).evaluate(with: strPhone)
        guard valid else {
            return false
        }
        return true
    }
    class func getDistanceNum(currentLoc: CLLocation, toLoc:CLLocation) ->Double
    {
        //        var returnStr:String = ""
        let kilometers:CLLocationDistance  = toLoc.distance(from: currentLoc)
        //        let df:MKDistanceFormatter = MKDistanceFormatter()
        //        df.unitStyle = MKDistanceFormatter.DistanceUnitStyle.default
        
        //        returnStr = df.string(fromDistance: kilometers)
        
        
        return round(kilometers/1000)
    }
    class func getDefaultStringQuantityromString(originString:AnyObject?)->String {
        if originString == nil || (originString is NSNull) || (originString?.isKind(of: NSNull.classForCoder()))!
        {
            return "0"
        }
        else
        {
            if originString is String {
                if (originString as! String).isEmpty {
                    return "0"
                }
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal
                formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
                let strOrigin = originString?.replacingOccurrences(of: ".", with: "")
                let textAsFloat = Double(strOrigin!)
                let strReturn = formatter.string(from:NSNumber(value:textAsFloat!))
                return strReturn!
            }
            else
            {
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal
                formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale?
                let strOrigin = formatter.string(from:NSNumber(value:originString as! Double))
                let strReturn = strOrigin?.replacingOccurrences(of: "đ", with: "")
                return strReturn!
            }
        }
    }
    class func jsonParser(parameters:Any) -> String{
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            var JSONString = ""
            JSONString = String(data: jsonData, encoding: String.Encoding.utf8)!
            return JSONString
        }
        catch{
            return ""
        }
    }
    class func getDefaultStringPriceFromString(originString:AnyObject?)->String {
        if originString == nil || (originString is NSNull) || (originString?.isKind(of: NSNull.classForCoder()))!
        {
            return "0"
        }
        else
        {
            if originString is String {
                if (originString as! String).isEmpty {
                    return "0"
                }
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal
                formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
                let strOrigin = originString?.replacingOccurrences(of: ".", with: "")
                let textAsFloat = Double(strOrigin!)
                let strReturn = formatter.string(from:NSNumber(value:textAsFloat!))
                return strReturn!
            }
            else
            {
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.currency
                formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale?
                let strOrigin = formatter.string(from:NSNumber(value:originString as! Double))
                let strReturn = strOrigin?.replacingOccurrences(of: "đ", with: "")
                return strReturn!
            }
        }
    }
    class func priceToString(price: Float?) -> String{
        if price == nil
        {
            return ""
        }
        else
        {
            let formatter = NumberFormatter()
            let strReturn = formatter.string(from:NSNumber(value:price!))
            return strReturn!
        }
    }
    class func convertDateFormatter() -> String
    {
        let date = NSDate()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minute = calendar.component(.minute, from: date as Date)
        let second = calendar.component(.second, from: date as Date)
        return String(format:"%d%d%d%d%d%d", day,month,year,hour,minute,second)
    }
    class func getCurrentDateString()->String
    {
        let date = NSDate()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        return String(format:"Ngày %d tháng %d năm %d", day,month,year)
    }
    class func getCurrentMonthInt()->NSInteger
    {
        let date = NSDate()
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: date as Date)
        return month
    }
    class func getCurrentMonthString()->String
    {
        let date = NSDate()
        let calendar = NSCalendar.current
        let month = calendar.component(.month, from: date as Date)
        return String(format:"Tháng %d", month)
    }
    class func getFontRegularWithSize(size:CGFloat) ->UIFont
    {
        return UIFont.init(name: "AvenirNext-Regular", size: size)!
    }
    class func getFontBoldWithSize(size:CGFloat) ->UIFont
    {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
    class func getFontWithSize(size:CGFloat) ->UIFont
    {
        return UIFont.init(name: "Helvetica Neue", size: size)!
    }
    class func getDateFromText(_ FormatDate:String?,_ stringDate:String?)->Date?
    {
        let dateFormatter:DateFormatter =  DateFormatter()
        if self.isEmptyString(textCheck: FormatDate)
        {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }else
        {
            dateFormatter.dateFormat = FormatDate
        }
        if self.isEmptyString(textCheck: stringDate) {
            return nil
        }
        var date:Date?  = Date.init()
        do {
            try date = dateFormatter.date(from: stringDate ?? "")
        } catch  {
            
        }
        return date
    }
    class func getDateFromTextApi(_ FormatDate:String?,_ stringDate:String?)->Date?
    {
        let dateFormatter:DateFormatter =  DateFormatter()
        if self.isEmptyString(textCheck: FormatDate)
        {
            dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        }else
        {
            dateFormatter.dateFormat = FormatDate
        }
        var date:Date?  = Date.init()
        do {
            try date = dateFormatter.date(from: stringDate!)
        } catch  {
            
        }
        return date
    }
    class func getTypeNameFormArrayType(arrData:NSMutableArray,index:Int)->String
    {
        if arrData.count > index {
            return arrData[index] as! String
        }
        return ""
    }
    class func getTimeWithType(arrData:NSMutableArray,index:Int)->Float
    {
        var timeDay:Float = 0
        if arrData.count > index {
            let textShow = arrData[index] as! String
            if textShow == "am" || textShow == "pm" {
                timeDay = 0.5
            }
            else
                if textShow == "fullday" {
                    timeDay = 1
            }
        }
        return timeDay
    }
    class func getTextFullFromDate(_ date:Date)->String?
    {
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month-1]
        let stringDate: String = String.init(format:"%d-%@-%d",day,monthSymbol!,year)
        return stringDate
    }
    class func getTextFullForReportFromDate(_ date:Date)->String?
    {
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minute = calendar.component(.minute, from: date as Date)
        let second = calendar.component(.second, from: date as Date)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month-1]
        let stringDate: String = String.init(format:"%d:%d:%d %d-%@-%d",hour,minute,second,day,monthSymbol!,year)
        return stringDate
    }
    
    class func getTextFromDate(_ date:Date)->String?
    {
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month-1]
        let stringDate: String = String.init(format:"%d-%@",day,monthSymbol!)
        return stringDate
    }
    class func getDaysInThisWeek(fromDay:Date) -> [Date]? {
        // create calendar
        let timezoneLK = NSTimeZone(forSecondsFromGMT: 25200)
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = timezoneLK as TimeZone
        // today's date
        let today = fromDay
        let todayComponent = calendar.components([.day, .month, .year], from: today as Date)
        
        // range of dates in this week
        let thisWeekDateRange = calendar.range(of: .day, in:.weekOfMonth, for:today as Date)
        
        // date interval from today to beginning of week
        _ = thisWeekDateRange.location - todayComponent.day!
        
        var cal = Calendar.current
        cal.timeZone = timezoneLK as TimeZone
        var component = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fromDay)
        component.to12am()
        cal.firstWeekday =  0
        let beginningOfWeek =  cal.date(from: component)!
        
        // date for beginning day of this week, ie. this week's Sunday's date
        //let beginningOfWeek = calendar.date(byAdding: .day, value: dayInterval, to: today as Date, options: .matchNextTime)
        
        var formattedDays: [Date] = []
        
        for i in 0 ..< 7 {
            let date = calendar.date(byAdding: .day, value: i, to: beginningOfWeek, options: .matchNextTime)!
            formattedDays.append(date)
        }
        return formattedDays
    }

    class func getTextFromDateForAPi(_ FormatDate:String?,_ date:Date?)->String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        if self.isEmptyString(textCheck: FormatDate)
        {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }else
        {
            dateFormatter.dateFormat = FormatDate
        }
        if date == nil
        {
            return ""
        }
        let stringDate: String = dateFormatter.string(from: date! as Date)
        return stringDate
    }
    class func isDifferentVersion() -> Bool {
        let userDefault = UserDefaults.standard
        let versionSave = userDefault.string(forKey: "version")
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        if versionSave != version {
            saveVersionAppOpen(version)
            return true
        }
        return false
    }
    class func getSystemVersion() -> String
    {
        let systemVersion = UIDevice.current.systemVersion
        if self.isEmptyString(textCheck: systemVersion) {
            return ""
        }
        else
        {
            return systemVersion
        }
    }
    class func getVersionApp ()->String
    {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        if self.isEmptyString(textCheck: version) {
            return ""
        }
        else
        {
            return version
        }
    }
    class func saveVersionAppOpen(_ version:String) {
        let userDefault = UserDefaults.standard
        userDefault.set(version, forKey: "version")
        userDefault.synchronize()
    }
    class func setStrikeText(_ label:UILabel?) ->Void
    {
        if ((label == nil) || self.isEmptyString(textCheck: label?.text))
        {
            label?.text = ""
        }
        let attributes:Dictionary = [NSAttributedString.Key.strikethroughStyle:NSNumber.init(value: NSUnderlineStyle.single.rawValue),NSAttributedString.Key.strikethroughColor:UIColor.red]
        let attributedString:NSAttributedString  = NSAttributedString.init(string: (label?.text)!, attributes: attributes)
        label?.attributedText = attributedString
    }
    class func pushViewWithAnimation(_ mainview: UIViewController, navigation: UINavigationController) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Mainview = Storyboard.instantiateViewController(withIdentifier: String(describing: type(of: mainview)))
        navigation.pushViewController(Mainview, animated: true)
    }
    class func animationNextView(view: UIView){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    class func heightForView(text:String, width:CGFloat) -> CGFloat{
        let font = UIFont(name: "Helvetica Light", size: 14.0)
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0,width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    //MARK: Phone utilitys
    class func hideApartOfPhone(strPhone:String?) -> String
    {
        if self.isEmptyString(textCheck: strPhone)
        {
            return ""
        }
        else
        {
            if (strPhone?.count)! >= 8
            {
                var arr = Array(strPhone!)
                for i in 0...arr.count - 1
                {
                    if i > 2 && i < 7
                    {
                        arr[i] = "x"
                    }
                }
                return String(arr)
            }
            else
            {
                return strPhone!
            }
        }
    }
    //MARK: Textfield
    class func setLeftRightViewTextField(textField:UITextField) -> Void
    {
        let viewLeft:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 18, height: textField.frame.size.height))
        textField.leftView = viewLeft
        let viewRight:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: textField.frame.size.height))
        textField.leftView = viewRight
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }
    class func setLeftViewTextField(textField:UITextField) -> Void
    {
        let viewLeft:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 18, height: textField.frame.size.height))
        textField.leftView = viewLeft
        textField.leftViewMode = .always
    }
    class func setRightViewTextfied(textField:UITextField) -> Void
    {
        let viewLeft:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: textField.frame.size.height))
        textField.rightView = viewLeft
        textField.rightViewMode = .always
    }
    class func setRightViewTextfied(textField:UITextField,width:CGFloat) -> Void
    {
        let viewLeft:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: textField.frame.size.height))
        textField.rightView = viewLeft
        textField.rightViewMode = .always
    }
    class func setLeftViewWithImage(imageName:String?,textField:UITextField) -> Void
    {
        if self.isEmptyString(textCheck: imageName)
        {
            return
        }
        else
        {
            let imgLeft:UIImageView = UIImageView.init(image: UIImage.init(named: imageName!))
            imgLeft.contentMode = .scaleAspectFit
            imgLeft.frame = CGRect.init(x: 6, y: 0, width: 28, height: 18)
            textField.leftView = imgLeft
            textField.leftViewMode = .always
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.borderWidth = 0.5
        }
    }
    class func setRightViewWithImage(imageName:String?,textField:UITextField) -> Void
    {
        if self.isEmptyString(textCheck: imageName)
        {
            return
        }
        else
        {
            let leftview:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftView = leftview
            textField.leftViewMode = .always
            let imgRight:UIImageView = UIImageView.init(image: UIImage.init(named: imageName!))
            imgRight.contentMode = .scaleAspectFit
            imgRight.frame = CGRect.init(x: -10, y: 0, width: 28, height: 18)
            textField.rightView = imgRight
            textField.rightViewMode = .always
            textField.layer.cornerRadius = 6
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.borderWidth = 0.5
        }
    }
    class func heightForView(text:String, width:CGFloat, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0,width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    class func widthForView(text:String, height:CGFloat, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0,width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.width
    }
    
    
    class func loadDayName(forDate date: Date?) -> String{
        if date != nil {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date!)
            switch weekDay {
            case 1:
                return "Chủ nhật"
            case 2:
                return "Thứ hai"
            case 3:
                return "Thứ ba"
            case 4:
                return "Thứ tư"
            case 5:
                return "Thứ năm"
            case 6:
                return "Thứ sáu"
            case 7:
                return "Thứ bảy"
            default:
                return ""
            }
        } else {
            return ""
        }
        
    }
    class func documentGuidelinePath(filePath: String)->String?{
        let documentsPath:NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let subPath:NSString = documentsPath.appendingPathComponent("Guideline") as NSString
        let path = subPath.appendingPathComponent(filePath)
        return path
    }
   class func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func getDefaultStringPrice(originString:AnyObject?)->String {
        if originString == nil || (originString is NSNull) || (originString?.isKind(of: NSNull.classForCoder()))!
        {
            return "0"
        }
        else
        {
            if originString is String {
                return originString as! String
            }
            else
            {
                
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.currency
                formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale?
                let strOrigin = formatter.string(from:NSNumber(value:(originString as? Float) ?? Float(originString as? Int64 ?? 0)))
                let strReturn = strOrigin?.replacingOccurrences(of: "₫", with: "")
                return strReturn!
            }
        }
    }
    class func call(phoneNumber:String){
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    class func getCompressQuanlity(image:UIImage) -> CGFloat{
        var compressQuantily:CGFloat = 1.0
        if image.getSize() > MAX_SIZE_IMG_KB {
            compressQuantily = CGFloat(MAX_SIZE_IMG_KB/image.getSize())
            //print("")
        }
        return compressQuantily
    }
    class func encryptAES256(_ string: String) -> String? {
        if IS_ENCRYPT {
            return self.encrypt(plainText: string, password: MASTER_KEY)
        }
        else
        {
            return string
        }
    }
    class func encrypt(plainText : String, password: String) -> String {
        let data: Data = plainText.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
        let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
        return encryptedString
    }
    
    class func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)! // Just get data from encrypted base64Encoded string.
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
            return decryptedString ?? ""
        }
        catch {
            return "FAILED"
        }
    }
}
extension UIView {
    
    func makeCornerRadius(radius:CGFloat = 5,color:UIColor = .clear,width:CGFloat = 0)  {
        layer.cornerRadius = radius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func makeCicrleRadius() {
        layer.cornerRadius = frame.height / 2
    }
    func QuickDropShadowDown() -> Void {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.6
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    func QuickDropShadowNavigationDown() -> Void {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.4
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    func QuickDropShadowNotChangeBackgroundNotCornerRadius() -> Void {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 7.0
    }
    func QuickDropShadowNotChangeBackground() -> Void {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 7.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = self.frame.height / 2
    }
    func QuickDropShadow() -> Void {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.6
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    func NDropShadow(scale: Bool = true) {
        dropShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1), opacity: 0.07, offSet: CGSize(width: 5, height: 5), radius: 10, scale: true)
    }
    func UCDropShadowButton(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 4
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func dropShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 4
    }
    func showToast(message:String,position:ToastPosition)
    {
        var style = ToastStyle()
        style.messageFont = UIFont(name: "Helvetica Neue", size: 15.0)!
        style.messageColor = UIColor.white
        style.messageAlignment = .center
        style.backgroundColor = UIColor.darkGray
        self.makeToast(message, duration: 2.0, position: .top, title: nil, image: nil, style: style, completion: nil)
    }
    
}
extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
//MARK: IMAGE UTILITYS
extension UIImage {
    func resizableImageWithStretchingProperties(
        X: CGFloat, width widthProportion: CGFloat,
        Y: CGFloat, height heightProportion: CGFloat) -> UIImage {
        
        let selfWidth = self.size.width
        let selfHeight = self.size.height
        
        // insets along width
        let leftCapInset = X*selfWidth*(1-widthProportion)
        let rightCapInset = (1-X)*selfWidth*(1-widthProportion)
        
        // insets along height
        let topCapInset = Y*selfHeight*(1-heightProportion)
        let bottomCapInset = (1-Y)*selfHeight*(1-heightProportion)
        
        return self.resizableImage(
            withCapInsets: UIEdgeInsets(top: topCapInset, left: leftCapInset,
                                        bottom: bottomCapInset, right: rightCapInset),
            resizingMode: .stretch)
    }
    /**
     return KB
     */
    func getSize() -> Double{
        if let imageData = self.pngData() {
            let bytes = imageData.count
            return  (Double(bytes) / 1024.0) // Note the difference
        }
        return 0
    }
}
internal extension DateComponents {
    mutating func to12am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }
}
