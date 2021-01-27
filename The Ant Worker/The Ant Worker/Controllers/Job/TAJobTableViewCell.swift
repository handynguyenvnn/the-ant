//
//  TAJobTableViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
protocol JobCellDelegate {
    func toRate(indexRate:Int)
}

class TAJobTableViewCell: UITableViewCell {
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lbClock: UILabel!
    @IBOutlet weak var lbIncomePerHour: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbRecruiting: UILabel!
    @IBOutlet weak var lbGroup: UILabel!
    @IBOutlet weak var UIPhoto: UIImageView!
    @IBOutlet weak var imRate: UIImageView!
    @IBOutlet weak var viewDangtuyen: UIView!
    @IBOutlet weak var btnEvaluate:UIButton!
    var index:Int?
    var delegate: JobCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAll.layer.shadowOpacity = 1
        viewAll.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewAll.shadowRadius = 4
        viewAll.layer.shadowColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
        viewAll.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
    }
    // rate
    @IBAction func onRatingPressed(_ sender: Any) {
       if delegate != nil
       {
        delegate?.toRate(indexRate: index ?? 0)
        }
    }
    func setup(obj:TAJobObj, isShowRate:Bool = false, isShowImRate:Bool = false)
    {
        setupCell()
        lbName.text = obj.name
        
        var shift = ""
//        var time = ""
//        var totalHour = 0
//        var totalMinute = 0
        let firstTime = obj.timeWork?.first
        let lastTime = obj.timeWork?.last
        /// thời gian bắt đầu của phần tử đầu tiên từ đi 10
        let minTime = NSCalendar.current.date(byAdding: .minute, value: -10, to: firstTime?.timeWork.startDate ?? Date()) ?? Date()
        /// thời gian bắt đầu của phần tử đầu tiên trừ đi thời gian hiện tại
        var time = Utilitys.getRangeTimeMinute(dateRangeStart: Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.startTime) ?? Date())
            if obj.status == 1{
                ///check case đã nhận và nhận công
                if minTime < Date(){
                    lbClock.text = "Thời gian nhận việc đã kết thúc."
                }else{
                    if shift == ""
                    {
                        shift += Utilitys.getRangeTimeReturnString(dateRangeStart: Date(), dateRangeEnd: minTime)
                    }
                    lbClock.text = "Còn tuyển \(shift)\nLàm việc trong \(obj.total_hour ?? "")"
                    lbClock.textColor = UIColor.init(hexString: "#555555")
                    }
                }else if obj.status == 2 {
                /// check case hoạt động
                    var rangeTime = Utilitys.getRangeTimeDateComponents(dateRangeStart: Date(), dateRangeEnd:firstTime?.timeWork.startDate ?? Date())
                    if rangeTime.hour ?? 0 < 0 || rangeTime.minute ?? 0 < 0 || rangeTime.day ?? 0 < 0 {
                        shift +=  "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
                        lbClock.text = "\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
                        lbClock.textColor = UIColor.init(hexString: "#555555")
                    }
                    else{
                        shift +=  "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
                        lbClock.text = "Còn \(time) nữa đến giờ làm việc\n\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
                        lbClock.textColor = UIColor.red
                    }
                }else{
                ///check case lịch sử
                    shift += "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
                lbClock.text = "\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
                lbClock.textColor = UIColor.init(hexString: "#555555")
                }
            
//            if time == ""
//            {
//                time += Utilitys.getRangeTimeReturnString(dateRangeStart: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.startTime) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.endTime) ?? Date())
//            }else{
//                time += Utilitys.getRangeTimeReturnString(dateRangeStart:  Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.startTime) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.endTime) ?? Date())
//            }
//            for itemDate in obj.timeWork ?? [TimeWork](){
//                var totalTime:[String:NSInteger]  = Utilitys.timeToWork(dateRangeStart: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", itemDate.startTime) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", itemDate.endTime) ?? Date())
//                totalHour += totalTime["hours"] ?? 0
//                totalMinute += totalTime["minutes"] ?? 0
//            }
//            totalHour = totalHour + totalMinute/60
//            totalMinute = totalMinute%60
        
        UIPhoto.sd_setImage(with: URL.init(string: obj.user?.avatar ?? ""), placeholderImage: nil, options: .refreshCached, completed: nil)
        lbIncomePerHour.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.total_price ?? 0)" as AnyObject)) VNĐ/người"
        if obj.status == 1 && obj.isBid == false{
            lbLocation.text = obj.sub_address ?? ""
        }else{
            lbLocation.text = obj.address ?? ""
        }
        if obj.status == 3 || obj.status == 4{
            lbLocation.text = obj.sub_address ?? ""
        }
        lbGroup.text = obj.user?.subTypeCus.des()
        lbRecruiting.text = obj.status_text ?? ""
        lbRecruiting.textColor = UIColor.init(hexString: obj.status_text_color ?? "")
        
        // gán giá trị phủ định cho rate và xác định mà cần show rate
        btnEvaluate.isHidden = !isShowRate
        imRate.isHidden = !isShowImRate
        btnEvaluate.isHidden = STATUS_JOB.DONE.rawValue != obj.status
        imRate.isHidden = STATUS_JOB.DONE.rawValue != obj.status
        if obj.isRate == false {
            imRate.image = UIImage.init(named: "ic_star_defaul")
        }else{
            imRate.image = UIImage.init(named: "ic_StarRate")
        }
    }
    
}

