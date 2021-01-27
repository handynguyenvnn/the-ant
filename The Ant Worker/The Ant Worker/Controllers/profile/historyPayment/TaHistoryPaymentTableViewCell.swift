//
//  TaHistoryPaymentTableViewCell.swift
//  The Ant Worker
//
//  Created by Quyet on 10/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TaHistoryPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var lbLogo: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(obj:PayMentHistoryOBj){
        lbMoney.text = "\(obj.title ?? "") \(Utilitys.getDefaultStringPriceFromString(originString:obj.price as AnyObject? ?? "" as AnyObject))VNĐ"
        lbDate.text = obj.date ?? ""
//        if obj.status == STATUS_PAYMENT.PAYMENT.rawValue {
//
//        }else if obj.status == STATUS_PAYMENT.NO_PAYMENT.rawValue{
//
//        }else if obj.status == STATUS_PAYMENT.NOT_YET_PAYMENT.rawValue{
//
//        }
        lbMoney.textColor = UIColor.init(hexString: obj.color ?? "")
        lbLogo.text = obj.code ?? ""
        viewStatus.backgroundColor = UIColor.init(hexString: obj.background ?? "")
        lbStatus.textColor = UIColor.init(hexString: obj.color ?? "")
        lbStatus.text = obj.status_text ?? ""
        viewAll.dropShadow()
    }
    
}
