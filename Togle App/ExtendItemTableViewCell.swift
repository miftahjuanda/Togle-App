//
//  ExtendItemTableViewCell.swift
//  Togle App
//
//  Created by Diffa Desyawan on 29/04/21.
//

import UIKit
import CoreData

class ExtendItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTask: UILabel!
    @IBOutlet weak var dateTask: UILabel!
    @IBOutlet weak var targetTimeLabel: UILabel!
    @IBOutlet weak var notesTaskLabel: UILabel!
    @IBOutlet weak var colorNote: UIView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    func updateUI(fogle : NSManagedObject) {
        
        titleTask.text = fogle.value(forKey: "title") as? String
        dateTask.text = fogle.value(forKey: "date") as? String
        
        let targetTime : Int64 = (fogle.value(forKey: "target_time") as? Int64) ?? 0
        let currentTime : Int64 = (fogle.value(forKey: "current_time") as? Int64) ?? 0
        
        let imageName : String = (fogle.value(forKey: "result") as? String) ?? ""
        notesTaskLabel.text = fogle.value(forKey: "note") as? String
        resultImageView.image = UIImage(named: imageName)
        
        targetTimeLabel.text = "\(convertToMinutesAndSecond(totalSecond: Int(currentTime))) / \(convertToMinutesAndSecond(totalSecond: Int(targetTime)))"
        
        let status : String = fogle.value(forKey: "status") as? String ?? ""
        
        setColorNote(status: status)
        
    }
    
    func setColorNote(status : String){
        
        if status == FogleStatus.todo.rawValue {
            self.colorNote.backgroundColor = UIColor.systemBlue
            startButton.isHidden = false
        } else if status == FogleStatus.uncompleted.rawValue {
            self.colorNote.backgroundColor = UIColor.systemPink
            startButton.isHidden = true
        } else if status == FogleStatus.completed.rawValue {
            self.colorNote.backgroundColor = UIColor.systemGreen
            startButton.isHidden = true
        }
    }
    
    @IBAction func actionStartButton(_ sender: Any) {
        print("start")
    }
    
}
