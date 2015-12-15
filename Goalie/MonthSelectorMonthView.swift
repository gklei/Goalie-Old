//
//  MonthSelectorMonthView.swift
//  Goalie
//
//  Created by Gregory Klein on 12/7/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension UILabel
{
   convenience init(month: Month)
   {
      self.init(frame: CGRect.zero)
      self.text = month.text
      self.font = ThemeAllGoalsLabelFont
      self.sizeToFit()
   }
}

class MonthSelectorMonthView: UIView
{
   var month: Month
   var selected: Bool {
      didSet {
         backgroundColor = selected == true ? selectedBackgroundColor : unselectedBackgroundColor
         _monthLabel.textColor = selected == true ? ThemeSelectedStateTextColor : ThemeTabBarColor
      }
   }
   
   var selectedBackgroundColor = ThemeTabBarColor
   var unselectedBackgroundColor = ThemeNormalStateTextColor
   
   private var _monthLabel: UILabel
   
   // MARK: - Init
   required init(coder aDecoder: NSCoder) {
      fatalError("This class does not support NSCoding")
   }
   
   init(month: Month)
   {
      self.month = month
      self.selected = false
      _monthLabel = UILabel(month: month)
      _monthLabel.textColor = ThemeTabBarColor
      
      super.init(frame:CGRect.zero)
      addSubview(_monthLabel)
   }
   
   // MARK: - Lifecycle
   override func layoutSubviews()
   {
      super.layoutSubviews()
      _monthLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
   }
}
