//
//  ViewController.swift
//  Togle App
//
//  Created by Miftah Juanda Batubara on 26/04/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var itemTableViews: UITableView!
    @IBOutlet weak var fogleSegmentationControl: UISegmentedControl!
    
    @IBOutlet weak var pointLabel: UIButton!
    var fogleData : [NSManagedObject] = []
    let statusSegmnetation : [FogleStatus] = [.todo,.uncompleted,.completed]
    private var db : FogleDB?
    var badgesData : NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = FogleDB()
        
        itemTableViews.dataSource = self
        itemTableViews.delegate = self
        itemTableViews.backgroundColor = UIColor.systemGray5
        setTable()
        setExtendTable()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            success, error in
            
                if success {
                    
                } else if let error = error {
                    print("Error : \(error)")
                }
            }
        )
        self.reloadData()
    }
        
    func setTable(){
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        itemTableViews.register(nib, forCellReuseIdentifier: "itemDataTable")
        itemTableViews.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func setExtendTable(){
        let nib = UINib(nibName: "ExtendItemTableViewCell", bundle: nil)
        itemTableViews.register(nib, forCellReuseIdentifier: "extendItemDataTable")
        itemTableViews.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            fogleData = db?.fetchDataByStatus(status: .todo) ?? []
            
            itemTableViews.reloadData()
        }
        else if sender.selectedSegmentIndex == 1 {
            fogleData = db?.fetchDataByStatus(status: .uncompleted) ?? []
            itemTableViews.reloadData()
        }
        else if sender.selectedSegmentIndex == 2 {
            fogleData = db?.fetchDataByStatus(status: .completed) ?? []
            
            itemTableViews.reloadData()
        }
       
    }
    
    @IBAction func actionAddButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
        
        vc.mainScreenProtocol = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBadgesButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "BadgesViewController") as! BadgesViewController
        
        vc.badges = createInstanceBadges(data: badgesData!)
        //        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fogleData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 12, dy: 8/2)
        maskLayer.backgroundColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData = fogleData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "extendItemDataTable", for: indexPath) as! ExtendItemTableViewCell
        cell.backgroundColor = UIColor.white
        cell.updateUI(fogle: itemData)
        
        return cell

//        if true {
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "itemDataTable", for: indexPath) as! ItemTableViewCell
//            cell.backgroundColor = UIColor.white
//            cell.updateUI(fogle: itemData)
//
//            return cell
//        }
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = fogleData[indexPath.row]
        
        let id : String = (data.value(forKey: "id") as? String) ?? ""
        let title : String = (data.value(forKey: "title") as? String) ?? ""
        let status : String = (data.value(forKey: "status") as? String) ?? ""
        let date : String = (data.value(forKey: "date") as? String) ?? ""
        let targetTime : Int64 = (data.value(forKey: "target_time") as? Int64) ?? 0
        let currentTime : Int64 = (data.value(forKey: "current_time") as? Int64) ?? 0
        let note : String = (data.value(forKey: "note") as? String) ?? ""
        let result : String = (data.value(forKey: "result") as? String) ?? ""
        
        let fogleModel = FogleModel(id: id, title: title, status: status, date: date, currentTime : currentTime, targetTime: targetTime, note: note, result: result)
        
        
        let badgesModel = createInstanceBadges(data: badgesData!)
        let vc = storyboard?.instantiateViewController(identifier: "TimeScreenViewController") as! TimeScreenViewController
        vc.mainScreenProtocol = self
        vc.fogleModel = fogleModel
        vc.badgesModel = badgesModel
        
        present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension ViewController : MainScreenProtocol {
    
    func reloadData() {
        
        fogleData = db?.fetchDataByStatus(status: statusSegmnetation[fogleSegmentationControl.selectedSegmentIndex]) ?? []
        badgesData = db?.fetchBadgesData()
        
        let point = (badgesData?.value(forKey: "point") as? Int64) ?? 0
        pointLabel.setTitle("🏆 \(point)", for: .normal)
        itemTableViews.reloadData()
    }
    
    func changeStatusTask(fogleModel: FogleModel) {
        db?.editFogleData(fogleModel: fogleModel)
        reloadData()
    }
    
    func updateBadgesData(badgesModel: BadgesModel) {
        db?.editBadgesData(badgesModel: badgesModel)
    }
    
    
}
