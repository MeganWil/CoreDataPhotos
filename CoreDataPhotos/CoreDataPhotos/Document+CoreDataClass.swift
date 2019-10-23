//
//  Document+CoreDataClass.swift
//  CoreDataPhotos
//
//  Created by Megan Wilson on 10/22/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {

    var addDate: Date? {
        get {
            return rawAddDate as Date?
        }
        set {
            rawAddDate = newValue as NSDate? 
        }
    }
    
    var addimage: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let addimage = newValue {
                rawImage = convertImage(image: addimage)
            }
        }
    }
    
    convenience init?(title: String, body: String?, image: UIImage?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext, !title.isEmpty
            else {
                return nil
            }
        
        self.init(entity: Document.entity(), insertInto: managedContext)
        self.title = title
        self.body = body
        self.addDate = Date(timeIntervalSinceNow: 0)
        
        if let image = image {
            self.rawImage = convertImage(image: image)
        }
    }
    
    func convertImage(image: UIImage) -> NSData? {
        return processImage(image: image).pngData() as NSData?
    }
    
    func processImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == .up) {
            return image
        }
    
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        
        let copy = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
        guard let unwrappedCopy = copy
            else {
                return image
        }
        return unwrappedCopy
    }
}
