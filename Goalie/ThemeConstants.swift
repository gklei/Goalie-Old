//
//  ThemeConstants.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

let ThemeNavigationBarFontSize: CGFloat = 20.0
let ThemeTabBarItemFontSize: CGFloat = 16
let ThemeNavigationBarButtonItemFontSize: CGFloat = 18
let ThemeMonthGridFontSize: CGFloat = 32
let ThemeMonthBadgeFontSize: CGFloat = 20
let ThemeAllGoalsLabelFontSize: CGFloat = 14
let ThemeSubgoalsLabelFontSize: CGFloat = 12

let ThemeFontName = "AvenirNext-Bold"
let ThemeNavigationFontName = "AvenirNext-Medium"

let ThemeTabBarItemFont = UIFont(name: ThemeNavigationFontName, size: ThemeTabBarItemFontSize)!
let ThemeNavigationBarFont = UIFont(name: ThemeNavigationFontName, size: ThemeNavigationBarFontSize)!
let ThemeNavigationBarButtonItemFont = UIFont(name: ThemeNavigationFontName, size: ThemeNavigationBarButtonItemFontSize)!
let ThemeMonthGridLabelFont = UIFont(name: ThemeFontName, size: ThemeMonthGridFontSize)!
let ThemeMonthBadgeFont = UIFont(name: ThemeFontName, size: ThemeMonthBadgeFontSize)!
let ThemeAllGoalsLabelFont = UIFont(name: ThemeFontName, size: ThemeAllGoalsLabelFontSize)!
let ThemeSubgoalsLabelFont = UIFont(name: ThemeFontName, size: ThemeSubgoalsLabelFontSize)!

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
