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

    var dataItemTable : [DataItem] = []
    var fogleData : [NSManagedObject] = []

    private var db : FogleDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = FogleDB()
        // Do any additional setup after loading the view.
        itemTableViews.dataSource = self
        itemTableViews.delegate = self
        setTable()
        dummyData()
    }
    
    func setTable(){
        let nib = UINib(nibName: "ItemsTableViewCell", bundle: nil)
        itemTableViews.register(nib, forCellReuseIdentifier: "itemDataTable")
        itemTableViews.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func dummyData(){
        let a = DataItem(image: "eagle", task: "Contoh", date: "21/04/2021 08:00 AM", time: "01:20", result: "Result: 🥚")
        let b = DataItem(image: "eagle", task: "Contoh", date: "21/04/2021 08:00 AM", time: "01:20", result: "Result: 🥚")
        let c = DataItem(image: "eagle", task: "Contoh", date: "21/04/2021 08:00 AM", time: "01:20", result: "Result: 🥚")
        let d = DataItem(image: "eagle", task: "Contoh", date: "21/04/2021 08:00 AM", time: "01:20", result: "Result: 🥚")
        let e = DataItem(image: "eagle", task: "Contoh", date: "21/04/2021 08:00 AM", time: "01:20", result: "Result: 🥚")
        let f = DataItem(image: "eagle", task: "Contoh", date: "21/04/2021 08:00 AM", time: "01:20", result: "Result: 🥚")
        
        dataItemTable.append(a)
        dataItemTable.append(b)
        dataItemTable.append(c)
        dataItemTable.append(d)
        dataItemTable.append(e)
        dataItemTable.append(f)
    }


    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        
        itemTableViews.reloadData()
        
        if sender.selectedSegmentIndex == 0 {
            //view.backgroundColor = .gray
            fogleData = db?.fetchDataByStatus(status: .todo) ?? []
        }
        else if sender.selectedSegmentIndex == 1 {
            fogleData = db?.fetchDataByStatus(status: .uncompleted) ?? []
            //view.backgroundColor = .orange
        }
        else if sender.selectedSegmentIndex == 2 {
            //view.backgroundColor = .brown
            fogleData = db?.fetchDataByStatus(status: .completed) ?? []
        }
       
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataItemTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemData = dataItemTable[indexPath.row]
        let cell = itemTableViews.dequeueReusableCell(withIdentifier: "itemDataTable") as! ItemsTableViewCell
        
        cell.dataItems = itemData
        cell.updateUI()
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemTableViews.deselectRow(at: indexPath, animated: true)
    }
}
