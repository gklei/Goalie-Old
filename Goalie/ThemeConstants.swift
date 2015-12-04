//
//  ThemeConstants.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

let ThemeNavigationBarFontSize: CGFloat = 22.0
let ThemeTabBarItemFontSize: CGFloat = 16
let ThemeMonthGridFontSize: CGFloat = 32
let ThemeMonthBadgeFontSize: CGFloat = 20

//let ThemeFontName = "MarkerFelt-Wide"
//let ThemeFontName = "ChalkboardSE-Bold"
//let ThemeFontName = "Optima-ExtraBlack"
//let ThemeFontName = "Noteworthy-Bold"
//let ThemeFontName = "Thonburi-Bold"
//let ThemeFontName = "Thonburi"
//let ThemeFontName = "AvenirNext-DemiBold"
//let ThemeFontName = "AvenirNextCondensed-Heavy"
//let ThemeFontName = "BradleyHandITCTT-Bold"
//let ThemeFontName = "Courier-Bold"
let ThemeFontName = "Menlo-Bold"
//let ThemeFontName = "Chalkduster"

let ThemeTabBarItemFont = UIFont(name: ThemeFontName, size: ThemeTabBarItemFontSize)!
let ThemeNavigationBarFont = UIFont(name: ThemeFontName, size: ThemeNavigationBarFontSize)!
let ThemeMonthGridLabelFont = UIFont(name: ThemeFontName, size: ThemeMonthGridFontSize)!
let ThemeMonthBadgeFont = UIFont(name: ThemeFontName, size: ThemeMonthBadgeFontSize)!

let ThemeNormalStateTextColor = UIColor.whiteColor()

//let ThemeSelectedStateTextColor = UIColor(red: 0, green: 1, blue: 0.9, alpha: 1)
//let ThemeSelectedStateTextColor = UIColor(red: 1, green: 0.5, blue: 0.1, alpha: 1)
//let ThemeSelectedStateTextColor = UIColor(red: 0, green: 0.9, blue: 1, alpha: 1)
//let ThemeSelectedStateTextColor = UIColor(red: 0.5, green: 1, blue: 0.2, alpha: 1)
//let ThemeSelectedStateTextColor = UIColor.magentaColor()
//let ThemeSelectedStateTextColor = UIColor.orangeColor()
let ThemeSelectedStateTextColor = UIColor.cyanColor()

let ThemeTitleTextColor = UIColor.blackColor()

enum ThemeUIComponent {
   case TabBar, NavBar
}

struct Theme
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
      }
      return font
   }
   
   static func titleTextAttributesForComponent(component: ThemeUIComponent, controlState: UIControlState) -> [String : AnyObject]
   {
      let font = fontForComponent(component)
      var color = UIColor.blackColor()
      switch controlState
      {
      case UIControlState.Normal:
         color = ThemeNormalStateTextColor
         break
      case UIControlState.Selected:
         color = ThemeSelectedStateTextColor
         break
      default:
         break
      }
      return [NSFontAttributeName : font, NSForegroundColorAttributeName : color]
   }
   
   static func titleTextAttributesForComponent(component: ThemeUIComponent) -> [String : AnyObject]
   {
      let font = fontForComponent(component)
      let color = ThemeTitleTextColor
      return [NSFontAttributeName : font, NSForegroundColorAttributeName : color]
   }
}
