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
        imPhoto.sd_setImage(with: URL.init(string: obj?.avatar ?? ""), placeholderImage: UIImage.init(named: "8821a1af396fdc31857e"), options: .refreshCached, completed: nil)
        setupCell()
}
}
