//
//  ViewController.swift
//  HitList
//
//  Created by snqu-ios on 16/4/28.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var names = [String]()
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\" The List \""
        
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
         let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // 2
         let fetchRequest = NSFetchRequest(entityName: "Person")
        
        // 3
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
            if fetchedResults.count > 0 {
                people = fetchedResults as! [NSManagedObject]
            }
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }
        
    }

    @IBAction func addName(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action:UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField
            if (textField.text! != "") {
//                self.names.append(name)
                self.saveName(textField.text!)
                self.tableView.reloadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let person = people[indexPath.row];
        cell.textLabel!.text = person.valueForKey("name") as! String?
        return cell
    }
    
    
    
    func saveName(name: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // 3
        person.setValue(name, forKey: "name")
        
        // 4
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }
        
        people.append(person)
    }
    
    
    
    
}

