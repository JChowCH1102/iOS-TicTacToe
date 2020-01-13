//
//  Position.swift
//  TicTacToe
//
//  Created by Jason Chow on 25/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import Foundation
import UIKit

struct Position {
    enum State {
        case nothing
        case circle
        case cross
        
        func image() -> UIImage? {
            switch self {
            case .nothing:
                return nil
            case .circle:
                return UIImage(named: "circle")
            case .cross:
                return UIImage(named: "cross")
            }
        }
    }
    
    enum WinPosition {
        case row1
        case row2
        case row3
        case col1
        case col2
        case col3
        case lr
        case rl
    }
    
    var m11: State = .nothing
    var m12: State = .nothing
    var m13: State = .nothing
    var m21: State = .nothing
    var m22: State = .nothing
    var m23: State = .nothing
    var m31: State = .nothing
    var m32: State = .nothing
    var m33: State = .nothing
    
    var delegate: CheckWinPositionDelegate?
    
    func getState(intPosition: Int) -> State? {
        if intPosition >= 1, intPosition <= 9 {
            return getState(row: (intPosition - 1) / 3 + 1, column: (intPosition - 1) % 3 + 1)
        } else {
            return nil
        }
    }
    
    func getState(row: Int, column: Int) -> State? {
        if row == 1 && column == 1 {
            return m11
        } else if row == 1, column == 2 {
            return m12
        } else if row == 1, column == 3 {
            return m13
        } else if row == 2, column == 1 {
            return m21
        } else if row == 2, column == 2 {
            return m22
        } else if row == 2, column == 3 {
            return m23
        } else if row == 3, column == 1 {
            return m31
        } else if row == 3, column == 2 {
            return m32
        } else if row == 3, column == 3 {
            return m33
        }
        return nil
    }
    
    mutating func updateState(state: State, intPosition: Int) {
        if intPosition >= 1, intPosition <= 9 {
            return updateState(state: state,row: (intPosition - 1) / 3 + 1, column: (intPosition - 1) % 3 + 1)
        }
    }
    
    mutating func updateState(state: State, row: Int, column: Int) {
        if row == 1 && column == 1 {
            m11 = state
        } else if row == 1, column == 2 {
            m12 = state
        } else if row == 1, column == 3 {
            m13 = state
        } else if row == 2, column == 1 {
            m21 = state
        } else if row == 2, column == 2 {
            m22 = state
        } else if row == 2, column == 3 {
            m23 = state
        } else if row == 3, column == 1 {
            m31 = state
        } else if row == 3, column == 2 {
            m32 = state
        } else if row == 3, column == 3 {
            m33 = state
        }
    }
    
    func checkDidWin() -> Bool {
        var win = false
        if m11 == m12, m11 == m13, m11 != .nothing {
            self.delegate?.checkWinPosition(.row1)
            win = true
        }
        if m21 == m22, m21 == m23, m21 != .nothing {
            self.delegate?.checkWinPosition(.row2)
            win = true
        }
        if m31 == m32, m31 == m33, m31 != .nothing {
            self.delegate?.checkWinPosition(.row3)
            win = true
        }
        if m11 == m21, m11 == m31, m11 != .nothing {
            self.delegate?.checkWinPosition(.col1)
            win = true
        }
        if m12 == m22, m12 == m32, m12 != .nothing {
            self.delegate?.checkWinPosition(.col2)
            win = true
        }
        if m13 == m23, m13 == m33, m13 != .nothing {
            self.delegate?.checkWinPosition(.col3)
            win = true
        }
        if m11 == m22, m11 == m33, m11 != .nothing {
            self.delegate?.checkWinPosition(.lr)
            win = true
        }
        if m13 == m22, m13 == m31, m13 != .nothing {
            self.delegate?.checkWinPosition(.rl)
            win = true
        }
        return win
    }
}
