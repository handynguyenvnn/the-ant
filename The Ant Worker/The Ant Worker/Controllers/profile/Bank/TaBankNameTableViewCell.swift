//
//  TaBankNameTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 10/3/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import DropDown
//TaBankNameTableViewCell: DropDownCell
 class TaBankNameTableViewCell: DropDownCell {

    //@IBOutlet  weak var optionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    override  func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override  func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
