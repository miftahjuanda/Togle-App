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

    var dataItemTable : [FogleModel] = []
    var fogleData : [NSManagedObject] = []

    private var db : FogleDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = FogleDB()
        
        itemTableViews.dataSource = self
        itemTableViews.delegate = self
        setTable()
        
    }
    
    func setTable(){
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        itemTableViews.register(nib, forCellReuseIdentifier: "itemDataTable")
        itemTableViews.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            //view.backgroundColor = .gray
//            fogleData = db?.fetchDataByStatus(status: .todo) ?? []
            
            itemTableViews.reloadData()
        }
        else if sender.selectedSegmentIndex == 1 {
//            fogleData = db?.fetchDataByStatus(status: .uncompleted) ?? []
            //view.backgroundColor = .orange
            
            itemTableViews.reloadData()
        }
        else if sender.selectedSegmentIndex == 2 {
            //view.backgroundColor = .brown
//            fogleData = db?.fetchDataByStatus(status: .completed) ?? []
            
            itemTableViews.reloadData()
        }
       
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataItemTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData = dataItemTable[indexPath.row]
        let cell = itemTableViews.dequeueReusableCell(withIdentifier: "itemDataTable") as! ItemTableViewCell
        
        cell.dataItems = itemData
        cell.updateUI()
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemTableViews.deselectRow(at: indexPath, animated: true)
    }
}
