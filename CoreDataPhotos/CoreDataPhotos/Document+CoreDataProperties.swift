//
//  Document+CoreDataProperties.swift
//  CoreDataPhotos
//
//  Created by Megan Wilson on 10/22/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//
//

import Foundation
import CoreData



extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var title: String?
    @NSManaged public var rawImage: NSData?
    @NSManaged public var rawAddDate: NSDate?
    @NSManaged public var body: String?

}
