//
//  TAProfileCollectionViewCell.swift
//  The Ant Worker
//
//  Created by Tung Nguyen on 8/29/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupData(obj:ImageObj){
        imPhoto.sd_setImage(with: URL.init(string: obj.thumb ?? ""), placeholderImage: nil, options: .queryDiskDataSync, completed: nil)
    }

}
