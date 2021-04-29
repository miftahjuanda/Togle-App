//
//  ItemTableViewCell.swift
//  Togle App
//
//  Created by Miftah Juanda Batubara on 28/04/21.
//

import UIKit
import CoreData

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var image_logo: UIImageView!
    @IBOutlet weak var task_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var result_label: UILabel!
    @IBOutlet weak var ui_view: UIView!
    
    func updateUI(fogle : NSManagedObject) {
//        image_logo.image = UIImage(named: dataItems.image)
        task_label.text = fogle.value(forKey: "title") as? String
        date_label.text = fogle.value(forKey: "date") as? String
        time_label.text = fogle.value(forKey: "time") as? String
        if fogle.value(forKey: "status") as? String != FogleStatus.todo.rawValue {
            result_label.text = fogle.value(forKey: "status") as? String
            result_label.isHidden = false
        } else{
            result_label.isHidden = true
        }
        
        ui_view.layer.cornerRadius = 10
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
