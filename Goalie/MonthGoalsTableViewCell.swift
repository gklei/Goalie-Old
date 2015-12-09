//
//  MonthGoalsTableViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class MonthGoalsTableViewCell: UITableViewCell
{
   @IBOutlet private weak var _titleLabel: UILabel! {
      didSet {
         _titleLabel.font = ThemeAllGoalsLabelFont
      }
   }
   
   @IBOutlet private weak var _descriptionLabel: UILabel! {
      didSet {
         _descriptionLabel.font = ThemeSubgoalsLabelFont
         _descriptionLabel.textColor = UIColor.darkGrayColor()
      }
   }
   
   @IBOutlet private weak var _subgoalCountLabel: UILabel! {
      didSet {
         _subgoalCountLabel.font = ThemeSubgoalsLabelFont
         _subgoalCountLabel.textColor = UIColor.grayColor()
      }
   }
   
   override func setSelected(selected: Bool, animated: Bool)
   {
      super.setSelected(selected, animated: animated)
   }
}

extension MonthGoalsTableViewCell: ConfigurableCell
{
   func configureForObject(object: Goal)
   {
      _titleLabel.text = object.title
      _descriptionLabel.text = object.summary == "" ? "No description" : object.summary
      _subgoalCountLabel.text = "\(object.subgoals.count) Sub-goals"
   }
}
