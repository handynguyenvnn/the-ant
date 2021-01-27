//
//  TaTbSpecialConditionPostJobTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
let HEIGHT_CELL_SPE_CODIONTION = 33
class TaTbSpecialConditionPostJobTableViewCell: UITableViewCell {
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
    func setup(obj:CateObj){
        lbContent.text = obj.name ?? ""
        btnImage.isSelected = obj.isSelected
    }
}
