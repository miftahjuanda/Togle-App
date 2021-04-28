//
//  ItemTableViewCell.swift
//  Togle App
//
//  Created by Miftah Juanda Batubara on 28/04/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var image_logo: UIImageView!
    @IBOutlet weak var task_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var result_label: UILabel!
    @IBOutlet weak var ui_view: UIView!
    
    var dataItems: FogleModel!
    
    func updateUI() {
//        image_logo.image = UIImage(named: dataItems.image)
        task_label.text = dataItems.title
//        date_label.text = dataItems.date
        time_label.text = dataItems.time
//        result_label.text = dataItems.
        
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
