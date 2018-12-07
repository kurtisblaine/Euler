//
//  GameScreenViewController.swift
//  CSC470Euler
//
//  Created by Jozeee on 11/14/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit
import GameplayKit
    
import AVFoundation

class GameScreenViewController: ParentViewController {
    
    //this var is with the sound function -Landon
    var buttonSound: AVAudioPlayer?
    var difficulty: Difficulty = DataModel.shared.difficulty
    // The symbol the user has selected
    var selectedSymbol: SymbolButton?
    var didSubmitGame: Bool = false
    var isValidGrid: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var newGameButton: MenuButton!
    @IBOutlet weak var submitButton: MenuButton!
    @IBOutlet weak var clearSymbolButton: MenuButton!
    @IBOutlet weak var clearGridButton: MenuButton!
    @IBOutlet weak var numberButtonsLeftStack: UIStackView!
    @IBOutlet weak var numberButtonsRightStack: UIStackView!
    @IBOutlet weak var clueOneSymbol: UILabel!
    @IBOutlet weak var clueTwoSymbol: UILabel!
    @IBOutlet weak var clueThreeSymbol: UILabel!
    @IBOutlet weak var clueOneValue: UILabel!
    @IBOutlet weak var clueThreeValue: UILabel!
    @IBOutlet weak var clueTwoValue: UILabel!
    // Outlets for the grid
    @IBOutlet weak var gridParentView: UIView!
    @IBOutlet weak var totalRow1: UILabel!
    @IBOutlet weak var totalRow2: UILabel!
    @IBOutlet weak var totalRow3: UILabel!
    @IBOutlet weak var totalColumn1: UILabel!
    @IBOutlet weak var totalColumn2: UILabel!
    @IBOutlet weak var totalColumn3: UILabel!
    @IBOutlet weak var diagonalTotalLabel: UILabel!
    @IBOutlet weak var symbolButton1: SymbolButton!
    @IBOutlet weak var symbolButton2: SymbolButton!
    @IBOutlet weak var symbolButton3: SymbolButton!
    @IBOutlet weak var symbolButton4: SymbolButton!
    @IBOutlet weak var symbolButton5: SymbolButton!
    @IBOutlet weak var symbolButton6: SymbolButton!
    @IBOutlet weak var symbolButton7: SymbolButton!
    @IBOutlet weak var symbolButton8: SymbolButton!
    @IBOutlet weak var symbolButton9: SymbolButton!
    

    // MARK: - Properties
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare the UI.
        prepareMenuUI()
        prepareNumberButtonUI()
        prepareCluesUI()
        prepareGridUI()
        
