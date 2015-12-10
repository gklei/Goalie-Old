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
   private var _currentActiveState: ActiveState = .Idle
   
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
      switch _currentActiveState {
      case .Today:
         _currentActiveState = .Idle
         break
      case .Tomorrow, .Idle:
         _currentActiveState = .Today
         break
      }
      _updateButtonsForState(_currentActiveState)
   }
   
   @IBAction private func tomorrowButtonPressed()
   {
      switch _currentActiveState {
      case .Tomorrow:
         _currentActiveState = .Idle
         break
      case .Today, .Idle:
         _currentActiveState = .Tomorrow
         break
      }
      _updateButtonsForState(_currentActiveState)
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
   func textFieldShouldBeginEditing(textField: UITextField) -> Bool
   {
      _labelTextField.attributedText = nil
      _labelTextField.text = _goal.title
      return true
   }
   
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
      _goal.activeState = _currentActiveState
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
      _currentActiveState = goal.activeState
      
      _labelTextField.text = goal.title
      
      let strikeThroughValue = goal.completed == true ? 2 : 0
      let titleAttributes = [NSFontAttributeName : ThemeSubgoalsLabelFont, NSStrikethroughStyleAttributeName : strikeThroughValue]
      
      _labelTextField.attributedText = NSAttributedString(string: goal.title, attributes: titleAttributes)
      _updateButtonsForState(_goal.activeState)
      
      _todayButton.hidden = goal.title == ""
      _tomorrowButton.hidden = goal.title == ""
   }
}
