//
//  MainPageViewController.swift
//  TicTacToe
//
//  Created by Jason Chow on 30/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet var playerStackView: UIStackView!
    @IBOutlet var npcModeStackView: UIStackView!
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMessageLabel(message: "Please select number of Player")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerStackView.isHidden = false
        npcModeStackView.isHidden = true
        updateMessageLabel(message: "Please select number of Player")
    }
    
    @IBAction func onePlayerButtonDidTapped(_ sender: UIButton) {
        playerStackView.isHidden = true
        npcModeStackView.isHidden = false
        updateMessageLabel(message: "Please select NPC level")
    }
    
    func updateMessageLabel(message: String) {
        messageLabel.text = message
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EasyIdentifier" {
            nextPage(for: segue, gameMode: .vsNpcEasy)
        } else if segue.identifier == "HardIdentifier" {
            nextPage(for: segue, gameMode: .vsNpcHard)
        } else if segue.identifier == "TwoPlayerIdentifier" {
            nextPage(for: segue, gameMode: .twoPlayer)
        }
    }
    
    func nextPage(for segue: UIStoryboardSegue, gameMode: GameMode) {
        if let gameVC = segue.destination as? ViewController {
            gameVC.gameMode = gameMode
        }
    }
    
}
