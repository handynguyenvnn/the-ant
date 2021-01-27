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
        imaDetail.cornerRadius = 5
        
        // Initialization code
    }
    func fillData(obj:ImageObj?){
        imaDetail.sd_setImage(with: URL.init(string: obj?.thumb ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        imaDetail.sd_setImage(with: URL.init(string: obj?.thumb ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached) { (img, error, cachche, link) in
            obj?.image = img
        }
    }

}
