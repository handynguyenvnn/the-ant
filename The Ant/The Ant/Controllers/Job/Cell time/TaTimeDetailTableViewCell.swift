//
//  TaTimeDetailTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 9/17/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
let HEIGHT_CELL_TIME_DETAIL = 122
class TaTimeDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lbSoCa: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbSoGio: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupData(obj:TimeWork,indexCellTime:Int?){
//        var date = ""
//        var time = ""
//        obj.timeWork.forEach({ (item) in
//            date += ""
//            time += ""
//            if date == ""{
//                date += "\(item.startTime ?? "") - \(item.endTime ?? "")"
//                time += Utilitys.getRangeTime(dateRangeStart: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", item.startTime) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", item.endTime) ?? Date())
//            }else{
//                date += "\(item.startTime ?? "") - \(item.endTime ?? "")"
//                time += Utilitys.getRangeTime(dateRangeStart: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", item.startTime) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", item.endTime) ?? Date())
//            }
//        })
//        lbTime.text = date
        //Utilitys.getDateFromText("dd-MM-yyyy HH:mm", obj.startTime)
        //lbTime.text = "\(Utilitys.getDateFromText("dd-MM-yyyy HH:mm", obj.startTime) ?? Date()) - \(Utilitys.getDateFromText("dd-MM-yyyy HH:mm", obj.endTime) ?? Date())"
        lbPrice.text = "Tiền công: \(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.priceShift ?? 0)" as AnyObject) )VNĐ"
        lbTime.text = "\(Utilitys.getTextFromDate("dd-MM-yyyy HH:mm", Utilitys.getDateFromText("yyyy-MM-dd HH:mm", obj.startTime) ?? Date()) ?? "") - \(Utilitys.getTextFromDate("dd-MM-yyyy HH:mm", Utilitys.getDateFromText("yyyy-MM-dd HH:mm", obj.endTime) ?? Date()) ?? "")"
        lbSoCa.text = "Ca \(((indexCellTime ?? 0)  + 1) )"
        lbSoGio.text = "Số giờ làm: \(Utilitys.getRangeTimeAll(dateRangeStart: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", obj.startTime) ?? Date(), dateRangeEnd: Utilitys.getDateFromText("yyyy-MM-dd HH:mm", obj.endTime) ?? Date()))"
    }
    
}
