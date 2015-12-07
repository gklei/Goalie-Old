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
         _labelTextField.font = ThemeSubgoalsLabelFont
      }
   }
   
   weak var delegate: SubgoalsTableViewCellDelegate?
   weak private var _goal: Goal?
   
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
      if let title = textField.text {
         _goal?.title = title
      }
      delegate?.subgoalCellFinishedEditing(self)
   }
   
   func textFieldShouldReturn(textField: UITextField) -> Bool
   {
      _labelTextField.resignFirstResponder()
      return true
   }
}

extension SubgoalsTableViewCell: ConfigurableCell
{
   func configureForObject(goal: Goal)
   {
      _goal = goal
      _labelTextField.text = goal.title
   }
}
