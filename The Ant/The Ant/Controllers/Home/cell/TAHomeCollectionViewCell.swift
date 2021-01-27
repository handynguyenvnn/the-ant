//
//  TAHomeCollectionViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/2/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgCate: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgAll: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imgAll.isHidden = true
        // Initialization code
    }

    func setupData(obj:CateObj,isShowCheck:Bool = false,isShowImg:Bool = false){
        lbTitle.text = obj.name
        imgCate.sd_setImage(with: URL.init(string: obj.avatar ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        btnStatus.isHidden = isShowCheck
        imgAll.isHidden = isShowImg
        if obj.isSeclect {
            btnStatus.setImage(UIImage.init(named: "ic_checked_large"), for: .normal)
        }else if obj.isTmp{
            btnStatus.setImage(UIImage.init(named: "ic_selected"), for: .normal)
        }else{
            btnStatus.setImage(UIImage.init(named:"ic_unchecked_large"), for: .normal)
        }
//        btnStatus.isSelected = obj.isSeclect
        viewAll.dropShadow()
    }
}
