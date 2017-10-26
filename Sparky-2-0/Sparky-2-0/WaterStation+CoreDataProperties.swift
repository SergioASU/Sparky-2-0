//
//  WaterStation+CoreDataProperties.swift
//  Sparky-2-0
//
//  Created by Sergio Corral on 10/26/17.
//  Copyright © 2017 Sergio Corral. All rights reserved.
//

import Foundation
import CoreData


extension WaterStation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterStation> {
        return NSFetchRequest<WaterStation>(entityName: "WaterStation")
    }

    @NSManaged public var desc: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var picture: NSData?
    @NSManaged public var rating: Int16

}
