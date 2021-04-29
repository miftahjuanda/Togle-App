//
//  FogleModel.swift
//  Togle App
//
//  Created by Diffa Desyawan on 28/04/21.
//

import Foundation


class FogleModel {
    var id : String
    var title : String
    var status : String
    var date : String
    var currentTime : Int64
    var targetTime : Int64
    var note : String
    var result : String
    var highlight : Bool = false
    
    init(title : String, status : String, date : String, currentTime : Int64, targetTime : Int64, note : String, result : String) {
        self.id = UUID().uuidString
        self.title = title
        self.status = status
        self.date = date
        self.currentTime = currentTime
        self.targetTime = targetTime
        self.note = note
        self.result = result
    }
    
    init(id : String, title : String, status : String, date : String, currentTime : Int64, targetTime : Int64, note : String, result : String) {
        self.id = id
        self.title = title
        self.status = status
        self.date = date
        self.currentTime = currentTime
        self.targetTime = targetTime
        self.note = note
        self.result = result
    }

}
