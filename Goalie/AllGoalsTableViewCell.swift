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
   @IBOutlet private weak var _titleLabel: UILabel! {
      didSet {
         _titleLabel.font = ThemeAllGoalsLabelFont
         _titleLabel.textColor = ThemeTabBarColor
      }
   }
   
   @IBOutlet private weak var _monthLabel: UILabel! {
      didSet {
         _monthLabel.font = ThemeSubgoalsLabelFont
         _monthLabel.textColor = ThemeTabBarColor.colorWithAlphaComponent(0.4)
      }
   }
   
   @IBOutlet private weak var _subgoalCountLabel: UILabel! {
      didSet {
         _subgoalCountLabel.font = ThemeSubgoalsLabelFont
         _subgoalCountLabel.textColor = ThemeTabBarColor.colorWithAlphaComponent(0.6)
      }
   }
   
   @IBOutlet private weak var _todayButton: UIButton!
   @IBOutlet private weak var _tomorrowButton: UIButton!

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

extension AllGoalsTableViewCell: ConfigurableCell
{
   func configureForObject(object: Goal)
   {
      _titleLabel.text = object.title
      _monthLabel.text = object.month.fullName
      _subgoalCountLabel.text = "\(object.completedSubgoals.count)/\(object.subgoals.count) sub-goals completed"
   }
}
