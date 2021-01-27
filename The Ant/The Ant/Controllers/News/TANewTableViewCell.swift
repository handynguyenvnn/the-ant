//
//  TANewTableViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
class TANewTableViewCell: UITableViewCell {
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imPhoto: UIImageView!
    @IBOutlet weak var lbDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAll.layer.shadowOpacity = 1
        viewAll.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewAll.shadowRadius = 4
        viewAll.layer.shadowColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
    }
    func setup(obj:TAPostObj?)
    {
        lbName.text = obj?.title ?? ""
        lbDate.text = obj?.createdAt ?? ""
             imPhoto.sd_setImage(with: URL.init(string: obj?.avatar ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .queryMemoryData, completed: nil)
           setupCell()
}
}
