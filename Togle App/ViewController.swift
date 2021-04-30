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
    
    @IBOutlet weak var labelEmptyView: UILabel!
    @IBOutlet weak var imageEmptyView: UIImageView!
    var fogleData : [NSManagedObject] = []
    let statusSegmnetation : [FogleStatus] = [.todo,.uncompleted,.completed]
    private var db : FogleDB?
    var badgesData : NSManagedObject?
    
    var listData : [FogleModel] = []
    
    var labelEmpty : [String] = ["There are no tasks yet.\nHow about making your own tasks?", "There are no uncompleted tasks yet.\nHow about making your own tasks or start your task you have added?", "There are no completed tasks yet.\nHow about making your own tasks or start your task you have added?"]
    
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
        labelEmptyView.text = labelEmpty[fogleSegmentationControl.selectedSegmentIndex]
        reloadData()
    }
    
    @IBAction func actionAddButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
        
        vc.mainScreenProtocol = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBadgesButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "BadgesViewController") as! BadgesViewController
        
        vc.badges = createInstanceBadges(data: badgesData!)
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
        let data = listData[indexPath.row]
        
        if data.highlight {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extendItemDataTable", for: indexPath) as! ExtendItemTableViewCell
            cell.backgroundColor = UIColor.white
            cell.updateUI(fogle: itemData)
            cell.startCallback = {
                self.openTimerScreen(badgesData: self.badgesData!, fogleData: itemData)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemDataTable", for: indexPath) as! ItemTableViewCell
            cell.backgroundColor = UIColor.white
            cell.updateUI(fogle: itemData)

            return cell
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = listData[indexPath.row]
        
        if data.highlight && data.status != FogleStatus.todo.rawValue {
            return tableView.frame.height/6
        } else if data.highlight {
            return tableView.frame.height/5
        }
        
        return tableView.frame.height/8
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath)  in
            print("test hapus")
            alertButton(title: "Delete task", message: "Are you sure want to delete this task ?", completion: {
                alertController in

                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    UIAlertAction in

                    let data = self.fogleData[indexPath.row]

                    self.db?.deleteFogleData(fogle: data)
                    self.reloadData()

                }

                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                alertController.addAction(yesAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)

            })
        }
        
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath)  in
            print("test edit")
            let data = self.fogleData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(identifier: "AddTaskViewController") as! AddTaskViewController
            vc.mainScreenProtocol = self
            vc.editData = createFogleModel(data: data)
            vc.isEdit = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
        editButton.backgroundColor = UIColor.systemGreen
        deleteButton.backgroundColor = UIColor.systemRed
        return [deleteButton, editButton]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemData = listData[indexPath.row]
        itemData.highlight.toggle()
        tableView.reloadData()
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
    func openTimerScreen(badgesData: NSManagedObject, fogleData: NSManagedObject) {
        let vc = storyboard?.instantiateViewController(identifier: "TimeScreenViewController") as! TimeScreenViewController
        vc.mainScreenProtocol = self
        vc.fogleModel = createFogleModel(data: fogleData)
        vc.badgesModel = createInstanceBadges(data: badgesData)
        present(vc, animated: true, completion: nil)
    }
    
    func changeStatusTask(fogleModel: FogleModel) {
        db?.editFogleData(fogleModel: fogleModel)
        reloadData()
    }
    
    func reloadData() {
        listData = []
        fogleData = db?.fetchDataByStatus(status: statusSegmnetation[fogleSegmentationControl.selectedSegmentIndex]) ?? []
        
        for data in fogleData {
            listData.append(createFogleModel(data: data))
        }
        
        badgesData = db?.fetchBadgesData()
        
        if !fogleData.isEmpty {
            itemTableViews.isHidden = false
            labelEmptyView.isHidden = true
            labelEmptyView.text = labelEmpty[fogleSegmentationControl.selectedSegmentIndex]
            imageEmptyView.isHidden = true
        } else {
            itemTableViews.isHidden = true
            labelEmptyView.isHidden = false
            imageEmptyView.isHidden = false
        }
        
        if badgesData != nil {
         
            let point = (badgesData?.value(forKey: "point") as? Int64) ?? 0
            pointLabel.setTitle("🏆 \(point)", for: .normal)
            itemTableViews.reloadData()
        }
    }
    
    func editTask(fogleModel: FogleModel) {
        db?.editFogleData(fogleModel: fogleModel)
        reloadData()
    }

    func updateBadgesData(badgesModel: BadgesModel) {
        db?.editBadgesData(badgesModel: badgesModel)
    }
    
}
