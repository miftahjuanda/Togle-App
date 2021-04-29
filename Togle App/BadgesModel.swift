//
//  BadgesModel.swift
//  Togle App
//
//  Created by Diffa Desyawan on 29/04/21.
//

import Foundation


class BadgesModel{
    var id : String
    var point : Int64
    var totalFocusTime : Int64
    var totalCompleteTask : Int64
    
    init(id : String, point : Int64, totalFocusTime : Int64, totalCompleteTask : Int64) {
        self.id = id
        self.point = point
        self.totalFocusTime = totalFocusTime
        self.totalCompleteTask = totalCompleteTask
    }
}
