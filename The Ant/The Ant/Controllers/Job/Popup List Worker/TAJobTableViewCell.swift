//
//  TAJobTableViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 6/28/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
protocol choiseDelegateMap {
    func delegateMap(index:Int?)
}

class TAJobTableViewCell: UITableViewCell {
    @IBOutlet weak var ImgStatus: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lbClock: UILabel!
    @IBOutlet weak var lbIncomePerHour: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbRecruiting: UILabel!
    @IBOutlet weak var lbGroup: UILabel!
    @IBOutlet weak var imPhoto: UIImageView!
    @IBOutlet weak var viewDangTuyen: UIView!
    var delegate:choiseDelegateMap?
    var indexMap:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewAll.layer.shadowOpacity = 1
//        viewAll.layer.shadowOffset = CGSize(width: 0, height: 2)
//        viewAll.shadowRadius = 4
//        viewAll.layer.shadowColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
//        viewAll.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onMap(_ sender: Any) {
        if delegate != nil{
            delegate?.delegateMap(index: indexMap)
        }
        
    }
    func setupCell(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
    }
    func setup(obj:TAJobObj)
    {
        
        setupCell()
        if obj.status == 0{
            viewAll.backgroundColor = UIColor.init(hexString: "#E7E7E7")
            viewDangTuyen.isHidden = true
        }else{
            viewAll.backgroundColor = UIColor.white
            viewDangTuyen.isHidden = false
        }
        //Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.startTime) ?? Date() > Date()
        lbName.text = obj.name
        let firstTime = obj.timeWork?.first
        let lastTime = obj.timeWork?.last
        let minTime = NSCalendar.current.date(byAdding: .minute, value: -10, to: firstTime?.timeWork.startDate ?? Date()) ?? Date()

        //let minTime = NSCalendar.current.date(byAdding: .minute, value: -10, to: firstTime?.timeWork.startDate ?? Date()) ?? Date()
        var shift = ""
        var time = Utilitys.getRangeTimeMinute(dateRangeStart: Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", firstTime?.startTime) ?? Date())
        if obj.status == 1{
            ///check cho case đang tuyển
            if minTime < Date(){
                lbClock.text = "Thời gian nhận việc đã kết thúc."
            }else{
                shift += Utilitys.getRangeTime(dateRangeStart:  Date(), dateRangeEnd:  minTime)
            }
            lbClock.text = "Còn tuyển \(shift)\nLàm việc trong \(obj.total_hour ?? "")"
            lbClock.textColor = UIColor.init(hexString: "#555555")
        }else if obj.status == 2 {
            // check cho case hoạt động
           var rangeTime = Utilitys.getRangeTimeDateComponents(dateRangeStart: Date(), dateRangeEnd:firstTime?.timeWork.startDate ?? Date())
            if rangeTime.hour ?? 0 < 0 || rangeTime.minute ?? 0 < 0 || rangeTime.day ?? 0 < 0 {
                shift +=  "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
            }
            else{
                shift +=  "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
            }
            if rangeTime.hour ?? 0 < 0 || rangeTime.minute ?? 0 < 0 || rangeTime.day ?? 0 < 0{
                lbClock.text = "\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
                lbClock.textColor = UIColor.init(hexString: "#555555")
            }else{
                lbClock.text = "Còn \(time) nữa đến giờ làm việc\n\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
                lbClock.textColor = UIColor.red
                }
            }
        else{
            /// check cho case lịch sử và nháp
            shift += ""
            if shift == ""
            {
                shift += "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
            }
            lbClock.text = "\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
            lbClock.textColor = UIColor.init(hexString: "#555555")
        }
        imPhoto.sd_setImage(with: URL.init(string: obj.user?.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        if obj.total_price != nil{
        lbIncomePerHour.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.total_price ?? 0)" as AnyObject)) VNĐ/người"
        }
        lbLocation.text = obj.address ?? ""
        lbGroup.text = "\(obj.personBid ?? 0)/\(obj.person ?? 0)"
        lbRecruiting.text = obj.status_text ?? ""
        lbRecruiting.textColor = UIColor.init(hexString: obj.status_text_color ?? "")
    }
    
    
}

