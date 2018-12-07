//
//  TitleScreenViewController.swift
//  CSC470Euler
//
//  Created by Jozeee on 11/14/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit

//imports related to sound
import AVFoundation

class TitleScreenViewController: ParentViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    
    //these variables are with the sound function -Landon
    var buttonSound: AVAudioPlayer?

    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Methods
    @IBAction func loadEasyGame(_ sender: Any) {
        Console.log(file: #file, lineNumber: #line, message: "Easy game button pressed.")
        buttonSoundDecision() //play button sound if sound is on
        DataModel.shared.difficulty = Difficulty.easy
        performSegue(withIdentifier: SegueIdentifier.toGameScreen.id, sender: nil)
    }
    
    @IBAction func loadMediumGame(_ sender: Any) {
        Console.log(file: #file, lineNumber: #line, message: "Medium game button pressed.")
        buttonSoundDecision() //play button sound if sound is on
        DataModel.shared.difficulty = Difficulty.medium
        performSegue(withIdentifier: SegueIdentifier.toGameScreen.id, sender: nil)
    }
    
    @IBAction func loadHardGame(_ sender: Any) {
        Console.log(file: #file, lineNumber: #line, message: "Hard game button pressed.")
        buttonSoundDecision() //play button sound if sound is on
        DataModel.shared.difficulty = Difficulty.hard
        performSegue(withIdentifier: SegueIdentifier.toGameScreen.id, sender: nil)
    }

    @IBAction func showInfo(_ sender: Any) {
        //show info popup
        Console.log(file: #file, lineNumber: #line, message: "Information button pressed.")
        buttonSoundDecision() //play button sound if sound is on
        
        // Display an alert for game information
        let alertController = UIAlertController(title: CopyDeck.GameScene.gameInfo.text, message: CopyDeck.GameScene.okOptionBody.text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: CopyDeck.GameScene.okOption.text, style: .default) { _ in
            // Remove the current game screen from the stack to present back the title screen.
            self.dismiss(animated: true, completion: {
                // Reset anything if needed after the user presses ok.
            })
        }
        
        // Add the ok button to the alert controller.
        alertController.addAction(okAction)
        
        // Present the alert controller to the user.
        self.present(alertController, animated: true)
        
    }
    
    @IBAction func triggerMusic(_ sender: Any) {
        DataModel.shared.isSoundOn = !DataModel.shared.isSoundOn
        Console.log(file: #file, lineNumber: #line, message: "Sound button pressed. Sound is now \(DataModel.shared.isSoundOn).")
        buttonSoundDecision() //play button sound if sound is on
    }
}
