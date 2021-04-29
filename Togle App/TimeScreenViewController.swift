//
//  TimeScreenViewController.swift
//  Togle App
//
//  Created by Diffa Desyawan on 29/04/21.
//

import UIKit

class TimeScreenViewController: UIViewController {

    @IBOutlet weak var titleTaskLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var focusTimeLabel: UILabel!
    @IBOutlet weak var playAndStopButton: UIButton!
    
    var fogleModel : FogleModel?
    private var hasPlayed : Bool = false
    
    var totalSecond : Int = 0
    var timer : Timer?
    var almostFinish : Int = 0
    var minutes : Int?
    var seconds : Int?
    
    var mainScreenProtocol : MainScreenProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTaskLabel.text = fogleModel?.title ?? ""
        totalSecond = Int(fogleModel?.targetTime ?? 0)
        almostFinish = totalSecond - Int(Double(totalSecond) * 0.8)
        setTimerFocus()
        fogleModel?.result = FogleResult.egg.rawValue
    }
    
    @IBAction func actionButtonPlayAndStop(_ sender: Any) {
        if hasPlayed {
            alertButton(title: "Are you sure to stop focus?", message: "You will don’t get your points and poor the eagle :(", completion: {
                alertController in
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    self.onYesButton()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                alertController.addAction(yesAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats : true)
            playAndStopButton.setTitle("Stop", for: .normal)
            hasPlayed = true
        }

    }
    
    
    @IBAction func actionBackButton(_ sender: Any) {
        if hasPlayed {
            alertButton(title: "Are you sure to stop focus?", message: "You will don’t get your points and poor the eagle :(", completion: {
                alertController in
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    self.onYesButton()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                alertController.addAction(yesAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            timer?.invalidate()
            hasPlayed = false
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    
    func onYesButton(){
        self.hasPlayed = false
        self.playAndStopButton.setTitle("Start", for: .normal)
        self.timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
        
        let targetTime = self.fogleModel?.targetTime ?? 0
        self.fogleModel?.currentTime = targetTime - Int64(self.totalSecond)
        
        self.fogleModel?.status = FogleStatus.uncompleted.rawValue
        self.mainScreenProtocol?.changeStatusTask(fogleModel: self.fogleModel!)

    }
    
    func congratulationAlert(){
        alertButton(title: "Congratulation", message: "You have finished the task, and you will earn 10 points", completion: {
            alertController in
                let yesAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                self.timer?.invalidate()
                
                self.hasPlayed = false
                
                let targetTime = self.fogleModel?.targetTime ?? 0
                self.fogleModel?.currentTime = targetTime
                self.dismiss(animated: true, completion: nil)
                self.fogleModel?.status = FogleStatus.completed.rawValue
                self.mainScreenProtocol?.changeStatusTask(fogleModel: self.fogleModel!)

            }
                
            alertController.addAction(yesAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @objc func countDown(){
        if totalSecond == almostFinish {
            self.fogleModel?.result = FogleResult.eagle.rawValue
            resultImageView.image = UIImage(named: "eagle")
        }
        
        if totalSecond == 0 {
            congratulationAlert()
        } else {
            totalSecond = totalSecond - 1
            setTimerFocus()
        }
        
    }
    
    func setTimerFocus(){
        focusTimeLabel.text = convertToMinutesAndSecond(totalSecond: totalSecond)
    }
    
    
}
