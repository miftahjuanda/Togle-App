//
//  MainScreenProtocol.swift
//  Togle App
//
//  Created by Diffa Desyawan on 28/04/21.
//

import Foundation
import CoreData

protocol MainScreenProtocol {
    func reloadData()
    func changeStatusTask(fogleModel : FogleModel)
    func updateBadgesData(badgesModel : BadgesModel)
    func openTimerScreen(badgesData : NSManagedObject, fogleData : NSManagedObject)
}
