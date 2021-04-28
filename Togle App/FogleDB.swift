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
        fogle.setValue(fogleModel.time, forKey: "time")
        fogle.setValue(fogleModel.note, forKey: "note")
        
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
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Focus")
        
        fetchRequest.predicate = NSPredicate(format: "id==%@", fogleModel.id)
        do {
            
            let data = try managedContext.fetch(fetchRequest)
            
            if !data.isEmpty {
                let objectUpdate : NSManagedObject = data.first!
                objectUpdate.setValue(fogleModel.date, forKey: "date")
                objectUpdate.setValue(fogleModel.title, forKey: "title")
                objectUpdate.setValue(fogleModel.status, forKey: "status")
                objectUpdate.setValue(fogleModel.note, forKey: "note")
                objectUpdate.setValue(fogleModel.time, forKey: "time")
                
                do {
                    try managedContext.save()
                }catch let error as NSError {
                    print(error)
                }
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

