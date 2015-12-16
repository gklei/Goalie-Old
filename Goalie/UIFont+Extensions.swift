//
//  UIFont+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/16/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

private let BoldFontName = "AvenirNext-Bold"
private let MediumFontName = "AvenirNext-Medium"

extension UIFont
{
   static func boldGoalieFontWithSize(size: CGFloat) -> UIFont
   {
      return UIFont(name: BoldFontName, size: size)!
   }
   
   static func mediumGoalieFontWithSize(size: CGFloat) -> UIFont
   {
      return UIFont(name: MediumFontName, size: size)!
   }
}
