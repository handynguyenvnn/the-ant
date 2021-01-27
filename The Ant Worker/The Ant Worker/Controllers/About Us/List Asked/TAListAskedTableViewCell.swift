//
//  TAListAskedTableViewCell.swift
//  The Ant
//
//  Created by Anh Quan on 7/31/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAListAskedTableViewCell: UITableViewCell {
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lbQuetions: UILabel!
    @IBOutlet weak var lbAsked: UILabel!
    @IBOutlet weak var lbAnswer: UILabel!
    @IBOutlet weak var viewLine: UIView!
   var currentAsked:ListAskObj?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAll.layer.shadowOpacity = 1
        viewAll.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewAll.shadowRadius = 4
        viewAll.layer.shadowColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }
    func fillData(obj:ListAskObj?,index:Int){
        lbQuetions.text = "Câu \(index + 1)"
        lbAsked.text = obj?.qContent
        lbAnswer.text = obj?.aContent
//        lbQuetions.text = obj?.descriptionValue
        lbAnswer.isHidden = !(obj?.isExpand ?? false)
        viewLine.isHidden = !(obj?.isExpand ?? false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
    }
}
