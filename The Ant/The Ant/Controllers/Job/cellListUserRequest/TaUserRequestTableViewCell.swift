//
//  TaUserRequestTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 9/20/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
class TaUserRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupData(obj:ListUser){
        lbName.text = obj.name ?? ""
        imgAvatar.sd_setImage(with: URL.init(string: obj.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        btnCheck.isSelected = obj.isChecked
        viewAll.dropShadow()
    }
    
}
