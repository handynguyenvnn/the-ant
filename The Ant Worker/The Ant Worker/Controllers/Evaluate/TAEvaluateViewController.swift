//
//  TAEvaluateViewController.swift
//  The Ant
//
//  Created by Anh Quan on 7/8/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Toaster
import MBProgressHUD
class TAEvaluateViewController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var ImageAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEvaluate: UILabel!
    @IBOutlet weak var btEvaluate: UIButton!
    @IBOutlet weak var viewStar: HCSStarRatingView!
    @IBOutlet weak var txtDecs: UITextView!
    var superView:TAJobViewController?
    var currentUserRate:UserWorkers?
    var isEvaluate = false
    var cates:CateObj?
    var jobObj:TAJobObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStar.addTarget(self, action: #selector(changeRate),for: UIControl.Event.valueChanged)
        txtDecs.text = "Đánh giá"
        txtDecs.delegate = self
        txtDecs.textColor = UIColor.lightGray
        fillData()
        viewStar.minimumValue = CGFloat(MIN_RATE)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAll.layer.cornerRadius = 10.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Đánh giá"
            textView.textColor = UIColor.lightGray
        }
    }
//    func textFieldDidBeginEditing(textField: UITextField) {
//
//        if txtDecs.isFirstResponder() == true {
//            txtDecs.placeholder = nil
//        }
//    }
    @IBAction func clickEvaluate(_ sender: Any) {
        self.rate()
    }
    @objc func changeRate()
    {
        let rate = Float(viewStar?.value ?? 0.0)
        

    }
    func fillData(){
        lbName.text = jobObj?.user?.name ?? ""
        ImageAvatar.sd_setImage(with: URL.init(string: jobObj?.user?.avatar ?? ""), placeholderImage: nil, options: .refreshCached, completed: nil)
        if jobObj?.isRate ?? false{
            viewStar.isUserInteractionEnabled = false
            txtDecs.isEditable = false
            txtDecs.textColor = UIColor.black
            btEvaluate.isHidden = true
            txtDecs.text = jobObj?.rateObj?.note
            viewStar.value = CGFloat(jobObj?.rateObj?.star ?? 0)
        }
    }
    func rate(){
        var feedBack = ""
        if txtDecs.text == "Đánh giá"{
            feedBack = ""
        }else{
            feedBack = txtDecs.text
        }
        Services.shareInstance.rateWorker(jid: jobObj?.internalIdentifier ?? "", rate: "\(viewStar?.value ?? CGFloat(MIN_RATE))",  desc: feedBack ){(response, message, errorCode) in
                Toast(text: message, delay: 0, duration: 1).show()
                if errorCode == SUCCESS_CODE{
                    self.dismiss(animated: true, completion: nil)
                    if self.superView != nil{
                        self.superView?.reloadData()
                    }
                }
        }
    }
    
}
    
