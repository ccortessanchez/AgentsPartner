/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import RealmSwift


class AddNewEntryController: UIViewController {
  
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
  
    var selectedAnnotation: SpecimenAnnotation!
    var selectedCategory: Category!
    var specimen: Specimen!
  
    //MARK: - Validation
  
    func validateFields() -> Bool {
    
        if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty || selectedCategory == nil {
            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
      
            return false
      
        } else {
            return true
        }
  }
  
    //MARK: - View Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    //MARK: - Actions
  
    @IBAction func unwindFromCategories(_ segue: UIStoryboardSegue) {
        if segue.identifier == "CategorySelectedSegue" {
            let categoriesController = segue.source as! CategoriesTableViewController
            selectedCategory = categoriesController.selectedCategory
            categoryTextField.text = selectedCategory.name
        }
    }
    
    //MARK: - Helper functions
    
    func addNewSpecimen() {
        let realm = try! Realm()
        try! realm.write {
            let newSpecimen = Specimen()
            newSpecimen.name = self.nameTextField.text!
            newSpecimen.category = self.selectedCategory
            newSpecimen.specimeDescription = self.descriptionTextField.text
            newSpecimen.latitude = self.selectedAnnotation.coordinate.latitude
            newSpecimen.longitude = self.selectedAnnotation.coordinate.longitude
            
            realm.add(newSpecimen)
            self.specimen = newSpecimen
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if validateFields() {
            addNewSpecimen()
            return true
        } else {
            return false
        }
    }
}

//MARK: - UITextFieldDelegate
extension AddNewEntryController: UITextFieldDelegate {
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "Categories", sender: self)
    }
}

