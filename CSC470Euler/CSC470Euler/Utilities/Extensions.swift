//
//  Extensions.swift
//  CSC470Euler
//
//  Created by Jozeee on 11/26/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Returns the light red color used in the UI designs.
    static var appRed: UIColor {
        return UIColor(red: 233 / 255, green: 71 / 255, blue: 65 / 255, alpha: 1)
    }
    
    /// Returns the light green color used in the background image used in the UI designs.
    static var appLightGreen: UIColor {
        return UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1)
    }
    
    /// Returns the green color used in the background image used in the UI designs.
    static var appGreen: UIColor {
        return UIColor(red: 3 / 255, green: 217 / 255, blue: 181 / 255, alpha: 1)
    }
    
    /// Returns the dark green color used in the background of symbols and menu buttons used in the UI designs.
    static var appDarkGreen: UIColor {
        return UIColor(red: 0, green: 177 / 255, blue: 148 / 255, alpha: 1)
    }
}


extension UIFont {
    /// Returns the font used in the UI, Montserrat.
    static func montserrat(withSize size: FontSize) -> UIFont {
        return UIFont(name: AppFont.montserratBold.font, size: size.size) ?? UIFont.systemFont(ofSize: size.size)
    }
    
    static func bubbleRunes(withSize size: FontSize) -> UIFont {
    return UIFont(name: AppFont.bubbleRunes.font, size: size.size) ?? UIFont.systemFont(ofSize: size.size)
    }
}
