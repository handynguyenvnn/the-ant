//
//  TAEvaluateViewController.swift
//  The Ant
//
//  Created by Anh Quan on 7/8/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TAEvaluateViewController: UIViewController {
    @IBOutlet weak var ImageAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEvaluate: UILabel!
    @IBOutlet weak var btEvaluate: UIButton!
    @IBOutlet weak var checkStar1: UIImageView!
    @IBOutlet weak var checkStar2: UIImageView!
    @IBOutlet weak var checkStar3: UIImageView!
    @IBOutlet weak var checkStar4: UIImageView!
    @IBOutlet weak var checkStar5: UIImageView!
    
    var isEvaluate = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickEvaluate(_ sender: Any) {
    }
    @IBAction func clickStar1(_ sender: Any) {
        isEvaluate = !isEvaluate
        if isEvaluate{
            checkStar1.image = UIImage.init(named: "ic_Star")
        }
        else{
            checkStar1.image = UIImage.init(named: "ic_unstar")
        }
        
    }
    @IBAction func clickStar2(_ sender: Any) {
        isEvaluate = !isEvaluate
        if isEvaluate{
            checkStar2.image = UIImage.init(named: "ic_Star")
        }
        else{
            checkStar2.image = UIImage.init(named: "ic_unstar")
        }
    }
    @IBAction func clickStar3(_ sender: Any) {
        isEvaluate = !isEvaluate
        if isEvaluate{
            checkStar3.image = UIImage.init(named: "ic_Star")
        }
        else{
            checkStar3.image = UIImage.init(named: "ic_unstar")
        }
    }
    @IBAction func clickStar4(_ sender: Any) {
        isEvaluate = !isEvaluate
        if isEvaluate{
            checkStar4.image = UIImage.init(named: "ic_Star")
        }
        else{
            checkStar4.image = UIImage.init(named: "ic_unstar")
        }
    }
    @IBAction func clickStar5(_ sender: Any) {
        isEvaluate = !isEvaluate
        if isEvaluate{
            checkStar5.image = UIImage.init(named: "ic_Star")
        }
        else{
            checkStar5.image = UIImage.init(named: "ic_unstar")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
