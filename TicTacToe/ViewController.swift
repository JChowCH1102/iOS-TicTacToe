//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jason Chow on 18/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var baseUIView : UIView!
    var baseUIViewWidth = 0.0
    var baseUIViewHeight = 0.0
    var color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseUIViewWidth = Double(baseUIView.bounds.width)
        baseUIViewHeight = Double(baseUIView.bounds.height)
        createBoard()
    }
    
    func createBoard() {
        if self.traitCollection.userInterfaceStyle == .dark {
            color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }  else {
            color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        addSubView(x: baseUIViewWidth/3, y: 0, width: 4, height: baseUIViewWidth, color: color)
        addSubView(x: 2*baseUIViewWidth/3, y: 0, width: 4, height: baseUIViewWidth, color: color)
        addSubView(x: 0, y: baseUIViewHeight/3, width: baseUIViewHeight, height: 4, color: color)
        addSubView(x: 0, y: 2*baseUIViewHeight/3, width: baseUIViewHeight, height: 4, color: color)
    }
    
    func addSubView(x: Double, y: Double, width: Double, height: Double, color: UIColor) {
        let newUIView = CGRect(x: x, y: y, width: width, height: height)
        let rect = UIView(frame: newUIView)
        rect.backgroundColor = color
        baseUIView.addSubview(rect)
    }
}

