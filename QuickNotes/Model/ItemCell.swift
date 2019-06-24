//
//  ItemCell.swift
//  QuickNotes
//
//  Created by Ratnesh Kumar on 14/06/19.
//  Copyright © 2019 Anand Gupta. All rights reserved.
//

import Foundation
import UIKit
import SwipeCellKit

protocol CheckBoxDelegate {
    func toggleCheckBox(note: Item, status: Bool)
}

class ItemCell : SwipeTableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    var noteItem: Item!
    var checkBoxDelegate : CheckBoxDelegate?
    
    @IBAction func checkBox(_ sender: UIButton) {
        checkBoxDelegate?.toggleCheckBox(note: noteItem, status: !sender.isSelected)
    }
    
    func setNote() {
        checkBox.isSelected = noteItem.done
        if noteItem.done {
            setLabels(titleText: noteItem.title, reminderText: "Reminder: 23 May, 9:00 AM")
        }else{
            // clear strikethrough
            setLabels(titleText: "", reminderText: "")
            // set labels
            titleLabel.text = noteItem.title
            reminderLabel.text = "Reminder: 23 May, 9:00 AM"
        }
    }
    
    private func setLabels(titleText: String, reminderText: String){
        titleLabel.attributedText = addStrike(title: titleText)
        reminderLabel.attributedText = addStrike(title: reminderText)
    }
    
    private func addStrike(title : String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
}
