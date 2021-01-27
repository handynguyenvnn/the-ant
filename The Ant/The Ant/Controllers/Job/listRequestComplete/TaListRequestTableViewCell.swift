//
//  TaListRequestTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 9/3/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
protocol ConfirmCompleteDelegate {
    func choiseConfirm(isAcpent:Bool,index:IndexPath?)
}
class TaListRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var uiViewAll: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    var delegate:ConfirmCompleteDelegate?
    var index:IndexPath?
    var listRequest = [ListRequestObj]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupData(objJob:ListRequestObj?,index:Int,objTime:ListUser?){
        if objJob != nil{
            lbName.text = objJob?.name ?? ""
            imgAvatar.isHidden = true
            uiViewAll.isHidden = true
        }
        if objTime != nil{
            imgAvatar.isHidden = false
            imgAvatar.sd_setImage(with: URL.init(string: objTime?.avatar ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
            lbName.text = objTime?.name ?? ""
            uiViewAll.isHidden = false
        }
    }
    @IBAction func onClose(_ sender: Any) {
        if delegate != nil{
            delegate?.choiseConfirm(isAcpent: false, index: index)
        }
        print("onClose")
    }
    @IBAction func onConfirm(_ sender: Any) {
        if delegate != nil{
            delegate?.choiseConfirm(isAcpent: true, index: index)
        }
        print("onConfirm")
    }
}
