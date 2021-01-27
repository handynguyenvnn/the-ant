//
//  GGChooisePlaceViewController.swift
//  Go2Go
//
//  Created by Khiem on 2018-09-15.
//  Copyright © 2018 SuSoft. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleMaps
import GooglePlaces
import Toaster
import CoreLocation

@objc protocol ChooisePlaceDelegate:class {
    @objc optional func chooiceStartPoint(data: GGPlaceObj)
    @objc optional func chooiceEndPoint(data: GGPlaceObj)
}
class GGChooisePlaceViewController: BaseViewController {
    
    @IBOutlet weak var viewChooiceFromMap: UIView!
    @IBOutlet weak var txtPlaceName: SkyFloatingLabelTextField!
    @IBOutlet weak var tbListPlace: UITableView!
    @IBOutlet weak var imgPoint: UIImageView!
    var type:Int? //1 diem nhan hang, 2 diem tra hang
    var dataPlace = [GGPlaceObj]()
    var delegate:ChooisePlaceDelegate?
    var resultsArray = [String]()
    var index:Int = 0
    var addr:String = ""
    var place:GGPlaceObj?
    var isEditStock = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowBackButton = true
        //self.isHeaderProfile = true
        self.isHeaderMap = true
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.chooiceFromMap))
        //self.viewChooiceFromMap.addGestureRecognizer(gesture)
        self.txtPlaceName.addTarget(self, action: #selector(getData), for: .editingChanged)
        self.title = "Chọn địa điểm"
        // Do any additional setup after loading the view.
    }
    override func initUI() {
        tbListPlace.register(UINib.init(nibName: "GGPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "GGPlaceTableViewCell")
        tbListPlace.dataSource = self
        tbListPlace.delegate = self
        //txtPlaceName.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.txtPlaceName.text = self.place?.addr ?? ""
    }
    
    @IBAction func onGotoChoiseMap(_ sender: Any) {
        let chooiceVC:GGChoiseFromMapViewController = UIStoryboard.init(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "GGChoiseFromMapViewController") as! GGChoiseFromMapViewController
        chooiceVC.title = self.title
        chooiceVC.type = self.type
        chooiceVC.delegate = self.delegate
        chooiceVC.isEditStock = self.isEditStock
        if self.place != nil{
            chooiceVC.place = self.place!
        }
        self.navigationController?.pushViewController(chooiceVC, animated: true)
    }
    @objc func chooiceFromMap(){
        let chooiceVC:GGChoiseFromMapViewController = UIStoryboard.init(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "GGChoiseFromMapViewController") as! GGChoiseFromMapViewController
        chooiceVC.title = self.title
        chooiceVC.type = self.type
        chooiceVC.delegate = self.delegate
        chooiceVC.isEditStock = self.isEditStock
        if self.place != nil{
            chooiceVC.place = self.place!
        }
        self.navigationController?.pushViewController(chooiceVC, animated: true)
    }
    
    @objc func getData() {
        let key:String = txtPlaceName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        dataPlace.removeAll()
        self.tbListPlace.reloadData()
        if key != ""{
            Services.shareInstance.searchPlaceByKeyGGM(input: key) { (response, message, errorCode) in
                if errorCode == SUCCESS_CODE {
                    self.dataPlace = response as! [GGPlaceObj]
                } else {
                    ToastCenter.default.cancelAll()
                    Toast(text: message, delay: 0, duration: 1).show()
                }
                self.tbListPlace.reloadData()
            }
        }
    }
    
    func getInfoPlace(placeID:String) {
        Services.shareInstance.getInfoPlaceByIdGGM(placeId: placeID) { (response, message, errorCode) in
            if errorCode == SUCCESS_CODE {
                let data = response as! GGPlaceObj
                self.dataPlace[self.index].lat = data.lat
                self.dataPlace[self.index].long = data.long
                self.dataPlace[self.index].adressComponent = data.adressComponent
                if self.delegate != nil{
                    self.delegate?.chooiceStartPoint?(data: self.dataPlace[self.index])
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                ToastCenter.default.cancelAll()
                Toast(text: message, delay: 0, duration: 1).show()
            }
        }
    }

}
extension GGChooisePlaceViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPlace.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GGPlaceTableViewCell", for: indexPath) as! GGPlaceTableViewCell
        cell.lbNamePlace.text = dataPlace[indexPath.row].addr ?? ""
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.getInfoPlace(placeID: self.dataPlace[self.index].placeId!)
    }
    
}
