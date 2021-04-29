//
//  ItemTableViewCell.swift
//  Togle App
//
//  Created by Miftah Juanda Batubara on 28/04/21.
//

import UIKit
import CoreData

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var colorNote: UIView!
    @IBOutlet weak var task_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    
    func updateUI(fogle : NSManagedObject) {

        task_label.text = fogle.value(forKey: "title") as? String
        date_label.text = fogle.value(forKey: "date") as? String
        
        let targetTime : Int64 = (fogle.value(forKey: "target_time") as? Int64) ?? 0
        let currentTime : Int64 = (fogle.value(forKey: "current_time") as? Int64) ?? 0
        
        time_label.text = "\(convertToMinutesAndSecond(totalSecond: Int(currentTime))) / \(convertToMinutesAndSecond(totalSecond: Int(targetTime)))"
        
        let status : String = fogle.value(forKey: "status") as? String ?? ""
        
        let result : String = fogle.value(forKey: "result") as? String ?? ""
        resultImageView.isHidden = true
        if status != FogleStatus.todo.rawValue {
            resultImageView.isHidden = false
            resultImageView.image = UIImage(named: result)
        }
        setColorNote(status: status)
        
    }
    
    func setColorNote(status : String){
        
        if status == FogleStatus.todo.rawValue {
            self.colorNote.backgroundColor = UIColor.systemBlue
            self.colorNote.tintColor = UIColor.systemBlue
        } else if status == FogleStatus.uncompleted.rawValue {
            self.colorNote.backgroundColor = UIColor.systemPink
            self.colorNote.tintColor = UIColor.systemPink
        } else if status == FogleStatus.completed.rawValue {
            self.colorNote.backgroundColor = UIColor.systemGreen
            self.colorNote.tintColor = UIColor.systemGreen
        }
    }
    
    func getResult(result : String) -> String {
        if result == FogleResult.egg.rawValue {
            return "🥚"
        } else if result == FogleResult.eagle.rawValue {
            return "🦅"
        }
        
        return ""
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
