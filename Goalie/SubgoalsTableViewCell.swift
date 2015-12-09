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
   func titleTextFieldShouldReturnForCell(cell: SubgoalsTableViewCell) -> Bool
   func returnKeyTypeForCell(cell: SubgoalsTableViewCell) -> UIReturnKeyType
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
   
   var subgoal: Goal? {
      return _goal
   }
   var titleText: String {
      return _labelTextField.text ?? ""
   }
   
   func stopEditing()
   {
      _labelTextField.resignFirstResponder()
   }
   
   func startEditing()
   {
      _labelTextField.becomeFirstResponder()
   }
}

extension SubgoalsTableViewCell: UITextFieldDelegate
{
   func textFieldDidBeginEditing(textField: UITextField)
   {
      delegate?.subgoalBeganEditing(self)
      _labelTextField.returnKeyType = delegate?.returnKeyTypeForCell(self) ?? .Next
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
      return delegate?.titleTextFieldShouldReturnForCell(self) ?? true
   }
}

extension SubgoalsTableViewCell: ConfigurableCell
{
   func configureForObject(goal: Goal)
   {
      _goal = goal
      if goal.title != "" && goal.title[0] != "•" {
         _labelTextField.text = "• \(goal.title)"
      }
      else {
         _labelTextField.text = goal.title
      }
   }
}
