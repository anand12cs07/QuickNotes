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


class ItemCell : SwipeTableViewCell{
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
