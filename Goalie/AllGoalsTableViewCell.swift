//
//  AllGoalsTableViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class AllGoalsTableViewCell: UITableViewCell
{
   @IBOutlet private weak var _titleLabel: UILabel! {
      didSet {
         _titleLabel.font = ThemeAllGoalsLabelFont
      }
   }
   
   @IBOutlet private weak var _monthLabel: UILabel! {
      didSet {
         _monthLabel.font = ThemeSubgoalsLabelFont
         _monthLabel.textColor = UIColor.grayColor()
      }
   }
   
   @IBOutlet private weak var _subgoalCountLabel: UILabel! {
      didSet {
         _subgoalCountLabel.font = ThemeSubgoalsLabelFont
         _subgoalCountLabel.textColor = UIColor.darkGrayColor()
      }
   }
   
   @IBOutlet private weak var _todayButton: UIButton! {
      didSet {
//         _todayButton.layer.borderWidth = 1
//         _todayButton.layer.borderColor = UIColor.lightGrayColor().CGColor
      }
   }
   
   @IBOutlet private weak var _tomorrowButton: UIButton! {
      didSet {
//         _tomorrowButton.layer.borderWidth = 1
//         _tomorrowButton.layer.borderColor = UIColor.lightGrayColor().CGColor
      }
   }

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
      _subgoalCountLabel.text = "Subgoals: \(object.subgoals.count)"
   }
}
