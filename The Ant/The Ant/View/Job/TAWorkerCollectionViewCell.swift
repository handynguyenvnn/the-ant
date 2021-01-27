//
//  TAWorkerCollectionViewCell.swift
//  The Ant
//
//  Created by Khiem on 2019-07-17.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAWorkerCollectionViewCell: UICollectionViewCell {
    static let height:CGFloat = 170
    static let width:CGFloat = 120
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(obj:UserWorkers?)  {
        imgCheck.isHidden = !(obj?.isChecked ?? false)
        lbName.text = obj?.name ?? ""
        imgAvatar.sd_setImage(with: URL.init(string: obj?.avatar ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
    }
}
