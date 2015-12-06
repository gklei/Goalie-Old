//
//  SubgoalsTableViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/5/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

protocol SubgoalsTableViewCellDelegate: class
{
   func subgoalBeganEditing(cell: SubgoalsTableViewCell)
   func subgoalCellFinishedEditing(cell: SubgoalsTableViewCell)
}

class SubgoalsTableViewCell: UITableViewCell
{
   @IBOutlet weak private var _labelTextField: UITextField! {
      didSet {
         _labelTextField.delegate = self
         _labelTextField.font = ThemeAllGoalsLabelFont
      }
   }
   
   weak var delegate: SubgoalsTableViewCellDelegate?
   
   func updateTitle(title: String)
   {
      _labelTextField.text = title
   }
   
   func stopEditing()
   {
      _labelTextField.resignFirstResponder()
   }
}

extension SubgoalsTableViewCell: UITextFieldDelegate
{
   func textFieldDidBeginEditing(textField: UITextField)
   {
      delegate?.subgoalBeganEditing(self)
   }
   
   func textFieldDidEndEditing(textField: UITextField)
   {
      delegate?.subgoalCellFinishedEditing(self)
   }
}
