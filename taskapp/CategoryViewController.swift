//
//  CategoryViewController.swift
//  taskapp
//
//  Created by 伊藤敬 on 2022/12/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryName: UITextField!
    
    let realm = try! Realm()
    var cat = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerCategory(_ sender: Any) {
        let allCategory = realm.objects(Category.self)
        
        if categoryName.text != "" {
            try! realm.write {
                if allCategory.count != 0 {
                    self.cat.id = allCategory.max(ofProperty: "id")! + 1
                }
                self.cat.name = self.categoryName.text!
                self.realm.add(self.cat, update: .modified)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        let task = Task()
        
        let allTasks = realm.objects(Task.self)
        if allTasks.count != 0 {
            task.id = allTasks.max(ofProperty: "id")! + 1
        }
        
        inputViewController.task = task
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
