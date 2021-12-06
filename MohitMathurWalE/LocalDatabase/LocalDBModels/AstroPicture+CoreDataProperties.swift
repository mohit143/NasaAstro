//
//  AstroPicture+CoreDataProperties.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 02/12/21.
//
//

import Foundation
import CoreData


extension AstroPicture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AstroPicture> {
        return NSFetchRequest<AstroPicture>(entityName: "AstroPicture")
    }

    @NSManaged public var date: String?
    @NSManaged public var explaination: String?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var isFetchedOnce: Bool

}

extension AstroPicture : Identifiable {

}
