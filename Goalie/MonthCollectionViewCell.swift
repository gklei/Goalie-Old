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
         _titleLabel.textColor = UIColor.lightBlueTextColor()
      }
   }
   @IBOutlet weak private var _goalBadgeLabel: UILabel! {
      didSet {
         _goalBadgeLabel.textColor = UIColor.whiteColor()
         _goalBadgeLabel.layer.masksToBounds = true
         _goalBadgeLabel.font = ThemeMonthBadgeFont
         _goalBadgeLabel.backgroundColor = UIColor.lightPurpleTextColor()
         _goalBadgeLabel.layer.cornerRadius = 3
      }
   }
   
   var gradientLayer = CAGradientLayer()
   
   override var highlighted: Bool {
      didSet {
         let highlightedColor = highlighted ? UIColor.whiteColor() : UIColor.lightPurpleTextColor()
         layer.borderColor = highlightedColor.CGColor
         _goalBadgeLabel.backgroundColor = highlightedColor
         _goalBadgeLabel.textColor = highlighted ? UIColor.lightPurpleTextColor() : UIColor.whiteColor()
         _titleLabel.textColor = highlighted ? UIColor.whiteColor() : UIColor.lightBlueTextColor()
      }
   }
   
   override func awakeFromNib()
   {
      backgroundColor = UIColor(red: 59/255.0, green: 63/255.0, blue: 90/255.0, alpha: 1)
      layer.borderColor = UIColor.lightPurpleTextColor().CGColor
      layer.borderWidth = 4.0
      layer.cornerRadius = 3.0
      layer.masksToBounds = true
      
      let firstColor = UIColor(red: 73/255.0, green: 78/255.0, blue: 102/255.0, alpha: 1).CGColor
      let secondColor = UIColor(red: 60/255.0, green: 64/255.0, blue: 91/255.0, alpha: 1).CGColor
      gradientLayer.colors = [firstColor, secondColor]
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
      
      layer.insertSublayer(gradientLayer, atIndex: 0)
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      gradientLayer.frame = CGRect(x: 0, y: bounds.midY, width: bounds.width, height: bounds.height * 0.5)
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
