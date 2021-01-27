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
    
    @IBOutlet weak var viewALl: UIView!
    @IBOutlet weak var viewALL: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupCell(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewALl.UCDropShadowButton()
        }
    }
    func setup(obj:ReportWorkerObj?){
        imPhoto.sd_setImage(with: URL.init(string: obj?.icon ?? ""), placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        lbTime.text = obj?.value ?? ""
        lbTotalMade.text = obj?.title ?? ""
        setupCell()
    }
    
}
