//
//  MonthCollectionViewCell.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell
{
   @IBOutlet weak private var _titleLabel: UILabel! {
      didSet {
         _titleLabel.font = ThemeMonthGridLabelFont
      }
   }
   @IBOutlet weak private var _goalBadgeLabel: UILabel! {
      didSet {
         _goalBadgeLabel.textColor = ThemeSelectedStateTextColor
         _goalBadgeLabel.layer.cornerRadius = 3
         _goalBadgeLabel.layer.masksToBounds = true
         _goalBadgeLabel.font = ThemeMonthBadgeFont
      }
   }
   
   override func awakeFromNib()
   {
      backgroundColor = UIColor.whiteColor()
      layer.borderColor = ThemeTitleTextColor.CGColor
      layer.borderWidth = 4.0
      layer.cornerRadius = 6.0
      layer.masksToBounds = true
   }
   
   func updateTitle(title: String)
   {
      _titleLabel.text = title
   }
   
   func updateGoalCount(count: Int)
   {
      _goalBadgeLabel.hidden = count <= 0
      _goalBadgeLabel.text = "\(count)"
   }
}
