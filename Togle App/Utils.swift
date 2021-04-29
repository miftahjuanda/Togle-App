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

func createFogleModel(data : NSManagedObject) -> FogleModel {
    let id : String = (data.value(forKey: "id") as? String) ?? ""
    let title : String = (data.value(forKey: "title") as? String) ?? ""
    let status : String = (data.value(forKey: "status") as? String) ?? ""
    let date : String = (data.value(forKey: "date") as? String) ?? ""
    let targetTime : Int64 = (data.value(forKey: "target_time") as? Int64) ?? 0
    let currentTime : Int64 = (data.value(forKey: "current_time") as? Int64) ?? 0
    let note : String = (data.value(forKey: "note") as? String) ?? ""
    let result : String = (data.value(forKey: "result") as? String) ?? ""
    
    let fogleModel = FogleModel(id: id, title: title, status: status, date: date, currentTime : currentTime, targetTime: targetTime, note: note, result: result)
    
    return fogleModel
}


func alertButton(title : String, message : String, completion : (UIAlertController)->()){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    completion(alertController)
}

