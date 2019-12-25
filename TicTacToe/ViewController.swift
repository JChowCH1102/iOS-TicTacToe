//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jason Chow on 18/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import UIKit

enum winPosition {
    case row0
    case row1
    case row2
    case col0
    case col1
    case col2
    case lr
    case rl
}

class ViewController: UIViewController {
    
    @IBOutlet var baseUIView : UIView!
    var baseUIViewSize = 0.0
    var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    weak var upperLine: UIView!
    weak var lowerLine: UIView!
    weak var leftLine: UIView!
    weak var rightLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseUIViewSize = Double(baseUIView.frame.width)
        createBoard()
        //        drawWinLine(winPos: .row0)
        //        drawWinLine(winPos: .row1)
        //        drawWinLine(winPos: .row2)
        //        drawWinLine(winPos: .col0)
        //        drawWinLine(winPos: .col1)
        //        drawWinLine(winPos: .col2)
        //        drawWinLine(winPos: .lr)
        //        drawWinLine(winPos: .rl)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upperLine?.frame = CGRect(x: 0, y: baseUIView.frame.height / 3, width: baseUIView.frame.width, height: 4)
        lowerLine?.frame = CGRect(x: 0, y: 2 * baseUIView.frame.height / 3, width: baseUIView.frame.width, height: 4)
        leftLine?.frame = CGRect(x: baseUIView.frame.width / 3, y:0, width: 4, height: baseUIView.frame.height)
        rightLine?.frame = CGRect(x: 2 * baseUIView.frame.height / 3, y: 0 , width: 4, height: baseUIView.frame.height)
        //        upperLine.frame = CGRect(x: 0, y: 0, width: baseUIView.frame.width, height: baseUIView.frame.height)
    }
    
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
    }
    
    @discardableResult
    func addSubView(x: Double, y: Double, width: Double, height: Double, color: UIColor) -> UIView {
        let newUIView = CGRect(x: x, y: y, width: width, height: height)
        let rect = UIView(frame: newUIView)
        rect.backgroundColor = color
        baseUIView.addSubview(rect)
        return rect
    }
    
    func addSubView(x: Double, y: Double, width: Double, height: Double, color: UIColor, mask: CAShapeLayer) {
        let newUIView = CGRect(x: x, y: y, width: width, height: height)
        let rect = UIView(frame: newUIView)
        rect.backgroundColor = color
        rect.layer.mask = mask
        baseUIView.addSubview(rect)
    }
    
    func drawLDiagonalLineLR() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 16, y: 18))
        path.addLine(to: CGPoint(x: 18, y: 16))
        path.addLine(to: CGPoint(x: baseUIViewSize - 16, y: baseUIViewSize - 18))
        path.addLine(to: CGPoint(x: baseUIViewSize - 18, y: baseUIViewSize - 16))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        addSubView(x: 0, y: 0, width: baseUIViewSize, height: baseUIViewSize, color: color, mask: maskLayer)
    }
    
    func drawLDiagonalLineRL() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: baseUIViewSize - 16, y: 18))
        path.addLine(to: CGPoint(x: baseUIViewSize - 18, y: 16))
        path.addLine(to: CGPoint(x: 16, y: baseUIViewSize - 18))
        path.addLine(to: CGPoint(x: 18, y: baseUIViewSize - 16))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        addSubView(x: 0, y: 0, width: baseUIViewSize, height: baseUIViewSize, color: color, mask: maskLayer)
    }
    
    func drawWinLine(winPos: winPosition) {
        color = UIColor.red
        switch winPos {
        case .row0:
            addSubView(x: baseUIViewSize/6, y: 0, width: 3, height: baseUIViewSize, color: color)
        case .row1:
            addSubView(x: baseUIViewSize/2, y: 0, width: 3, height: baseUIViewSize, color: color)
        case .row2:
            addSubView(x: 5 * baseUIViewSize/6, y:0, width: 3, height: baseUIViewSize, color: color)
        case .col0:
            addSubView(x: 0, y: baseUIViewSize/6, width: baseUIViewSize, height: 3, color: color)
        case .col1:
            addSubView(x: 0, y: baseUIViewSize/2, width: baseUIViewSize, height: 3, color: color)
        case .col2:
            addSubView(x: 0, y: 5 * baseUIViewSize/6, width: baseUIViewSize, height: 3, color: color)
        case .lr:
            drawLDiagonalLineLR()
        case .rl:
            drawLDiagonalLineRL()
        }
    }
    
    @IBAction func buttonDidTapped(_ sender: UIButton) {
        updateButtonBackground(sender)
        updateButtonState(sender)
    }
    
    func updateButtonBackground(_ button: UIButton) {
        button.setBackgroundImage(UIImage(named: "cross"), for: .normal)
    }
    
    func updateButtonState(_ button: UIButton) {
        button.isEnabled = false
    }
}

