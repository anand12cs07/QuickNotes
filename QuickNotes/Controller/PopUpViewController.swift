//
//  PopUpViewController.swift
//  QuickNotes
//
//  Created by Ratnesh Kumar on 22/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.delegate = self

    }

    @IBAction func alarmToggle(_ sender: UIButton) {
        
        datePicker.isEnabled = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNote(_ sender: Any) {
    }
    
    
}
extension PopUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
