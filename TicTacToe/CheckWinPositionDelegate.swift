//
//  CheckWinPositionDelegate.swift
//  TicTacToe
//
//  Created by Jason Chow on 27/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import Foundation

protocol CheckWinPositionDelegate {
    func checkWinPosition(_ winPos: Position.WinPosition)
}
