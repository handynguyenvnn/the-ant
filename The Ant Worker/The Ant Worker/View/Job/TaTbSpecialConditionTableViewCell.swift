//
//  TaTbSpecialConditionTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TaTbSpecialConditionTableViewCell: UITableViewCell {
    static let heightCell:CGFloat = 20
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var lbContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(obj:ConditionObj){
        lbContent.text = obj.title ?? ""
         btnImage.isSelected = obj.isSelected
    }
}
