//
//  UIColor+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/16/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension UIColor
{
   private convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
   {
      self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
   }
   
   static func mainTabBarColor() -> UIColor
   {
      return UIColor(r: 39, g: 44, b: 67)
   }
   
   static func mainNavBarColor() -> UIColor
   {
      return UIColor(r: 39, g: 44, b: 67)
   }
   
   static func lightBlueTextColor() -> UIColor
   {
      return UIColor(r: 109, g: 202, b: 203)
   }
   
   static func lightPurpleTextColor() -> UIColor
   {
      return UIColor(r: 124, g: 124, b: 163)
   }
   
   static func todayTomorrowTableBackgroundColor() -> UIColor
   {
      return UIColor(r: 59, g: 63, b: 90)
   }
   
   static func mainBackgroundColor() -> UIColor
   {
      return UIColor(r: 46, g: 49, b: 79)
   }
}
