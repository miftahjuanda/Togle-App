//
//  Utils.swift
//  Togle App
//
//  Created by Diffa Desyawan on 29/04/21.
//

import Foundation
import UIKit
import CoreData

func convertToMinutesAndSecond(totalSecond : Int) -> String {
    let hours = (totalSecond / 3600)
    let minutes = (totalSecond % 3600) / 60
    let seconds = (totalSecond % 3600) % 60
    
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

func alertButton(title : String, message : String, completion : (UIAlertController)->()){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    completion(alertController)
}

func createInstanceBadges(data : NSManagedObject) -> BadgesModel {
    let id = (data.value(forKey: "id") as? String) ?? ""
    let point = (data.value(forKey: "point") as? Int64) ?? 0
    let focusTime = (data.value(forKey: "total_focus_time") as? Int64) ?? 0
    let completeTask  = (data.value(forKey: "total_complete_task") as? Int64) ?? 0
    let badges = BadgesModel(id: id, point: point, totalFocusTime: focusTime, totalCompleteTask: completeTask)
    
    return badges
}
