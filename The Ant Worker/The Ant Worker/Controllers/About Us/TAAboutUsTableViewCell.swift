//
//  TAAboutUsTableViewCell.swift
//  The Ant
//
//  Created by Tung Nguyen on 7/9/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAAboutUsTableViewCell: UITableViewCell {
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lbQuetions: UILabel!
    @IBOutlet weak var imIcon: UIImageView!
    var currentAbout:ListAboutObj?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setupCell(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.viewAll.UCDropShadowButton()
        }
    }
    func fillData(obj:ListAboutObj?){
        lbQuetions.text = obj?.title ?? ""
        imIcon.isHidden = false
        setupCell()
    }
    func setData(data:String)
    {
        lbQuetions.text = data
        imIcon.isHidden = true
        setupCell()
    }
}
