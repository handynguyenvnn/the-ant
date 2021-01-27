//
//  TaPostJobTableViewCell.swift
//  The Ant
//
//  Created by Quyet on 7/5/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import DatePickerDialog
protocol choiceTimeDelege {
    func choiceTime(index:IndexPath,isChoiceStart:Bool)
}
class TaPostJobTableViewCell: UITableViewCell {

    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var txtEnd: UITextField!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var txtStart: UITextField!
    var delegate:choiceTimeDelege?
    var index:IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onStartTime(_ sender: Any) {
        //btnStart.isSelected = !btnStart.isSelected
        if delegate != nil && index != nil
        {
            delegate?.choiceTime(index: self.index ?? IndexPath(), isChoiceStart: true)
        }
    }
    @IBAction func onEndTime(_ sender: Any) {
        //btnEnd.isSelected = !btnEnd.isSelected
        if delegate != nil && index != nil
        {
            delegate?.choiceTime(index: self.index ?? IndexPath(), isChoiceStart: false)
        }
    }
    func setup(obj:TimeWorkObj){
        if obj.startTime != nil{
            txtStart.text = obj.startTime?.show()
        }
         if obj.endTime != nil{
            txtEnd.text = obj.endTime?.show()
        }
    }
}
