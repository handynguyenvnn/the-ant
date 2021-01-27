//
//  TaListUserWorkerViewController.swift
//  The Ant
//
//  Created by Quyet on 10/4/19.
//  Copyright © 2019 Tung Nguyen. All rights reserved.
//

import UIKit

class TaListUserWorkerHistoryViewController: BaseViewController {

    @IBOutlet weak var tbViewHistory: UITableView!
    var btCheckAll:UIButton?
    var countSelect = 0
    var jobObj:TAJobObj?
    var listUserWorker = [UserWorkers]()
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowBackButton = true
        isShowHeaderNoti = true
        tbViewHistory.dataSource = self
        tbViewHistory.delegate = self
        tbViewHistory.register(UINib.init(nibName: "TaUserHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TaUserHistoryTableViewCell")
        jobObj?.userWorkers = listUserWorker
        // Do any additional setup after loading the view.
    }
    func addRightButton(){
        btCheckAll = UIButton()
        btCheckAll?.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 44, height: 44))
        btCheckAll?.setImage(UIImage.init(named: "ic_uncheck_all"), for: .normal)
        btCheckAll?.setImage(UIImage.init(named: "ic_check_all"), for: .selected)
        btCheckAll?.addTarget(self, action: #selector(self.checkAllPress), for: .touchUpInside)
        let viewRight = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        viewRight.addSubview(btCheckAll!)
        let itemsContainer = UIBarButtonItem(customView: viewRight)
        self.navigationItem.rightBarButtonItems = [itemsContainer]
    }
    override func onPressRightNavButton() {
        
    }
    @objc func checkAllPress(){
        btCheckAll?.isSelected = !(btCheckAll?.isSelected ?? false)
        listUserWorker.forEach { (data) in
            data.isChecked = btCheckAll?.isSelected ?? false
        }
        tbViewHistory.reloadData()
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
extension TaListUserWorkerHistoryViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserWorker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaUserHistoryTableViewCell", for: indexPath) as! TaUserHistoryTableViewCell
        cell.selectionStyle = .none
        cell.setData(obj: listUserWorker[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listUserWorker[indexPath.row].isChecked = !listUserWorker[indexPath.row].isChecked
        tableView.reloadRows(at: [indexPath], with: .none)
        countSelect += (listUserWorker[indexPath.row].isChecked ? 1 : -1)
        btCheckAll?.isSelected = countSelect == jobObj?.userWorkers?.count
        tbViewHistory.reloadData()
    }
    
    
}
