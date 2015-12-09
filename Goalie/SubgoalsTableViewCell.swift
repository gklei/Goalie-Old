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
   func subgoalButtonPressedWithState(state: ActiveState, cell: SubgoalsTableViewCell)
}

class SubgoalsTableViewCell: UITableViewCell
{
   @IBOutlet weak private var _labelTextField: UITextField! {
      didSet {
         _labelTextField.delegate = self
         _labelTextField.font = ThemeSubgoalsLabelFont
      }
   }
   
   @IBOutlet private weak var _todayButton: UIButton!
   @IBOutlet private weak var _tomorrowButton: UIButton!
   
   weak var delegate: SubgoalsTableViewCellDelegate?
   weak private var _goal: Goal!
   
   var subgoal: Goal {
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
   
   @IBAction private func todayButtonPressed()
   {
      switch _goal.activeState {
      case .Today:
         _goal.activeState = .Idle
         break
      case .Tomorrow, .Idle:
         _goal.activeState = .Today
         break
      }
   }
   
   @IBAction private func tomorrowButtonPressed()
   {
      switch _goal.activeState {
      case .Tomorrow:
         _goal.activeState = .Idle
         break
      case .Today, .Idle:
         _goal.activeState = .Tomorrow
         break
      }
   }
   
   private func _updateButtonsForState(state: ActiveState)
   {
      switch state {
      case .Today:
         _tomorrowButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
         _todayButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
         break
      case .Tomorrow:
         _todayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
         _tomorrowButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
         break
      case .Idle:
         _todayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
         _tomorrowButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
         break
      }
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
         _goal.title = title
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
      _labelTextField.text = goal.title
      
      _updateButtonsForState(_goal.activeState)
   }
}
