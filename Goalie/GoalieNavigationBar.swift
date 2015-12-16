//
//  GoalieNavigationBar.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class GoalieNavigationBar: UINavigationBar
{
   override func awakeFromNib()
   {
      hideBottomHairline()
      tintColor = UIColor.lightBlueTextColor()
      titleTextAttributes = ThemeConstants.titleTextAttributesForComponent(.NavBar)
      
      let barButtonItemAttrs = ThemeConstants.titleTextAttributesForComponent(.NavBarButtonItem)
      leftBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)
      rightBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)

      let backgroundColor = UIColor.mainNavBarColor()
      let backgroundImage = UIImage.imageWithColor(backgroundColor)
      setBackgroundImage(backgroundImage, forBarMetrics: UIBarMetrics.Default)
   }
   
   func updateTitleFontSize(size: CGFloat)
   {
      titleTextAttributes = ThemeConstants.titleTextAttributesForComponent(.NavBar)
      if let font = titleTextAttributes?[NSFontAttributeName] as? UIFont
      {
         let newFont = UIFont(name: font.fontName, size: size)!
         titleTextAttributes?[NSFontAttributeName] = newFont
      }
   }
   
   func updateTitleFont(font: UIFont)
   {
      titleTextAttributes?[NSFontAttributeName] = font
   }
   
   func updateTitleColor(color: UIColor)
   {
      titleTextAttributes?[NSForegroundColorAttributeName] = color
   }
   
   func updateTitle(title: String)
   {
      items?.first?.title = title
   }
   
   func updateBackgroundColor(color: UIColor)
   {
      setBackgroundImage(UIImage.imageWithColor(color), forBarMetrics: .Default)
   }
   
   func updateLeftBarButtonItemTitle(title: String)
   {
      leftBarButtonItem?.title = title
   }
   
   func updateRightBarButtonItemTitle(title: String)
   {
      rightBarButtonItem?.title = title
   }
}
