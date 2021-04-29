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
    
    var fogleData : [NSManagedObject] = []
    let statusSegmnetation : [FogleStatus] = [.todo,.uncompleted,.completed]
    private var db : FogleDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = FogleDB()
        
        itemTableViews.dataSource = self
        itemTableViews.delegate = self
        setTable()
        fogleData = db?.fetchDataByStatus(status: .todo) ?? []
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            success, error in
            
                if success {
                    
                } else if let error = error {
                    print("Error : \(error)")
                }
            }
        )
        itemTableViews.reloadData()
    }
        
    func setTable(){
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        itemTableViews.register(nib, forCellReuseIdentifier: "itemDataTable")
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
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fogleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData = fogleData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemDataTable", for: indexPath) as! ItemTableViewCell
        
        cell.updateUI(fogle: itemData)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController : MainScreenProtocol {
    
    func reloadData() {
        fogleData = db?.fetchDataByStatus(status: statusSegmnetation[fogleSegmentationControl.selectedSegmentIndex]) ?? []
        itemTableViews.reloadData()
    }
    
    
}
