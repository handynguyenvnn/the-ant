//
//  TaClAvaCollectionViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import SDWebImage
class TaClAvaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imaAva: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillData(obj:UserWorkers){
        imaAva.sd_setImage(with: URL.init(string: obj.avatar ?? "") , placeholderImage: nil, options: .refreshCached, completed: nil)
    }

}
