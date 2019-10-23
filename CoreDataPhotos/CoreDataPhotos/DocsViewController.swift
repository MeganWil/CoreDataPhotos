//
//  DocsViewController.swift
//  CoreDataPhotos
//
//  Created by Megan Wilson on 10/22/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import UIKit
import CoreData

class DocsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var document = [Document]()
    var dateFormate = DateFormatter()
    @IBOutlet weak var docsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
            dateFormate.dateStyle = .medium
            dateFormate.timeStyle = .medium
        }
        
        override func viewWillAppear(_ animated: Bool) {
            fetchDoc()
            docsTableView.reloadData()
        }
    
    
    
    func fetchDoc() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                document = [Document]()
                return
            }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rawAddDate", ascending: true)]
        
        do {
            document = try managedContext.fetch(fetchRequest)
        } catch {
            alert(message: "Fetch for document failed.")
        }
    }
    
    func delete(indexPath: IndexPath) {
        let documents = document[indexPath.row]
        
        if let managedObjectContext = documents.managedObjectContext {
            managedObjectContext.delete(documents)
            
            do {
                try managedObjectContext.save()
                self.document.remove(at: indexPath.row)
                docsTableView.reloadData()
            }
            catch {
                alert(message: "Delete failed.")
                docsTableView.reloadData()
            }
        }
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return document.count
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
          
          let docs = document[indexPath.row]
          cell.textLabel?.text = docs.title
          if let addDate = docs.addDate {
              cell.detailTextLabel?.text = dateFormate.string(from: addDate)
          }
        return cell
      }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentsTableViewController
            else {
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "doc", let indexPathForSelectedRow = docsTableView.indexPathForSelectedRow {
            destination.doc = document[indexPathForSelectedRow.row]
        }
    }
    

}
