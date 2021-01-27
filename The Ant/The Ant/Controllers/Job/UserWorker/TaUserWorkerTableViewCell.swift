//
//  TaUserWorkerTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 9/18/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
protocol choiceStarDelegateDetail{
    func choiceStarDetail(index:Int?)
}
let HEIGHT_CELL_USERWORKER = 100
class TaUserWorkerTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lbCurrentPrice: UILabel!
    @IBOutlet weak var lbRealPrice: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbPercentDone: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var imgStar: UIImageView!
    var delegate:choiceStarDelegateDetail?
    var indexSta:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        let transform = CGAffineTransform(scaleX: 1.0, y: 0.4)
        progressView.transform = transform
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupData(obj:UserWorkers,isCheckStar:Bool = false,indexStar:Int? = nil){
        imgAvatar.sd_setImage(with: URL.init(string: obj.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        self.indexSta = indexStar
        btnStar.isHidden = !isCheckStar
        imgStar.isHidden = !isCheckStar
        let realPrice = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.price ?? 0)" as AnyObject))VNĐ"
        lbCurrentPrice.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.price_progress ?? 0)" as AnyObject))VNĐ"
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: realPrice)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        lbRealPrice.attributedText = attributeString
//        lbMoney.text = "\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.price ?? 0)" as AnyObject))VNĐ/\(Utilitys.getDefaultStringPriceFromString(originString:"\(obj.price_progress ?? 0)" as AnyObject))VNĐ"
        lbPercentDone.text = "\(obj.percent_done ?? 0)%"
        progressView.progress = Float(obj.percent_done ?? 0)/100
        lbName.text = obj.name ?? ""
        lbStatus.text = obj.statusText
        let statusColor = UIColor.init(hexString: obj.status_color ?? "")
        lbStatus.textColor = statusColor
        lbPercentDone.textColor = statusColor
        progressView.progressTintColor = statusColor
        if obj.isRate == false{
            imgStar.image = UIImage.init(named: "ic_star_defaul")
        }else{
            imgStar.image = UIImage.init(named: "_ic_star_user")
        }
        
        //viewAll.dropShadow()
    }
    @IBAction func onStar(_ sender: Any) {
        if delegate != nil
        {
            delegate?.choiceStarDetail(index: indexSta)
        }
    }
    
}
