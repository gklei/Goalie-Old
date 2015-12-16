//
//  MonthGoalsTableViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class MonthGoalsTableViewCell: GoalieTableViewCell
{
   @IBOutlet private weak var _titleLabel: UILabel!
   @IBOutlet private weak var _descriptionLabel: UILabel!
   @IBOutlet private weak var _subgoalCountLabel: UILabel!
}

extension MonthGoalsTableViewCell: ConfigurableCell
{
   func configureForObject(object: Goal)
   {
      let viewModel = MonthGoalsTableCellVM(goal: object)
      _titleLabel.attributedText = viewModel.attributedTextForComponent(.MainTitle)
      _descriptionLabel.attributedText = viewModel.attributedTextForComponent(.SubTitle)
      _subgoalCountLabel.attributedText = viewModel.attributedTextForComponent(.AuxLabel)
   }
}
