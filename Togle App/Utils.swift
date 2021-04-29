//
//  Utils.swift
//  Togle App
//
//  Created by Diffa Desyawan on 29/04/21.
//

import Foundation
import UIKit

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
