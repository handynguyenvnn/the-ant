//
//  TaInviteUserTableViewCell.swift
//  The Ant Worker
//
//  Created by Quyet on 10/7/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
protocol FeedBackDelegate {
    func feedBack(index:Int?,isReject:Bool)
}
class TaInviteUserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lbPerson: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbNameWorker: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    var index:Int?
    var delegate:FeedBackDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(obj:TAJobObj,IndexCell:Int){
        var shift = ""
        lbNameWorker.text = obj.name ?? ""
        lbAddress.text = obj.address ?? ""
        let firstTime = obj.timeWork?.first
        let lastTime = obj.timeWork?.last
        let minTime = NSCalendar.current.date(byAdding: .minute, value: -10, to: firstTime?.timeWork.startDate ?? Date()) ?? Date()
        if obj.isBid == false{
            if minTime < Date(){
                lbTime.text = "Thời gian nhận việc đã kết thúc."
            }else{
                shift += Utilitys.getRangeTimeReturnString(dateRangeStart: Date(), dateRangeEnd: minTime)
                lbTime.text = "Còn tuyển \(shift)\nLàm việc trong \(obj.total_hour ?? "")"
            }
        }else{
            shift += ""
            if shift == ""
            {
                shift += "\(firstTime?.startTime ?? "") - \(lastTime?.endTime ?? "")"
            }
            lbTime.text = "\(shift)\nLàm việc trong \(obj.total_hour ?? "")"
        }
        lbPerson.text = obj.user?.subTypeCus.des()
        lbPrice.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.total_price ?? 0)" as AnyObject)) VNĐ/người"
        imgAvatar.sd_setImage(with: URL.init(string: obj.user?.avatar ?? ""), placeholderImage: nil, options:.refreshCached, completed: nil)
        viewAll.dropShadow()
        index = IndexCell
        
    }
    
    @IBAction func onAgree(_ sender: Any) {
        if self.delegate != nil && self.index != nil
        {
            self.delegate?.feedBack(index: self.index, isReject: true)
        }
    }
    @IBAction func onReject(_ sender: Any) {
        if self.delegate != nil && self.index != nil
        {
            self.delegate?.feedBack(index: self.index, isReject: false)
        }
    }
}
