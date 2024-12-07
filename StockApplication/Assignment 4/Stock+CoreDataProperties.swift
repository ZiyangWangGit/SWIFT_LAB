//
//  Stock+CoreDataProperties.swift
//  Assignment 4
//
//  Created by Stephanie on 2024-12-01.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var name: String?
    @NSManaged public var rank: String?
    @NSManaged public var symbol: String?
    @NSManaged public var listType: String?

}

extension Stock : Identifiable {

}
