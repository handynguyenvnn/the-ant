//
//  TaClDetailCollectionViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TaClDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imaDetail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillDataDetail(obj:ImageObj?){
        imaDetail.sd_setImage(with: URL.init(string: obj?.thumb ?? "") , placeholderImage: nil, options: .refreshCached, completed: nil)
        imaDetail.sd_setImage(with: URL.init(string: obj?.thumb ?? "") , placeholderImage: nil, options: .refreshCached) { (img, error, cachche, link) in
            obj?.image = img
        }
    }
}
