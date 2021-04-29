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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setImage()
    }
    
    func setImage(){
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view3.layer.cornerRadius = 10

        wh_image1.image = UIImage(named: "workaholic1")
        wh_image2.image = UIImage(named: "workaholic2")
        wh_image3.image = UIImage(named: "workaholic3")

        gm_image1.image =  UIImage(named: "gold_miner_1")
        gm_image2.image =  UIImage(named: "gold_miner_2")
        gm_image3.image =  UIImage(named: "gold_miner_3")

        eb_image1.image = UIImage(named: "eagle_breeder_1")
        eb_image2.image = UIImage(named: "eagle_breeder_2")
        eb_image3.image = UIImage(named: "eagle_breeder_3")
    }
    
    
    @IBAction func backNavigation(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
