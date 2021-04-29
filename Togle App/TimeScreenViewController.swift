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
    @IBOutlet weak var playAndStopButton: UIImageView!
    
    var fogleModel : FogleModel?
    private var hasPlayed : Bool = false
    
    var totalSecond : Int = 0
    var timer : Timer?
    var almostFinish : Int = 0
    var step2 : Int = 0
    var step3 : Int = 0
    var step4 : Int = 0
    
    var minutes : Int?
    var seconds : Int?
    
    var mainScreenProtocol : MainScreenProtocol?
    var point : Int = 0
    var badgesModel : BadgesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fogleModel?.targetTime = 20
        titleTaskLabel.text = fogleModel?.title ?? ""
        totalSecond = Int(fogleModel?.targetTime ?? 0)
        
        almostFinish = totalSecond - Int(Double(totalSecond) * 0.8)
        step2 = totalSecond - Int(Double(totalSecond) * 0.2)
        step3 = totalSecond - Int(Double(totalSecond) * 0.4)
        step4 = totalSecond - Int(Double(totalSecond) * 0.6)
        
        setTimerFocus()
        fogleModel?.result = FogleResult.egg.rawValue
        
        let tapImageButton = UITapGestureRecognizer(target: self, action: #selector(actionButtonPlayAndStop))
        
        playAndStopButton.addGestureRecognizer(tapImageButton)
        playAndStopButton.isUserInteractionEnabled = true
        
    }
    
    @objc func actionButtonPlayAndStop() {
        if hasPlayed {
            timer?.invalidate()
            alertButton(title: "Are you sure to stop focus?", message: "You will don’t get your points and poor the eagle :(", completion: {
                alertController in
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    if self.point > 0 {
                        self.unCompletedAlert()
                    } else {
                        self.onYesButton()
                    }
                    
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats : true)
                }
                
                alertController.addAction(yesAction)
                alertController.addAction(cancelAction)

                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats : true)
            playAndStopButton.image = UIImage(named: "stop")
            hasPlayed = true
        }

    }
    
    
    @IBAction func actionBackButton(_ sender: Any) {
        if hasPlayed {
            timer?.invalidate()
            alertButton(title: "Are you sure to stop focus?", message: "You will don’t get your points and poor the eagle :(", completion: {
                alertController in
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    if self.point > 0 {
                        self.unCompletedAlert()
                    } else {
                        self.onYesButton()
                    }
                    
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats : true)
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
    
    func unCompletedAlert(){
        let myPoint = "You will get 🏆 +\(point) points and poor the eagle :("

        alertButton(title: "TASK UNCOMPLETED", message: myPoint, completion: {
            alertController in
            
            let yesAction = UIAlertAction(title: "Collect", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.onYesButton()
            }
            
            alertController.addAction(yesAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    
    func onYesButton(){
        self.hasPlayed = false
        playAndStopButton.image = UIImage(named: "start")
        self.timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
        
        
        let targetTime = self.fogleModel?.targetTime ?? 0
        self.fogleModel?.currentTime = targetTime - Int64(self.totalSecond)
        
        let point = (self.badgesModel?.point ?? 0) + Int64(self.point)
        self.badgesModel?.point = point
        let focusTime = targetTime - Int64(self.totalSecond)
        self.badgesModel?.totalFocusTime = focusTime
        let completeTask = (self.badgesModel?.totalCompleteTask ?? 0) + 1
        self.badgesModel?.totalCompleteTask = completeTask

        
        self.fogleModel?.status = FogleStatus.uncompleted.rawValue
        self.mainScreenProtocol?.changeStatusTask(fogleModel: self.fogleModel!)
        self.mainScreenProtocol?.updateBadgesData(badgesModel: self.badgesModel!)
    }
    
    func congratulationAlert(){
        alertButton(title: "TASK COMPLETED", message: "Good job! You are very consistent person 🏆 +\(point+2) points", completion: {
            alertController in
                let yesAction = UIAlertAction(title: "Collect", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                self.timer?.invalidate()
                
                self.hasPlayed = false
                
                let targetTime = self.fogleModel?.targetTime ?? 0
                
                    let point = (self.badgesModel?.point ?? 0) + Int64(self.point + 2)
                    self.badgesModel?.point = point
                    let focusTime = (self.badgesModel?.totalFocusTime ?? 0) + Int64(targetTime)
                    self.badgesModel?.totalFocusTime = focusTime
                    let completeTask = (self.badgesModel?.totalCompleteTask ?? 0) + 1
                    self.badgesModel?.totalCompleteTask = completeTask
                    
                    
                self.fogleModel?.currentTime = targetTime
                self.dismiss(animated: true, completion: nil)
                self.fogleModel?.status = FogleStatus.completed.rawValue
                    self.mainScreenProtocol?.updateBadgesData(badgesModel: self.badgesModel!)
                self.mainScreenProtocol?.changeStatusTask(fogleModel: self.fogleModel!)
            }
                
            alertController.addAction(yesAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @objc func countDown(){
        if totalSecond == step2 {
            point = 1
            self.fogleModel?.result = FogleResult.eggHatch.rawValue
            resultImageView.image = UIImage(named: "\(FogleResult.eggHatch.rawValue)")
        } else if totalSecond == step3 {
            point = 2
            self.fogleModel?.result = FogleResult.eggHatch2.rawValue
            resultImageView.image = UIImage(named: "\(FogleResult.eggHatch2.rawValue)")
        } else if totalSecond == step4 {
            point = 3
            self.fogleModel?.result = FogleResult.eggHatch3.rawValue
            resultImageView.image = UIImage(named: "\(FogleResult.eggHatch3.rawValue)")
        } else if totalSecond == almostFinish {
            point = 4
            self.fogleModel?.result = FogleResult.eagle.rawValue
            resultImageView.image = UIImage(named: "\(FogleResult.eagle.rawValue)")
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
