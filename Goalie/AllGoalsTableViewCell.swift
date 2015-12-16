//
//  AllGoalsTableViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class AllGoalsTableViewCell: GoalieTableViewCell
{
   @IBOutlet private weak var _titleLabel: UILabel!
   @IBOutlet private weak var _monthLabel: UILabel!
   @IBOutlet private weak var _subgoalCountLabel: UILabel!
}

extension AllGoalsTableViewCell: ConfigurableCell
{
   func configureForObject(object: Goal)
   {  
      let viewModel = AllGoalsTableCellVM(goal: object)
      _titleLabel.attributedText = viewModel.attributedTextForComponent(.MainTitle)
      _monthLabel.attributedText = viewModel.attributedTextForComponent(.SubTitle)
      _subgoalCountLabel.attributedText = viewModel.attributedTextForComponent(.AuxLabel)
   }
}
