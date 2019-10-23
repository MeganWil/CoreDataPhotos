//
//  DocumentsTableViewController.swift
//  CoreDataPhotos
//
//  Created by Megan Wilson on 10/22/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit

class DocumentsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var textDisplay: UITextView!
    
    let dateFormate = DateFormatter()
    let docDateFormat = DateFormatter()
    let imageController = UIImagePickerController()
    
    var doc: Document?
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDisplay.layer.borderWidth = 0.5
        textDisplay.layer.cornerRadius = 5.0
        
        imageDisplay.layer.borderWidth = 0.5
        
        dateFormate.dateStyle = .medium
        dateFormate.timeStyle = .medium
        
        docDateFormat.dateStyle = .medium
    
        if let doc = doc {
            
            titleField.text = doc.title
            textDisplay.text = doc.body
            
            if let addDate = doc.addDate {
                dateLabel.text = dateFormate.string(from: addDate)
            }
            
            image = doc.addimage
            imageDisplay.image = image
        }
        else {
            titleField.text = ""
            textDisplay.text = ""
            dateLabel.text = docDateFormat.string(from: Date(timeIntervalSinceNow: 0))
            imageDisplay.image = nil
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        selectSource()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty
            else {
                alert(message: "Please enter a title before saving the note.")
                return
            }
        
        if let docs = doc {
            docs.title = title
            docs.body = textDisplay.text
            docs.addimage = image
        }
        else {
            doc = Document(title: title, body: textDisplay.text, image: image)
        }
        if let doc = doc {
            do {
                let managedContext = doc.managedObjectContext
                try managedContext?.save()
            }
            catch {
                alert(message: "The note could not be saved.")
            }
        }
        else {
            alert(message: "The note could not be created.")
        }
    navigationController?.popViewController(animated: true)
    }
    
    
    func alert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imageController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else {
                return
            }
        image = selectedImage
        imageDisplay.image = image
        if let doc = doc {
            doc.addimage = selectedImage
        }
    }
    
    func selectSource() {
           let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
               (alertAction) in
               self.takePhoto()
           }))
           alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
               (alertAction) in
               self.selectPhoto()
           }))
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
       
    
    func selectPhoto() {
        imageController.sourceType = .photoLibrary
        imageController.delegate = self
        present(imageController, animated: true)
    }
    
    func takePhoto() {
           if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
               alert(message: "This device has no camera.")
               return
           }
           imageController.sourceType = .camera
           imageController.delegate = self
           present(imageController, animated: true)
       }
  
}
