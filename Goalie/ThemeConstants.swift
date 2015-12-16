//
//  ThemeConstants.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

let ThemeTabBarItemFont = UIFont.mediumGoalieFontWithSize(16)
let ThemeNavigationBarFont = UIFont.mediumGoalieFontWithSize(18)
let ThemeNavigationBarButtonItemFont = UIFont.mediumGoalieFontWithSize(18)
let ThemeSubgoalsLabelFont = UIFont.boldGoalieFontWithSize(12)

enum ThemeUIComponent {
   case TabBar, NavBar, NavBarButtonItem
}

struct ThemeConstants
{
   static func fontForComponent(component: ThemeUIComponent) -> UIFont
   {
      var font = UIFont.systemFontOfSize(16)
      switch component
      {
      case .TabBar:
         font = ThemeTabBarItemFont
         break
      case .NavBar:
         font = ThemeNavigationBarFont
         break
      case .NavBarButtonItem:
         font = ThemeNavigationBarButtonItemFont
         break
      }
      return font
   }
   
   static func titleTextAttributesForComponent(component: ThemeUIComponent, controlState: UIControlState) -> [String : AnyObject]
   {
      let font = fontForComponent(component)
      var color = UIColor.lightBlueTextColor()
      switch controlState
      {
      case UIControlState.Normal:
         color = UIColor.mainBackgroundColor()
         break
      case UIControlState.Selected:
         color = UIColor.lightBlueTextColor()
         break
      default:
         break
      }
      return [NSFontAttributeName : font, NSForegroundColorAttributeName : color]
   }
   
   static func titleTextAttributesForComponent(component: ThemeUIComponent) -> [String : AnyObject]
   {
      let font = fontForComponent(component)
      let color = UIColor.lightBlueTextColor()
      return [NSFontAttributeName : font, NSForegroundColorAttributeName : color]
   }
}
