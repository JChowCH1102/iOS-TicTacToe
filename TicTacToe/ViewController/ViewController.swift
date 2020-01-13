//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jason Chow on 18/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CheckWinPositionDelegate {
    
    @IBOutlet var baseUIView : UIView!
    weak var upperLine: UIView!
    weak var lowerLine: UIView!
    weak var leftLine: UIView!
    weak var rightLine: UIView!
    
    weak var row1Line: UIView?
    weak var row2Line: UIView?
    weak var row3Line: UIView?
    weak var column1Line: UIView?
    weak var column2Line: UIView?
    weak var column3Line: UIView?
    weak var lrLine: UIView?
    weak var rlLine: UIView?
    
    @IBOutlet var m11: UIButton!
    @IBOutlet var m12: UIButton!
    @IBOutlet var m13: UIButton!
    @IBOutlet var m21: UIButton!
    @IBOutlet var m22: UIButton!
    @IBOutlet var m23: UIButton!
    @IBOutlet var m31: UIButton!
    @IBOutlet var m32: UIButton!
    @IBOutlet var m33: UIButton!
    @IBOutlet var upperButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    @IBOutlet var upperLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    var baseUIViewSize = 0.0
    var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    var position = Position()
    var isYourTurn = Player()
    var gameMode: GameMode?
    
    var turnCount = 1
    
    //MARK: - MPC
    
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        bottomButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        position.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseUIViewSize = Double(baseUIView.frame.width)
        createBoard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upperLine?.frame = CGRect(x: 0, y: baseUIView.frame.height / 3, width: baseUIView.frame.width, height: 4)
        lowerLine?.frame = CGRect(x: 0, y: 2 * baseUIView.frame.height / 3, width: baseUIView.frame.width, height: 4)
        leftLine?.frame = CGRect(x: baseUIView.frame.width / 3, y:0, width: 4, height: baseUIView.frame.height)
        rightLine?.frame = CGRect(x: 2 * baseUIView.frame.height / 3, y: 0 , width: 4, height: baseUIView.frame.height)
        //        upperLine.frame = CGRect(x: 0, y: 0, width: baseUIView.frame.width, height: baseUIView.frame.height)
    }
    
    //MARK: - Game circle - 0. Perpare View
    func createBoard() {
        if self.traitCollection.userInterfaceStyle == .dark {
            color = UIColor.white
        }  else {
            color = UIColor.black
        }
        
        upperLine = addSubView(x: 0, y: baseUIViewSize/3, width: baseUIViewSize, height: 4, color: color)
        lowerLine = addSubView(x: 0, y: 2*baseUIViewSize/3, width: baseUIViewSize, height: 4, color: color)
        leftLine = addSubView(x: baseUIViewSize/3, y: 0, width: 4, height: baseUIViewSize, color: color)
        rightLine = addSubView(x: 2*baseUIViewSize/3, y: 0, width: 4, height: baseUIViewSize, color: color)
        
        newGame() // Go to Game Circle - 1
    }
    
    //MARK: - Game circle - 1. Start a new game
    func newGame() {
        isYourTurn = Player()
        newTurn()
    }
    
    //MARK: - Game circle - 2. new Turn
    func newTurn() {
        guard let game = gameMode else {
            return
        }
        if isYourTurn.myTurn {
            updateLabel(upper: "Is Your Turn")
        } else {
            updateLabel(bottom: "Is Your Turn")
            
            switch game {
            case .vsNpcEasy, .vsNpcHard:
                npcTurn()
            case .mpcPlay:
                //TODO: MPC
                break
            case .twoPlayer:
                break
            }
        }
    }
    //MARK: - Game circle - 3a. Player choose position
    @IBAction func buttonDidTapped(_ sender: UIButton) {
        if (!isYourTurn.myTurn && gameMode == .twoPlayer) || (isYourTurn.myTurn && gameMode != .mpcPlay) {
            processThisTurn(button: sender)
        } else if isYourTurn.myTurn && gameMode == .mpcPlay {
            //TODO: mpc send
        }
    }
    
    //MARK: - Game circle - 3b. NPC choose position
    
    func npcTurn() {
        let npc = NPC(position, turnCount)
        if gameMode == .vsNpcEasy, let targetButton = intToButton(npc.random()) {
            processThisTurn(button: targetButton)
        } else if gameMode == .vsNpcHard, let targetButton = intToButton(npc.choose()) {
            processThisTurn(button: targetButton)
        }
    }
    
    func intToButton(_ int: Int) -> UIButton? {
        switch int {
        case 1:
            return m11
        case 2:
            return m12
        case 3:
            return m13
        case 4:
            return m21
        case 5:
            return m22
        case 6:
            return m23
        case 7:
            return m31
        case 8:
            return m32
        case 9:
            return m33
        default:
            return nil
        }
    }
    
    //MARK: - Game circle - 3c. MPC return position
    
    //MARK: - Game circle - 4. Process
    func processThisTurn(button: UIButton) {
        button.isEnabled = false
        updateButtonState(button)
        updateButtonBackground(button)
        processDidFinish()
    }
    
    func updateButtonBackground(_ button: UIButton) {
        let img = position.getState(intPosition: button.tag)?.image()
        button.setBackgroundImage(img, for: .normal)
    }
    
    func updateButtonState(_ button: UIButton) {
        var state: Position.State = .nothing
        if isYourTurn.myTurn {
            state = .circle
        } else {
            state = .cross
        }
        position.updateState(state: state, intPosition: button.tag)
    }
    
    //MARK: - Game circle - 5. Decide did game end
    func processDidFinish() {
        let didWin = position.checkDidWin()
        if didWin || turnCount == 9 {
            // Go Game circle - 6
            finishGame(didWin)
        } else {
            // Return Game circle - 2
            turnCount += 1
            isYourTurn.nextTurn()
            newTurn()
        }
    }
    
    //MARK: - Game circle - 6. Finish Game
    func finishGame(_ didWin: Bool) {
        if turnCount == 9, !didWin {
            updateLabel("Draw!", "Draw!")
        } else if isYourTurn.myTurn {
            updateLabel("You Win!", "You Lose!")
        } else {
            updateLabel("You Lose!", "You Win!")
        }
        boardButtonIsEnable(false)
        restartButtonIsHidden(false)
    }
    
    func checkWinPosition(_ winPos: Position.WinPosition) {
        color = UIColor.red
        switch winPos {
        case .row1:
            row1Line = addSubView(x: 0, y: baseUIViewSize/6, width: baseUIViewSize, height: 3, color: color)
        case .row2:
            row2Line = addSubView(x: 0, y: baseUIViewSize/2, width: baseUIViewSize, height: 3, color: color)
        case .row3:
            row3Line = addSubView(x: 0, y: 5 * baseUIViewSize/6, width: baseUIViewSize, height: 3, color: color)
        case .col1:
            column1Line = addSubView(x: baseUIViewSize/6, y: 0, width: 3, height: baseUIViewSize, color: color)
        case .col2:
            column2Line = addSubView(x: baseUIViewSize/2, y: 0, width: 3, height: baseUIViewSize, color: color)
        case .col3:
            column3Line = addSubView(x: 5 * baseUIViewSize/6, y:0, width: 3, height: baseUIViewSize, color: color)
        case .lr:
//            lrLine?.removeFromSuperview()
            lrLine = drawLDiagonalLineLR()
        case .rl:
//            rlLine?.removeFromSuperview()
            rlLine = drawLDiagonalLineRL()
        }
    }
    
    func drawLDiagonalLineLR() -> UIView {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 16, y: 18))
        path.addLine(to: CGPoint(x: 18, y: 16))
        path.addLine(to: CGPoint(x: baseUIViewSize - 16, y: baseUIViewSize - 18))
        path.addLine(to: CGPoint(x: baseUIViewSize - 18, y: baseUIViewSize - 16))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        return addSubView(x: 0, y: 0, width: baseUIViewSize, height: baseUIViewSize, color: color, mask: maskLayer)
    }
    
    func drawLDiagonalLineRL() -> UIView {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: baseUIViewSize - 16, y: 18))
        path.addLine(to: CGPoint(x: baseUIViewSize - 18, y: 16))
        path.addLine(to: CGPoint(x: 16, y: baseUIViewSize - 18))
        path.addLine(to: CGPoint(x: 18, y: baseUIViewSize - 16))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        return addSubView(x: 0, y: 0, width: baseUIViewSize, height: baseUIViewSize, color: color, mask: maskLayer)
    }
    
    //MARK: - Game circle - 7. Restart Game
    @IBAction func restartButtonDidTapped(_ sender: Any) {
        restart()
    }
    
    func restart() {
        resetVar()
        resetView()
        newGame() // Return to Game Circle - 1
    }
    
    func resetVar() {
        turnCount = 1
        position = Position()
        position.delegate = self
    }
    
    func resetView() {
        resetBoardView()
        boardButtonIsEnable(true)
        restartButtonIsHidden(true)
        resetBoardBackgroundImage()
    }
    
    func resetBoardView() {
        let subViews = [row1Line, row2Line, row3Line, column1Line, column2Line, column3Line, lrLine, rlLine]
        for subView in subViews {
            subView?.removeFromSuperview()
        }
    }
    
    func resetBoardBackgroundImage() {
        m11.setBackgroundImage(nil, for: .normal)
        m12.setBackgroundImage(nil, for: .normal)
        m13.setBackgroundImage(nil, for: .normal)
        m21.setBackgroundImage(nil, for: .normal)
        m22.setBackgroundImage(nil, for: .normal)
        m23.setBackgroundImage(nil, for: .normal)
        m31.setBackgroundImage(nil, for: .normal)
        m32.setBackgroundImage(nil, for: .normal)
        m33.setBackgroundImage(nil, for: .normal)
    }
    
    //MARK: - Common func
    @discardableResult
    func addSubView(x: Double, y: Double, width: Double, height: Double, color: UIColor) -> UIView {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        let newUIView = UIView(frame: rect)
        newUIView.backgroundColor = color
        baseUIView.addSubview(newUIView)
        return newUIView
    }
    
    @discardableResult
    func addSubView(x: Double, y: Double, width: Double, height: Double, color: UIColor, mask: CAShapeLayer) -> UIView {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        let newUIView = UIView(frame: rect)
        newUIView.backgroundColor = color
        newUIView.layer.mask = mask
        baseUIView.addSubview(newUIView)
        return newUIView
    }
    
    func boardButtonIsEnable(_ bool: Bool) {
        m11.isEnabled = bool
        m12.isEnabled = bool
        m13.isEnabled = bool
        m21.isEnabled = bool
        m22.isEnabled = bool
        m23.isEnabled = bool
        m31.isEnabled = bool
        m32.isEnabled = bool
        m33.isEnabled = bool
    }
    
    func restartButtonIsHidden(_ bool: Bool) {
        upperButton.isHidden = bool
        bottomButton.isHidden = bool
    }
    
    func updateLabel(upper: String) {
        upperLabel.isHidden = false
        upperLabel.text = upper
        bottomLabel.isHidden = true
    }
    
    func updateLabel(bottom: String) {
        upperLabel.isHidden = true
        bottomLabel.isHidden = false
        bottomLabel.text = bottom
    }
    
    func updateLabel(_ upper: String, _ bottom: String) {
        upperLabel.isHidden = false
        bottomLabel.isHidden = false
        upperLabel.text = upper
        bottomLabel.text = bottom
    }
}



