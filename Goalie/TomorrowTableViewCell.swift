//
//  TomorrowTableViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/9/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class TomorrowTableViewCell: GoalieTableViewCell
{
   @IBOutlet weak private var _mainTitleLabel: UILabel!
   @IBOutlet weak private var _subTitleLabel: UILabel!
   
   private weak var _goal: Goal!
   
   @IBAction private func _arrowButtonPressed()
   {
      _goal.managedObjectContext?.performChanges({ () -> () in
         self._goal.activeState = .Today
      })
   }
}

extension TomorrowTableViewCell: ConfigurableCell
{
   func configureForObject(object: Goal)
   {
      _goal = object
      
      let viewModel = TodayTomorrowTableCellVM(goal: _goal)
      _mainTitleLabel.attributedText = viewModel.attributedTextForComponent(.MainTitle)
      _subTitleLabel.attributedText = viewModel.attributedTextForComponent(.SubTitle)
   }
}
