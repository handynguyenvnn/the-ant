//
//  TaTbSpecialConditionTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
let HEIGHT_CELL_CODIONTION = 23
class TaTbSpecialConditionTableViewCell: UITableViewCell {

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
    @IBAction func onImage(_ sender: Any) {
        //btnImage.isSelected = !btnImage.isSelected
    }
    
}
