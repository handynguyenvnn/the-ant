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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(obj:CateObj,isShowCheck:Bool = false,isShowBtnStatus:Bool = false){
        btnStatus.isHidden = !isShowBtnStatus
        if isShowCheck
        {
            viewAll.backgroundColor = UIColor.init(hexString: "#3AD29F")
            lbTitle.textColor = UIColor.init(hexString: "#FFFFFF")
        }
        else{
            viewAll.backgroundColor = UIColor.init(hexString: "#FFFFFF")
            lbTitle.textColor = UIColor.init(hexString: "#242B33")
        }
        lbTitle.text = obj.name
        if obj.imgDes == nil
        {
            imgCate.sd_setImage(with: URL.init(string: obj.avatar ?? "") , placeholderImage: nil, options: .refreshCached, completed: nil)
        }
        else
        {
            imgCate.image = obj.imgDes
        }
        btnStatus.isHidden = !isShowBtnStatus
        
        if obj.isSeclect {
            btnStatus.setImage(UIImage.init(named: "ic_checked_large"), for: .normal) //ic xanh
            
        }
        else if obj.isTmp {
            btnStatus.setImage(UIImage.init(named: "ic_selected"), for: .normal)//vang
        }
        else {
            btnStatus.setImage(UIImage.init(named: "ic_unchecked_large"), for: .normal) // đen
        }
        //btnStatus.isSelected = obj.isTmp
        viewAll.dropShadow()
    }
}
