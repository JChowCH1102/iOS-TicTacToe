//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jason Chow on 18/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, CheckWinPositionDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    private let SERVICE_TYPE: String = "jchowch-ttt"
    
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
    var didThisIsServer: Bool?
    
    //MARK: - MPC
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var messageToSend: String!
    
    func initMpc() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        updateLabel(upper: "wait connect")
        showConnectionMenu()
    }
    
    @objc func showConnectionMenu() {
        let ac = UIAlertController(title: "Connection Menu", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: hostSession))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func hostSession(action: UIAlertAction) {
        didThisIsServer = true
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: SERVICE_TYPE, discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction) {
        didThisIsServer = false
        let mcBrowser = MCBrowserViewController(serviceType: SERVICE_TYPE, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            //            readyToLoadBoard = true
            DispatchQueue.main.async {
                self.createBoard()
            }
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            print("fatal error")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [unowned self] in
            let message = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
            print(message)
            
            for i in 1...9 {
                if message == "\(i)" {
                    self.mpcReceived(i)
                }
            }
            
            if message == "Your Turn First" {
                self.isYourTurn.myTurn = true
                self.updateLabel(upper: "Is Your Turn")
            } else if message == "Not Your Turn First" {
                self.isYourTurn.myTurn = false
                self.updateLabel(bottom: "Is Your Turn")
            } else if message == "Restart" {
                self.restart()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func mpcSend(_ message: String) {
        messageToSend = "\(message)"
        let message = messageToSend.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
            try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .unreliable)
        }
        catch {
            print("Error sending message")
        }
    }
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        bottomButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        position.delegate = self
        
        if gameMode == GameMode.mpcPlay {
            initMpc()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseUIViewSize = Double(baseUIView.frame.width)
        
        if gameMode != GameMode.mpcPlay  {
            createBoard()
        }
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
        
        if gameMode == GameMode.mpcPlay {
            if didThisIsServer ?? false {
                isYourTurn = Player()
                if isYourTurn.myTurn {
                    mpcSend("Not Your Turn First")
                } else {
                    mpcSend("Your Turn First")
                }
            }
        } else {
            isYourTurn = Player()
        }
        newTurn()
    }
    
    //MARK: - Game circle - 2. new Turn
    func newTurn() {
        guard let game = gameMode else {
            return
        }
        
        switch game {
        case .vsNpcEasy, .vsNpcHard:
            npcTurn()
        case .mpcPlay:
            
            break
        case .twoPlayer:
            break
        }
        
        if isYourTurn.myTurn {
            updateLabel(upper: "Is Your Turn")
        } else {
            updateLabel(bottom: "Is Your Turn")
        }
    }
    //MARK: - Game circle - 3a. Player choose position
    @IBAction func buttonDidTapped(_ sender: UIButton) {
        if (!isYourTurn.myTurn && gameMode == .twoPlayer) || (isYourTurn.myTurn) {
            processThisTurn(button: sender)
            if gameMode == .mpcPlay {
                mpcSend(String(sender.tag))
            }
        }
        //        else if isYourTurn.myTurn && gameMode == .mpcPlay {
        //            //TODO: mpc send
        //        }
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
    
    //MARK: - Game circle - 3c. MPC return position
    func mpcReceived(_ mpcPos: Int) {
        if let targetButton = intToButton(mpcPos) {
            processThisTurn(button: targetButton)
        }
    }
    
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
        mpcSend("Restart")
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
        if gameMode == GameMode.twoPlayer {
            bottomButton.isHidden = bool
        }
    }
    
    func updateLabel(upper: String) {
        upperLabel.isHidden = false
        upperLabel.text = upper
        bottomLabel.isHidden = true
    }
    
    func updateLabel(bottom: String) {
        if gameMode == GameMode.twoPlayer{
            upperLabel.isHidden = true
            bottomLabel.isHidden = false
            bottomLabel.text = bottom
        } else {
            let newUpperText = "Wait the other Player"
            updateLabel(upper: newUpperText)
        }
    }
    
    func updateLabel(_ upper: String, _ bottom: String) {
        if gameMode == GameMode.twoPlayer {
            upperLabel.isHidden = false
            bottomLabel.isHidden = false
            upperLabel.text = upper
            bottomLabel.text = bottom
        } else {
            updateLabel(upper: upper)
        }
    }
}



