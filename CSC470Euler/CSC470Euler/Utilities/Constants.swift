//
//  Constants.swift
//  CSC470Euler
//
//  Created by Jozeee on 11/14/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit

enum AppFont: String {
    case montserratBold = "Montserrat-Bold"
    case bubbleRunes = "Bubble_Runes"
    
    var font: String {
        return self.rawValue
    }
}

enum FontSize: Int {
    case menuButton = 14
    case clueSymbol = 36
    case clueValue = 28
    case numberButton = 32
    
    var size: CGFloat {
        return CGFloat(self.rawValue)
    }
}

enum SegueIdentifier: String {
    case toGameScreen
    
    var id: String {
        return self.rawValue + "Segue"
    }
}


enum Difficulty {
    case easy, medium, hard
}


enum DataModelKey: String {
    case isSoundOn
    
    var key: String {
        return self.rawValue + "Key"
    }
}


/// Represents text that is presented to the user from the low level design document.
enum CopyDeck {
    enum GameScene: String {
        case newGame = "New Game"
        case submit = "Submit"
        case clearSymbol = "Clear Symbol"
        case clearGrid = "Clear Grid"
        
        // Used for the alert controllers.
        case newGameBody = "Are you sure you want to start a new game? This will take you back to the home screen."
        case submitBody = "Are you sure you want to submit the current game and reveal the answers?"
        case clearBody = "Are you sure you want to clear the grid? This will not start a new game."
        case okOptionBody = "Tap a difficulty to get started. Tap a symbol and assign it a number. Make sure they add up to the totals for the rows, columns, and diagonal. Start with the clues first!"
        case gameInfo = "How to Play"
        case yesOption = "Yes"
        case noOption = "No"
        case okOption = "OK"
        
        var text: String {
            return self.rawValue
        }
    }
}
