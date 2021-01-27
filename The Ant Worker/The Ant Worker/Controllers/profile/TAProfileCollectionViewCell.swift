//
//  TAProfileCollectionViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/2/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgAva: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    func fillData(obj:String){
//        imgAva.sd_setImage(with: URL.init(string: obj), placeholderImage: nil, options: .refreshCached, completed: nil)
//    }
    func setupData(obj:ImageObj){
        imgAva.sd_setImage(with: URL.init(string: obj.thumb ?? ""), placeholderImage: nil, options: .refreshCached, completed: nil)
        imgAva.sd_setImage(with: URL.init(string: obj.thumb ?? "") , placeholderImage: nil, options: .refreshCached) { (img, error, cachche, link) in
            obj.image = img
        }
    }

}
