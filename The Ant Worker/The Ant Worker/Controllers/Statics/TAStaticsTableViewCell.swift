//
//  TAStaticsTableViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 8/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
class TAStaticsTableViewCell: UITableViewCell {
    @IBOutlet weak var imPhoto: UIImageView!
    @IBOutlet weak var lbTotalMade: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var viewALL: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewALL.layer.shadowOpacity = 1
        viewALL.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewALL.shadowRadius = 4
        viewALL.layer.shadowColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    func setupCell(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
    }
    func setup(obj:ReportWorkerObj?){
        imPhoto.sd_setImage(with: URL.init(string: obj?.icon ?? ""), placeholderImage: nil, options: .refreshCached, completed: nil)
        lbTime.text = obj?.value ?? ""
        lbTotalMade.text = obj?.title ?? ""
        setupCell()
    }
    
}
