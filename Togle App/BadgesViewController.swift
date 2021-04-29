//
//  BadgesViewController.swift
//  Togle App
//
//  Created by Miftah Juanda Batubara on 28/04/21.
//

import Foundation
import UIKit

class DatasName {
    var yourMarga: String?
    var yourName: [String]?
    
    init(yourMarga: String, yourname: [String]) {
        self.yourMarga = yourMarga
        self.yourName = yourname
    }
}

class BadgesViewController: UIViewController {
    
    @IBOutlet weak var badgesTable: UITableView!
    
    var datasName = [DatasName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        badgesTable.dataSource = self
        badgesTable.delegate = self
        datas()
    }
    
    func datas(){
        datasName.append(DatasName(yourMarga: "Workaholic", yourname: ["Abdi","Anju","ABC","DEF"]))
        datasName.append(DatasName(yourMarga: "Gold Miner", yourname: ["Abdi","Anju","ABC","DEF"]))
        datasName.append(DatasName(yourMarga: "Eagle Breeder", yourname: ["Abdi","Anju","ABC","DEF"]))
        
    }
    
}

extension BadgesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasName[section].yourName?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "badgesItems", for: indexPath)
        cell.textLabel?.text = datasName[indexPath.section].yourName?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasName[section].yourMarga
    }
    
}
