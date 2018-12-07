//
//  DataModel.swift
//  CSC470Euler
//
//  Created by Jozeee on 11/26/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit
import GameplayKit

/// The data model is responsible for storing, manipulating, or calculating data. Business logic should not be done
/// in the view controllers; it is handled here. This class should also not be manipulating UI objects.
class DataModel {
    
    // MARK: - Properties
    static var shared: DataModel = DataModel()
    var difficulty: Difficulty = Difficulty.easy
    /// Represents a collection of the symbols presented in the grid.
    var symbols: [Character] = [Character]()
    /// Represents a collection of the actual values associated with each symbol.
    var values: [Int] = [Int]()
    var rowOneTotal: Int = 0
    var rowTwoTotal: Int = 0
    var rowThreeTotal: Int = 0
    var columnOneTotal: Int = 0
    var columnTwoTotal: Int = 0
    var columnThreeTotal: Int = 0
    var diagonalTotal: Int = 0
    
    /// The flag whether the sound should play or not. Default is on.
    var isSoundOn: Bool = true {
        didSet {
            // Save the setting so next time it does not reset when opening the app.
            UserDefaults.standard.set(isSoundOn, forKey: DataModelKey.isSoundOn.key)
        }
    }
    
    /// Represents at which number the options for the user starts at. If it starts at 1, that means the user
    /// has 1 to 10 for the buttons to press. Default is 1.
    var startingNumber: Int = 1
    
    /// Represents how many numbers to skip from the starting number to the next number. If it's 2, then
    /// the numbers will be 1, 3, 5, 7, etc. if the starting number was 1. Default is 1.
    var skipNumber: Int = 1
    
    // MARK: - Public Methods
    /// Load back into the shared object any saved settings.
    func loadSettings() {
        if let isSoundOnExists = UserDefaults.standard.value(forKey: DataModelKey.isSoundOn.key) as? Bool {
            Console.log(file: #file, lineNumber: #line, message: "Sound setting has been loaded from save: \(isSoundOnExists)")
            isSoundOn = isSoundOnExists
        } else {
            Console.log(file: #file, lineNumber: #line, message: "Sound setting not loaded because there is no saved setting for it.")
        }
    }
    
    /// Resets data to prepare for a new game.
    func newGame() {
        reset()
        randomizeSymbols()
        randomizeValues()
    }
    
    func saveTotals(from symbols: [SymbolButton?]) {
        let validSymbols: [SymbolButton] = symbols.compactMap { $0 }
        if validSymbols.count == 9 {
            rowOneTotal = validSymbols[0].value + validSymbols[1].value + validSymbols[2].value
            rowTwoTotal = validSymbols[3].value + validSymbols[4].value + validSymbols[5].value
            rowThreeTotal = validSymbols[6].value + validSymbols[7].value + validSymbols[8].value
            columnOneTotal = validSymbols[0].value + validSymbols[3].value + validSymbols[6].value
            columnTwoTotal = validSymbols[1].value + validSymbols[4].value + validSymbols[7].value
            columnThreeTotal = validSymbols[2].value + validSymbols[5].value + validSymbols[8].value
            if difficulty != .hard {
                diagonalTotal = validSymbols[0].value + validSymbols[4].value + validSymbols[8].value
            }
        }
    }
    
    
    // MARK: - Private Methods
    // Randomizes the order of the symbols to assign them to each symbol button in a new game.
    private func randomizeSymbols() {
        symbols.removeAll()
        let letterSymbols: String = "ABCDEFGHJLMNOPQRSTUVXYZ"
        symbols = Array(letterSymbols)
        if let shuffledSymbols = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: symbols) as? [Character] {
            symbols = shuffledSymbols
        }
    }
    
    // Randomizes the associated value for each symbol to assign them to each symbol button in a new game.
    private func randomizeValues() {
        values.removeAll()
        // Range must be 9 numbers since there are 9 symbols.
        let numbers: [Int] = Array(startingNumber...(startingNumber + 8))
        if let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numbers) as? [Int] {
            values = shuffledNumbers
        } else {
            // If the random shuffle fails, then just assign the values 1 to 9.
            Console.log(file: #file, lineNumber: #line, message: "Failed to randomize the values.")
            for i in 1...9 {
                values[i] = i
            }
        }
    }
    
    // Reset any data that may have been stored to prepare for a new game.
    private func reset() {
        difficulty = Difficulty.easy
        symbols.removeAll()
        values.removeAll()
        rowOneTotal = 0
        rowTwoTotal = 0
        rowThreeTotal = 0
        columnOneTotal = 0
        columnTwoTotal = 0
        columnThreeTotal = 0
        diagonalTotal = 0
    }
}
