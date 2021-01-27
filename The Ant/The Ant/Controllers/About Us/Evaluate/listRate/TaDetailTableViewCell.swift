//
//  TaDetailTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 9/16/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import HCSStarRatingView
class TaDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewRate: HCSStarRatingView!
    @IBOutlet weak var lbDecs: UILabel!
    @IBOutlet weak var viewAll: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupData(obj:RateHistoryObj){
        lbDecs.text = obj.descriptionValue ?? ""
        viewRate.isUserInteractionEnabled  = false
        viewRate.value = CGFloat(Float(obj.rate ?? Float(CGFloat(MIN_RATE))))
        lbName.text = obj.jobName ?? ""
        viewAll.dropShadow()
    }
    
}
