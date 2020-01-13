//
//  Player.swift
//  TicTacToe
//
//  Created by Jason Chow on 25/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import Foundation

struct Player {
    var myTurn = Bool.random()
    
    mutating func nextTurn() {
        myTurn = !myTurn
    }
}
