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
      tintColor = ThemeTitleTextColor
      titleTextAttributes = Theme.titleTextAttributesForComponent(.NavBar)
      
      let barButtonItemAttrs = Theme.titleTextAttributesForComponent(.NavBarButtonItem)
      leftBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)
      rightBarButtonItem?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)

      let backgroundColor = UIColor(red: 39/255.0, green: 44/255.0, blue: 67/255.0, alpha: 1)
      let backgroundImage = UIImage.imageWithColor(backgroundColor)
      setBackgroundImage(backgroundImage, forBarMetrics: UIBarMetrics.Default)
      
//      makeTransparent()
   }
   
   func updateTitleFontSize(size: CGFloat)
   {
      titleTextAttributes = Theme.titleTextAttributesForComponent(.NavBar)
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
