//
//  FogleDB.swift
//  Togle App
//
//  Created by Diffa Desyawan on 27/04/21.
//

import UIKit
import CoreData

class FogleDB {
    private var fogleData : [NSManagedObject]
    
    init() {
        fogleData = []
    }
    
    func fetchDataByStatus(status : FogleStatus) -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Focus")
        
        fetchRequest.predicate = NSPredicate(format: "status==%@", status.rawValue)
        do {
            fogleData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch : \(error)")
        }
        
        return fogleData
    }
    
    func fetchBadgesData() -> NSManagedObject {
        var badges : NSManagedObject = NSManagedObject()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return badges
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Badges")
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            
            if !data.isEmpty {
                badges = data.first!
            } else {
                DispatchQueue.main.async {
                    self.addBadgesData()
                }
            }
        } catch let error as NSError {
            print("Could not fetch : \(error)")
        }
        
        return badges
    }
    
    func addBadgesData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Badges", in: managedContext)!
        
        let fogle = NSManagedObject(entity: entity, insertInto: managedContext)
        
        fogle.setValue(UUID().uuidString, forKey: "id")
        fogle.setValue(0, forKey: "point")
        fogle.setValue(0, forKey: "total_focus_time")
        fogle.setValue(0, forKey: "total_complete_task")
        do {
            try managedContext.save()
            print("save badges")
        } catch let error as NSError {
            print("Could not save data \(error)")
        }

    }
    
    func editBadgesData(badgesModel : BadgesModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest.init(entityName: "Badges")
        
        fetchRequest.predicate = NSPredicate(format: "id==%@", badgesModel.id)
        do {
            
            let data = try managedContext.fetch(fetchRequest)
            
            
            let objectUpdate = data[0]
            
            objectUpdate.setValue(badgesModel.point, forKey: "point")
            objectUpdate.setValue(badgesModel.totalFocusTime, forKey: "total_focus_time")
            objectUpdate.setValue(badgesModel.totalCompleteTask, forKey: "total_complete_task")
            do {
                try managedContext.save()
            }catch let error as NSError {
                print(error)
            }
            
            
        } catch let error as NSError {
            print("Could not fetch : \(error)")
        }

    }
    
    func addFogleData(fogleModel : FogleModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Focus", in: managedContext)!
        
        let fogle = NSManagedObject(entity: entity, insertInto: managedContext)
        
        fogle.setValue(fogleModel.id, forKey: "id")
        fogle.setValue(fogleModel.date, forKey: "date")
        fogle.setValue(fogleModel.title, forKey: "title")
        fogle.setValue(fogleModel.status, forKey: "status")
        fogle.setValue(fogleModel.targetTime, forKey: "target_time")
        fogle.setValue(fogleModel.currentTime, forKey: "current_time")
        fogle.setValue(fogleModel.note, forKey: "note")
        fogle.setValue(fogleModel.result, forKey: "result")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save data \(error)")
        }
    }
    
    
    func editFogleData(fogleModel : FogleModel)  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest.init(entityName: "Focus")
        print(fogleModel.id)
        fetchRequest.predicate = NSPredicate(format: "id==%@", fogleModel.id)
        do {
            
            let data = try managedContext.fetch(fetchRequest)
            print("data masok \(data)")
            
            let objectUpdate = data[0]
                
                objectUpdate.setValue(fogleModel.date, forKey: "date")
                objectUpdate.setValue(fogleModel.title, forKey: "title")
                objectUpdate.setValue(fogleModel.status, forKey: "status")
                objectUpdate.setValue(fogleModel.note, forKey: "note")
                objectUpdate.setValue(fogleModel.targetTime, forKey: "target_time")
                objectUpdate.setValue(fogleModel.currentTime, forKey: "current_time")
                objectUpdate.setValue(fogleModel.result, forKey: "result")
                do {
                    try managedContext.save()
                }catch let error as NSError {
                    print(error)
                }
            
            
        } catch let error as NSError {
            print("Could not fetch : \(error)")
        }
    }
    
    
    func deleteFogleData(fogle : NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(fogle)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete \(error)")
        }
    }
}

