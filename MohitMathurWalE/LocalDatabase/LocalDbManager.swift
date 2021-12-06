//
//  LocalDbManager.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 02/12/21.
//

import Foundation
import CoreData
import UIKit

// MARK: - Core Data stack

class LocalDbManager{
    static let sharedManager = LocalDbManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MohitMathurWalE")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func savePicture(pictureModel : PictureModel) {
        
        let managedContext = LocalDbManager.sharedManager.persistentContainer.viewContext
        
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.
         */
        
        var picture = fetchPicture(date: pictureModel.date!)
        
        //Check if current date's object already exist then, update it
        
        if picture == nil{
            /*
             Initializes a managed object and inserts it into the specified managed object context.
             */
            picture = (NSEntityDescription.insertNewObject(forEntityName: "AstroPicture", into: managedContext) as! AstroPicture)
            /*
             With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
             */
        }
        
        picture!.title = pictureModel.title
        picture!.explaination = pictureModel.explanation
        picture!.date = pictureModel.date
        picture!.isFetchedOnce = true
        picture!.image = pictureModel.url
        
        /*
         You commit your changes to picture and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchPicture(date:String) -> AstroPicture?{
        
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = LocalDbManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all AstroPicture entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AstroPicture")
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        fetchRequest.returnsObjectsAsFaults = false
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let picture = try managedContext.fetch(fetchRequest)
            return picture.count > 0 ? (picture.first as! AstroPicture) : nil
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func fetchLastViewedPicture() -> AstroPicture?{
        
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = LocalDbManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all AstroPicture entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AstroPicture")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let allElementsCount = try managedContext.count(for: fetchRequest)
            fetchRequest.fetchLimit = 1
            fetchRequest.fetchOffset = allElementsCount - 1
            
            /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
            do {
                let picture = try managedContext.fetch(fetchRequest)
                return picture.count > 0 ? (picture.first as! AstroPicture) : nil
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return nil
            }
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                    in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key)
    }
    
    func saveToDocumentDirectory(image: UIImage, forKey key: String){
        if let jpegRepresentation = image.jpegData(compressionQuality: 1.0) {
            let pathWithouthttps = key.components(separatedBy: "//").last!
            if let filePath = filePath(forKey:pathWithouthttps.components(separatedBy: "/").last!) {
                do  {
                    try jpegRepresentation.write(to: filePath,
                                                 options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    func fetchFromDocumentDirectory(forKey key: String) -> UIImage? {
        let pathWithouthttps = key.components(separatedBy: "//").last!
        if let filePath = self.filePath(forKey: pathWithouthttps.components(separatedBy: "/").last!),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
}