        // Prepare an actual game.
        newGame()
        assignClues()
    }
    
    // MARK: - Methods
    @IBAction func symbolButtonPressed(_ sender: SymbolButton) {
        guard !didSubmitGame else { return }

        buttonSoundDecision() //play button sound if sound is on

        // If it is not nil, that means a button is currently selected.
        if selectedSymbol != nil {
            selectedSymbol?.setBackgroundImage(UIImage(named: "SymbolButtonBG"), for: .normal)
        }
        selectedSymbol = sender
        selectedSymbol?.setBackgroundImage(UIImage(named: "SymbolButtonSelectedBG"), for: .normal)
    }
    
    @IBAction func numberButtonPressed(_ sender: NumberButton) {
        guard !didSubmitGame else { return }

        // Each number button has a unique tag starting at 101 up to 110. 101 represents the top left button
        // going downward, and the bottom right button represents 110. All number buttons call this method when tapped.
        buttonSoundDecision() //play button sound if sound is on
        if let text = sender.titleLabel?.text, let number = Int(text) {
            selectedSymbol?.userAssignedValue = number
            // Unselect the symbol the user had selected.
            resetSelectedSymbol()
        }
    }
    
    
    @IBAction func newGameButtonPressed(_ sender: MenuButton) {
        buttonSoundDecision() //play button sound if sound is on
        if !didSubmitGame {
            // Hide the grid so the player can't cheat.
            shouldHideSymbolLabels()
            
            // Display an alert if they really want to start a new game.
            let alertController = UIAlertController(title: CopyDeck.GameScene.newGame.text, message: CopyDeck.GameScene.newGameBody.text, preferredStyle: .alert)
            
            // These represent the yes and no actions that the alert will have.
            let yesAction = UIAlertAction(title: CopyDeck.GameScene.yesOption.text, style: .default) { _ in
                // Remove the current game screen from the stack to present back the title screen.
                self.dismiss(animated: true, completion: {
                    // Reset anything if needed after the user presses yes.
                })
            }
            let noAction = UIAlertAction(title: CopyDeck.GameScene.noOption.text, style: .cancel) { _ in
                // Unhide back the grid because they chose no.
                self.shouldHideSymbolLabels(false)
            }
            
            // Add the yes and no buttons to the alert controller.
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            
            // Present the alert controller to the user.
            self.present(alertController, animated: true)
            
        } else {
            // This means they already submitted the game; there is no reason to present an alert anymore.
            self.dismiss(animated: true) {
                // Reset anything if needed after the user submitted the game and wants a new one.
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: MenuButton) {
        guard !didSubmitGame else { return }

        buttonSoundDecision() //play button sound if sound is on
        
        // Hide the grid to prevent cheating.
        shouldHideSymbolLabels()
        
        let alertController = UIAlertController(title: CopyDeck.GameScene.submit.text, message: CopyDeck.GameScene.submitBody.text, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: CopyDeck.GameScene.yesOption.text, style: .default) { _ in
            // If they tap yes on the alert.
            self.checkAnswers()
            self.shouldHideSymbolLabels(false)
        }
        let noAction = UIAlertAction(title: CopyDeck.GameScene.noOption.text, style: .cancel) { _ in
            // Unihde the grid.
            self.shouldHideSymbolLabels(false)
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func clearSymbolButtonPressed(_ sender: MenuButton) {
        guard !didSubmitGame else { return }

        buttonSoundDecision() //play button sound if sound is on
        if selectedSymbol != nil {
            // Unselect the symbol the user had selected.
            selectedSymbol?.setBackgroundImage(UIImage(named: "SymbolButtonBG"), for: .normal)
            selectedSymbol?.reset()
            selectedSymbol = nil
        }
    }
    
    @IBAction func clearGridButtonPressed(_ sender: MenuButton) {
        guard !didSubmitGame else { return }

        buttonSoundDecision() //play button sound if sound is on
        
        // Hide the grid to prevent cheating.
        shouldHideSymbolLabels()
        
        let alertController = UIAlertController(title: CopyDeck.GameScene.clearGrid.text, message: CopyDeck.GameScene.clearBody.text, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: CopyDeck.GameScene.yesOption.text, style: .default) { _ in
            self.clearGrid()
            self.shouldHideSymbolLabels(false)
        }
        let noAction = UIAlertAction(title: CopyDeck.GameScene.noOption.text, style: .cancel) { _ in
            // Unihde the grid.
            self.shouldHideSymbolLabels(false)
        }
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true)
    }
    
    // MARK: - Private Methods
    private func prepareMenuUI() {
        newGameButton.setTitle(CopyDeck.GameScene.newGame.text, for: UIControl.State.normal)
        submitButton.setTitle(CopyDeck.GameScene.submit.text, for: UIControl.State.normal)
        clearSymbolButton.setTitle(CopyDeck.GameScene.clearSymbol.text, for: UIControl.State.normal)
        clearGridButton.setTitle(CopyDeck.GameScene.clearGrid.text, for: UIControl.State.normal)
        
        [newGameButton, submitButton, clearSymbolButton, clearGridButton].forEach {
            $0?.setTitleColor(UIColor.white, for: UIControl.State.normal)
            $0?.titleLabel?.font = UIFont.montserrat(withSize: FontSize.menuButton)
        }
    }
    
    //function that decides if sound should be played based on user setting
    func buttonSoundDecision() {
        if !DataModel.shared.isSoundOn {
            //Console.log(file: #file, lineNumber: #line, message: "Sound is off, button press silent.")
        } else {
            //this is code working with sounds -Landon
            //if it shouldn't be here let me know or move it and tell me...
            do {
                if let fileURL = Bundle.main.path(forResource: "Button", ofType: "wav") {
                    buttonSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                } else {
                    Console.log(file: #file, lineNumber: #line, message: "No file found")
                }
            } catch let error {
                Console.log(file: #file, lineNumber: #line, message: "Can't play the audio file \(error.localizedDescription)")
            }
            //end Landon's sound code
            //Console.log(file: #file, lineNumber: #line, message: "Sound is on, button sound played.")
            buttonSound?.play() //play button sound
        }
    }
    
    private func prepareNumberButtonUI() {
        var numberButtons: [NumberButton?] = []
        for button in numberButtonsLeftStack.subviews where button.tag >= 101 && button.tag <= 105 {
            if let numberButton = button as? NumberButton {
                numberButtons.append(numberButton)
            }
        }
        for button in numberButtonsRightStack.subviews where button.tag >= 106 && button.tag <= 110 {
            if let numberButton = button as? NumberButton {
                numberButtons.append(numberButton)
            }
        }

        // There need to be 10 buttons in the array representing each number button. Using `Set` is to remove any
        // duplicates. If there are 10, then proceed; otherwise show an error. Then use default numbers 1 to 10 from storyboard.
        guard Set(numberButtons).count == 10 else {
            Console.log(file: #file, lineNumber: #line, message: "ERROR: Number buttons array did not include all buttons.")
            return
        }
        
        var tagCounter = 101
        var valueCounter = DataModel.shared.startingNumber
        for button in numberButtons where button?.tag == tagCounter {
            button?.setTitleColor(UIColor.white, for: UIControl.State.normal)
            button?.titleLabel?.font = UIFont.montserrat(withSize: FontSize.numberButton)
            button?.setTitle("\(valueCounter)", for: UIControl.State.normal)
            tagCounter += 1
            valueCounter += DataModel.shared.skipNumber
        }
    }
    
    private func prepareCluesUI() {
        [clueOneSymbol, clueOneValue, clueTwoSymbol, clueTwoValue, clueThreeSymbol, clueThreeValue].forEach {
            $0?.textColor = UIColor.white
        }
        // The clues use 2 different fonts: 1 for the symbol and 1 for the actual value.
        [clueOneValue, clueTwoValue, clueThreeValue].forEach {
            $0?.font = UIFont.montserrat(withSize: FontSize.clueValue)
        }
        [clueOneSymbol, clueTwoSymbol, clueThreeSymbol].forEach {
            $0?.font = UIFont.bubbleRunes(withSize: FontSize.clueSymbol)
        }
        
        switch difficulty {
        case .hard:
            clueOneValue.isHidden = true
            clueOneSymbol.isHidden = true
            fallthrough
        case .medium:
            clueThreeValue.isHidden = true
            clueThreeSymbol.isHidden = true
        default: break
        }
    }
    
    private func prepareGridUI() {
        gridParentView.backgroundColor = UIColor.clear
        let gridBG = UIImageView(image: UIImage(named: "GridBG"))
        gridParentView.addSubview(gridBG)
        gridParentView.sendSubviewToBack(gridBG)
        
        for label in [totalRow1, totalRow2, totalRow3, totalColumn1, totalColumn2, totalColumn3, diagonalTotalLabel] {
            label?.textColor = UIColor.white
            label?.font = UIFont.montserrat(withSize: FontSize.numberButton)
            label?.backgroundColor = UIColor(patternImage: UIImage(named: "SymbolButtonBG") ?? UIImage())
        }
        
        // An array of the buttons the user can tap and change.
        for button in [symbolButton1, symbolButton2, symbolButton3, symbolButton4, symbolButton5, symbolButton6, symbolButton7, symbolButton8, symbolButton9] {
            button?.setBackgroundImage(UIImage(named: "SymbolButtonBG"), for: .normal)
            button?.titleLabel?.font = UIFont.bubbleRunes(withSize: FontSize.numberButton)
            button?.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    // Prepares the logic for a new game.
    private func newGame() {
        DataModel.shared.newGame()
        didSubmitGame = false
        let symbolButtons: [SymbolButton?] = [symbolButton1, symbolButton2, symbolButton3, symbolButton4, symbolButton5,
                                              symbolButton6, symbolButton7, symbolButton8, symbolButton9]
        
        // Assigns a character and an actual value to the symbol button from the data model.
        for i in 0..<symbolButtons.count {
            Console.log(file: #file, lineNumber: #line, message: "Symbol \(i + 1) assigned \(DataModel.shared.symbols[i]), \(DataModel.shared.values[i])")
            symbolButtons[i]?.assign(symbol: DataModel.shared.symbols[i], withValue: DataModel.shared.values[i])
        }
        
        if difficulty == .hard {
            diagonalTotalLabel.isHidden = true
        }
        
        DataModel.shared.saveTotals(from: symbolButtons)
        assignTotals()
        assignClues()
    }
    
    // Assigns the totals that were calculated from the data model.
    private func assignTotals() {
        totalRow1?.text = "\(DataModel.shared.rowOneTotal)"
        totalRow2?.text = "\(DataModel.shared.rowTwoTotal)"
        totalRow3?.text = "\(DataModel.shared.rowThreeTotal)"
        totalColumn1?.text = "\(DataModel.shared.columnOneTotal)"
        totalColumn2?.text = "\(DataModel.shared.columnTwoTotal)"
        totalColumn3?.text = "\(DataModel.shared.columnThreeTotal)"
        diagonalTotalLabel?.text = "\(DataModel.shared.diagonalTotal)"
    }
    
    // Hide the grid to prevent the user from cheating.
    private func shouldHideSymbolLabels(_ hide: Bool = true) {
        // TODO: Will be implemented when timer is implemented; not necessary for now.
        return
//        UIView.animate(withDuration: 0.3) {
//            if hide {
//                self.gridParentView.alpha = 0
//            } else {
//                self.gridParentView.alpha = 1
//            }
//        }
    }
    
    // Randomly select indexes from data model and reveal them based on difficulty.
    private func assignClues() {
        let indexes = [Int](0...8)
        let randomIndexes = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: indexes) as? [Int] ?? indexes
        
        switch difficulty {
            // Show 3 clues.
        case .easy:
            clueThreeSymbol?.text = String("\(DataModel.shared.symbols[randomIndexes[2]])")
            clueThreeValue?.text = String("\(DataModel.shared.values[randomIndexes[2]])")
            fallthrough
        case .medium:
            // Show 2 clues.
            clueOneSymbol?.text = String("\(DataModel.shared.symbols[randomIndexes[0]])")
            clueOneValue?.text = String("\(DataModel.shared.values[randomIndexes[0]])")
            fallthrough
        case .hard:
            // Show 1 clue.
            clueTwoSymbol?.text = String("\(DataModel.shared.symbols[randomIndexes[1]])")
            clueTwoValue?.text = String("\(DataModel.shared.values[randomIndexes[1]])")
        }
    }
    
    // Assigns back the original values and font to all symbols.
    private func clearGrid() {
        let symbolButtons: [SymbolButton?] = [symbolButton1, symbolButton2, symbolButton3, symbolButton4, symbolButton5,
                                              symbolButton6, symbolButton7, symbolButton8, symbolButton9]
        
        for symbol in symbolButtons {
            // This means the user has set a value so that symbol button should be reset.
            if symbol?.userAssignedValue != nil {
                symbol?.reset()
            }
        }
        resetSelectedSymbol()
    }
    
    // Resets the symbol that is currently selected.
    private func resetSelectedSymbol() {
        selectedSymbol?.setBackgroundImage(UIImage(named: "SymbolButtonBG"), for: .normal)
        selectedSymbol = nil
    }
    
    // Check all the user assigned values add up to the actual answers. Assign any wrong answers (and unaswered) red text.
    private func checkAnswers() {
        didSubmitGame = true

        let symbolButtons: [SymbolButton?] = [symbolButton1, symbolButton2, symbolButton3, symbolButton4, symbolButton5,
                                              symbolButton6, symbolButton7, symbolButton8, symbolButton9]
        // Make sure that none of the buttons are nil and that they are the valid number of them in the new array.
        let validSymbols: [SymbolButton] = symbolButtons.compactMap { $0 }
        guard validSymbols.count == 9 else {
            submissionFailed()
            return
        }
        
        // Get the totals of what the user assigned the symbols.
        let rowOneTotal = validSymbols[0].userAssignedValue + validSymbols[1].userAssignedValue + validSymbols[2].userAssignedValue
        let rowTwoTotal = validSymbols[3].userAssignedValue + validSymbols[4].userAssignedValue + validSymbols[5].userAssignedValue
        let rowThreeTotal = validSymbols[6].userAssignedValue + validSymbols[7].userAssignedValue + validSymbols[8].userAssignedValue
        let columnOneTotal = validSymbols[0].userAssignedValue + validSymbols[3].userAssignedValue + validSymbols[6].userAssignedValue
        let columnTwoTotal = validSymbols[1].userAssignedValue + validSymbols[4].userAssignedValue + validSymbols[7].userAssignedValue
        let columnThreeTotal = validSymbols[2].userAssignedValue + validSymbols[5].userAssignedValue + validSymbols[8].userAssignedValue

        validSymbols.forEach { $0.shouldShowAnswer() }

        guard DataModel.shared.rowOneTotal == rowOneTotal && DataModel.shared.rowTwoTotal == rowTwoTotal &&
            DataModel.shared.rowThreeTotal == rowThreeTotal && DataModel.shared.columnOneTotal == columnOneTotal &&
            DataModel.shared.columnTwoTotal == columnTwoTotal && DataModel.shared.columnThreeTotal == columnThreeTotal else {
                isValidGrid = false
                completedGame()
                return
        }

        if difficulty != Difficulty.hard {
            let diagonalTotal = validSymbols[0].userAssignedValue + validSymbols[4].userAssignedValue + validSymbols[8].userAssignedValue
            guard diagonalTotal == DataModel.shared.diagonalTotal else {
                isValidGrid = false
                completedGame()
                return
            }
        }
        isValidGrid = true
        completedGame()
    }
    
    // Should never happen.
    private func submissionFailed() {
        let alert = UIAlertController(title: "Unknown Error", message: "An unexpected error occurred while validating answers. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func completedGame() {
        if isValidGrid {
            shouldPlayWinSound()
            createParticles(on: self.view)
        }
    }
    
    private func shouldPlayWinSound() {
        guard DataModel.shared.isSoundOn else {
            return
        }
        
        do {
            if let fileURL = Bundle.main.path(forResource: "Tada", ofType: "wav") {
                buttonSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                Console.log(file: #file, lineNumber: #line, message: "No file found")
            }
        } catch let error {
            Console.log(file: #file, lineNumber: #line, message: "Can't play the audio file \(error.localizedDescription)")
        }
        buttonSound?.play()
    }
}
