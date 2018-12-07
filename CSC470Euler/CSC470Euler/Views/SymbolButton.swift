//
//  SymbolButton.swift
//  CSC470Euler
//
//  Created by Jozeee on 12/1/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit

/// Represents a button that has a symbol where the user can tap to change its value.
class SymbolButton: UIButton {
    
    /// Represents the character representation of the symbol button.
    var symbol: Character?
    /// Represents the answer associated with the symbol.
    var value: Int = 0
    /// Represents the value the user has assigned to the label.
    var userAssignedValue: Int = 0 {
        didSet {
            setTitle("\(userAssignedValue)", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.titleLabel?.font = UIFont.montserrat(withSize: FontSize.numberButton)
            }
        }
    }
    
    // Assigns the symbol and value when a new game has been started.
    func assign(symbol: Character, withValue value: Int) {
        self.symbol = symbol
        self.value = value
        updateUI()
    }
    
    /// Puts back the default symbol and font.
    func reset() {
        if let symbol = symbol {
            setTitle("\(symbol)", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.titleLabel?.font = UIFont.bubbleRunes(withSize: FontSize.numberButton)
            }
        }
    }
    
    /// Change the appearance of the text if the answer is wrong and reveal the right answer.
    func shouldShowAnswer() {
        if userAssignedValue == 0 || userAssignedValue != value {
            setTitleColor(UIColor.darkGray, for: .normal)
            userAssignedValue = value
        }
    }

    // Update the UI of the button to reflect the new assigned values.
    private func updateUI() {
        setTitle(String("\(symbol ?? " ")"), for: .normal)
    }
}
