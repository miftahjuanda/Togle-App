//
//  BadgesViewController.swift
//  Togle App
//
//  Created by Miftah Juanda Batubara on 28/04/21.
//

import Foundation
import UIKit

class BadgesViewController: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var wh_image1: UIImageView!
    @IBOutlet weak var wh_image2: UIImageView!
    @IBOutlet weak var wh_image3: UIImageView!
    @IBOutlet weak var gm_image1: UIImageView!
    @IBOutlet weak var gm_image2: UIImageView!
    @IBOutlet weak var gm_image3: UIImageView!
    @IBOutlet weak var eb_image1: UIImageView!
    @IBOutlet weak var eb_image2: UIImageView!
    @IBOutlet weak var eb_image3: UIImageView!
    
    var badges : BadgesModel?
    var point : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }
    
    func setImage(){
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10
        
        let point = badges?.point ?? 0
        let focusTime = (badges?.totalFocusTime ?? 0) / 60
        let totalTask = (badges?.totalCompleteTask ?? 0)
        if point >= 20 {
            gm_image1.image = UIImage(named: "gold_miner_1")
        } else if point >= 150 {
            gm_image2.image = UIImage(named: "gold_miner_2")
        } else if point >= 500 {
            gm_image3.image = UIImage(named: "gold_miner_3")
        }
        
        if totalTask >= 5 {
            wh_image1.image = UIImage(named: "work_holic_1")
        } else if totalTask >= 25 {
            wh_image2.image = UIImage(named: "work_holic_2")
        } else if totalTask >= 50 {
            wh_image3.image = UIImage(named: "work_holic_3")
        }
        
        if focusTime >= 120 {
            eb_image1.image = UIImage(named: "eagle_breeder_1")
        } else if focusTime >= 300 {
            eb_image1.image = UIImage(named: "eagle_breeder_2")
        } else if focusTime >= 1200 {
            eb_image1.image = UIImage(named: "eagle_breeder_3")
        }
    }
    
    
    @IBAction func backNavigation(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
