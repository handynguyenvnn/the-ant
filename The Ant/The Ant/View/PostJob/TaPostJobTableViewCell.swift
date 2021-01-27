//
//  TaPostJobTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import DatePickerDialog

protocol choiceTimeDelege {
    func choiceTime(index:IndexPath,isChoiceStart:Bool)
    func choiceDate(valuaDate:Date?,index:IndexPath,isChoiceStart:Bool)
}
protocol ReportTimeCellDelegate {
    func deleteTime(indexTime:Int?)
}
/// thoi gian toi thieu de bat dau cong viec tinh tu thoi diem hien tai(phut)
let MIN_TO_START_TIME:Int = 15
/// thoi gian toi thieu 1 ca
let MIN_TIME_SHIFT:Int = 1
class TaPostJobTableViewCell: UITableViewCell {

    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbCa: UILabel!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var txtEnd: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var txtStart: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    var birthday:Date = Date()
    var delegate:choiceTimeDelege?
    var index:IndexPath?
    var indexTime:Int?
    var delegateTimeCell:ReportTimeCellDelegate?
    var curentTime:TimeWorkObj?
    var curentPrice:PriceObj?
    var listTimeWord = [TimeWorkObj]()
    override func awakeFromNib() {
        super.awakeFromNib()
        txtStart.adjustsFontSizeToFitWidth = true
        txtEnd.adjustsFontSizeToFitWidth = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
    @IBAction func onStartTime(_ sender: Any) {
        //btnStart.isSelected = !btnStart.isSelected
        //txtStart.text = "Thời gian bắt đầu"
        var maxTime:Date?
        if curentTime?.endDate != nil{
             maxTime = NSCalendar.current.date(byAdding: .minute, value: -MIN_TIME_SHIFT, to: curentTime?.endDate ?? Date()) ?? Date()
        }
        let minTime = NSCalendar.current.date(byAdding: .minute, value: MIN_TO_START_TIME, to: Date()) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show(
            "Thời gian",
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            defaultDate:curentTime?.startDate ?? Date(),
            minimumDate:minTime,
            maximumDate:maxTime,
            datePickerMode:.dateAndTime) {
                (date) -> Void in
                if let dt = date {
                    self.birthday = dt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm "
                    //self.txtStart.text = formatter.string(from: dt)
                    if self.delegate != nil && self.index != nil
                    {
                        self.delegate?.choiceDate(valuaDate:dt,index: self.index ?? IndexPath(), isChoiceStart: true)
                    }
                    
                }
        }
       
    }
    @IBAction func onEndTime(_ sender: Any) {
        //txtEnd.text = "Thời gian kết thúc"
         let minTime = NSCalendar.current.date(byAdding: .minute, value: MIN_TIME_SHIFT, to: curentTime?.startDate ?? Date()) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show(
            "Thời gian",
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            defaultDate:curentTime?.endDate ?? Date(),
            minimumDate:minTime,
            datePickerMode: .dateAndTime) {
                (date) -> Void in
                if let dt = date {
                    self.birthday = dt

                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    //self.txtEnd.text = formatter.string(from: dt)
                    if self.delegate != nil && self.index != nil
                    {
                        self.delegate?.choiceDate(valuaDate:dt,index: self.index ?? IndexPath(), isChoiceStart: false)
                    }
                }
        }
        btnEnd.isSelected = !btnEnd.isSelected
        
    }
    func setup(obj:TimeWorkObj,indexCellTime:Int? = nil, isHiddenTime:Bool = true){
        btnRemove.isHidden = false
        curentTime = obj
        lbCa.text = "Ca \(((indexCellTime ?? 0)  + 1) )"
        if obj.startDate != nil{
            txtStart.text = Utilitys.getTextFromDate("HH:mm dd-MM-yyyy", obj.startDate)//dd-MM-yyyy|HH:mm
            txtStart.textColor = UIColor.black
            txtStart.font = UIFont.init(name: "Muli-Bold", size: 13)
            btnRemove.isHidden = isHiddenTime
        }
        else{
            txtStart.text = "Thời gian bắt đầu"
            txtStart.textColor = UIColor.lightGray
            txtStart.font = UIFont.init(name: "Muli-Regular", size: 13)
        }
         if obj.endDate != nil{
            txtEnd.text = Utilitys.getTextFromDate("HH:mm dd-MM-yyyy", obj.endDate)
            txtEnd.textColor = UIColor.black
            txtEnd.font = UIFont.init(name: "Muli-Bold", size: 13)
            btnRemove.isHidden = isHiddenTime
        }
         else{
             txtEnd.text = "Thời gian kết thúc"
            txtEnd.textColor = UIColor.lightGray
            txtEnd.font = UIFont.init(name: "Muli-Regular", size: 13)
        }
        //lbMoney.text = "\(Utilitys.getDefaultStringPrice(originString: "\(obj.price ?? 0)" as AnyObject) ) VNĐ"
        lbMoney.text = "Tiền công: \(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.price_shift ?? 0)" as AnyObject) ) VNĐ/h"
        if txtStart.text == "Thời gian bắt đầu" || txtEnd.text == "Thời gian kết thúc" {
            lbTime.text = "Số giờ:"
        }else{
            lbTime.text = "Số giờ: \(Utilitys.getRangeTimeAll(dateRangeStart:Utilitys.getDateFromText("HH:mm dd-MM-yyyy", txtStart.text) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("HH:mm dd-MM-yyyy", txtEnd.text) ?? Date()))"
        }
//        if Utilitys.getDateFromText("yyyy-MM-dd HH:mm",(Utilitys.getTextFromDate("HH:mm/dd-MM-yyyy", obj.endDate))) ?? Date() < Utilitys.getDateFromText("yyyy-MM-dd HH:mm",(Utilitys.getTextFromDate("HH:mm/dd-MM-yyyy", obj.startDate))) ?? Date() {
//            lbTime.text = "Số giờ:"
//        }
        indexTime = indexCellTime
        
    }
    @IBAction func onRemove(_ sender: Any) {
        if delegateTimeCell != nil
        {
            delegateTimeCell?.deleteTime(indexTime: indexTime)
        }
    }
}
