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

class SubgoalsTableViewCell: GoalieTableViewCell
{
   @IBOutlet weak private var _labelTextField: UITextField! {
      didSet {
         _labelTextField.delegate = self
         _labelTextField.font = UIFont.boldGoalieFontWithSize(12)
         _labelTextField.textColor = UIColor.whiteColor()
         
         _labelTextField.attributedPlaceholder = NSAttributedString(string: "Add a sub-goal", attributes: [NSForegroundColorAttributeName : UIColor.lightPurpleTextColor().colorWithAlphaComponent(0.8)])
      }
   }
   
   @IBOutlet private weak var _todayButton: UIButton!
   @IBOutlet private weak var _tomorrowButton: UIButton!
   @IBOutlet private weak var _completeButton: UIButton!
   
   weak var delegate: SubgoalsTableViewCellDelegate?
   weak private var _goal: Goal!
   private var _currentActiveState: ActiveState = .Idle
   private var _currentlyEditingTitle = false
   
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
      
      if _currentlyEditingTitle == false {
         _goal.activeState = _currentActiveState
      }
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
      
      if _currentlyEditingTitle == false {
         _goal.activeState = _currentActiveState
      }
   }
   
   @IBAction private func completeButtonPressed()
   {
      _goal.completed = !_goal.completed
   }
   
   private func _updateButtonsForState(state: ActiveState)
   {
      switch state {
      case .Today:
         _tomorrowButton.setTitleColor(UIColor.lightBlueTextColor(), forState: .Normal)
         _todayButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
         break
      case .Tomorrow:
         _todayButton.setTitleColor(UIColor.lightBlueTextColor(), forState: .Normal)
         _tomorrowButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
         break
      case .Idle:
         _todayButton.setTitleColor(UIColor.lightBlueTextColor(), forState: .Normal)
         _tomorrowButton.setTitleColor(UIColor.lightBlueTextColor(), forState: .Normal)
         break
      }
   }
}

extension SubgoalsTableViewCell: UITextFieldDelegate
{
   func textFieldShouldBeginEditing(textField: UITextField) -> Bool
   {
      _currentlyEditingTitle = true
      _labelTextField.attributedText = nil
      _labelTextField.text = _goal.title
      _completeButton.enabled = false
      return true
   }
   
   func textFieldDidBeginEditing(textField: UITextField)
   {
      delegate?.subgoalBeganEditing(self)
      _labelTextField.returnKeyType = delegate?.returnKeyTypeForCell(self) ?? .Next
   }
   
   func textFieldDidEndEditing(textField: UITextField)
   {
      _currentlyEditingTitle = false
      _completeButton.enabled = true
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
      
      let strikeThroughValue = goal.completed == true ? 1 : 0
      let titleAttributes = [
         NSFontAttributeName : UIFont.boldGoalieFontWithSize(12),
         NSStrikethroughStyleAttributeName : strikeThroughValue
      ]
      
      _labelTextField.attributedText = NSAttributedString(string: goal.title, attributes: titleAttributes)
      _updateButtonsForState(_goal.activeState)
      
      _todayButton.hidden = goal.title == ""
      _tomorrowButton.hidden = goal.title == ""
      _completeButton.enabled = goal.title != ""
      
      UIView.setAnimationsEnabled(false)
      let buttonTitle = goal.completed == true ? "●" : "◦"
      _completeButton.setTitle(buttonTitle, forState: .Normal)
      _completeButton.layoutIfNeeded()
      UIView.setAnimationsEnabled(true);
   }
}
