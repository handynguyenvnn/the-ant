//
//  TaClAvaCollectionViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
protocol choiceStarDelege {
    func choiceStar(index:Int?)
}
class TaClAvaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var imaAva: UIImageView!
    var delegate:choiceStarDelege?
    var indexStar:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillData(obj:UserWorkers?,isCheckStar:Bool = false,indexStar:Int? = nil){
        imaAva.sd_setImage(with: URL.init(string: obj?.avatar ?? "") , placeholderImage: UIImage.init(named: "ic_defaul"), options: .refreshCached, completed: nil)
        self.indexStar = indexStar
        btnStar.isHidden = !isCheckStar
        
        
        
    }
    @IBAction func onStarUser(_ sender: Any) {
        if delegate != nil
        {
            delegate?.choiceStar(index: indexStar)
        }
    }
    
}
