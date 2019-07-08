//
//  PopUpViewController.swift
//  QuickNotes
//
//  Created by Ratnesh Kumar on 22/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemManipulationDelegate {
    func addNoteItem(title: String, date: Date?, notifyID: String?)
    func updateNoteItem(title: String, date: Date?, notifyID: String?)
}

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteAction: UIButton!
    @IBOutlet weak var alarmToggle: UIButton!
    
    var noteItem: Item?
    var manipulationDelegate: ItemManipulationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPopUp()
        
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
        datePicker.timeZone = NSTimeZone.local
        if noteItem == nil{
            let dateTimeForReminder : Date? = alarmToggle.isSelected ? nil : datePicker.date
            manipulationDelegate?.addNoteItem(title: noteTextField.text!, date: dateTimeForReminder, notifyID: UUID().uuidString)
            
        }else{
            manipulationDelegate?.updateNoteItem(title: noteTextField.text!, date: datePicker.date, notifyID: noteItem?.notificationID)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpPopUp(){
        popUpTitle.text = noteItem != nil ? "Update Note" : "Add Note"
        noteAction.setTitle(noteItem != nil ? "Update" : "Add", for: .normal)
        noteTextField.text = noteItem?.title ?? ""
        datePicker.setDate(noteItem?.date ?? Date(), animated:  true)
        datePicker.isEnabled = noteItem != nil
        alarmToggle.isSelected = noteItem == nil
    }
    
    public func setNotification(catagoryName: String, item: Item){
        if let notifyDate = item.date{
            let center = UNUserNotificationCenter.current()
            
            // Step 2: Create the notification content
            let content = UNMutableNotificationContent()
            content.title = catagoryName
            content.body = item.title
            
            // Step 3: Create the notification trigger
            let date = notifyDate
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            print("\(item.notificationID!)")
            // Step 4: Create the request
            
            let request = UNNotificationRequest(identifier: item.notificationID!, content: content, trigger: trigger)
            
            // Step 5: Register the request
            center.add(request) { (error) in
                // Check the error parameter and handle any errors
            }
        }
    }
    
    public func deleteNotification(notifyID: String){
        print("Delete: " + notifyID)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notifyID])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifyID])
    }
    
}
extension PopUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
}
