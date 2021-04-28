//
//  FogleModel.swift
//  Togle App
//
//  Created by Diffa Desyawan on 28/04/21.
//

import Foundation


class  FogleModel{
    var id : String
    var title : String
    var status : String
    var date : Date
    var time : String
    
    init(title : String, status : String, date : Date, time : String) {
        self.id = UUID().uuidString
        self.title = title
        self.status = status
        self.date = date
        self.time = time
    }
}
