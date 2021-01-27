//
//  TAHomeJobTableViewCell.swift
//  The Ant Worker
//
//  Created by Tung Nguyen on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAHomeJobTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbNumPerson: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var viewAll: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(obj:TAJobObj?){
        viewAll.dropShadow()
        viewAll.cornerRadius = 8.0
        lbTitle.text = obj?.name ?? ""
        var shift = ""
        obj?.timeWork?.forEach({ (time) in
            shift += ""
            if shift == ""
            {
                shift += "\(time.startTime ?? "") - \(time.endTime ?? "")"
            }
            else
            {
                shift += " \n\(time.startTime ?? "") - \(time.endTime ?? "")"
            }
        })
        lbDay.text = shift
        imgAva.sd_setImage(with: URL.init(string: obj?.user?.avatar ?? ""), placeholderImage: nil, options: .refreshCached, completed: nil)
        lbPrice.text = obj?.status_text ?? ""
        lbAddress.text = obj?.address ?? ""
        lbNumPerson.text = "\(obj?.person ?? 0)/\(obj?.person ?? 1)"
    }
}
