//
//  AddSubView.swift
//  TicTacToe
//
//  Created by Jason Chow on 23/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import Foundation

class AddSubView {
    var x: Double
    var y: Double
    var color: Double
    
    init(x: Double, y: Double, width: Double, height: Double, color: UIColor) {
        let newUIView = CGRect(x: x, y: y, width: width, height: height)
        let rect = UIView(frame: newUIView)
        rect.backgroundColor = color
        bgUIView.addSubview(rect)
    }

}
