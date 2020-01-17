//
//  NPC.swift
//  TicTacToe
//
//  Created by Jason Chow on 27/12/2019.
//  Copyright © 2019 Jason Chow. All rights reserved.
//

import Foundation

class NPC {
    var position: Position?
    var turnCount: Int?
    
    init(_ position: Position, _ turnCount: Int) {
        self.position = position
        self.turnCount = turnCount
    }
    
    func random() -> Int{
        var availablePosition: [Int] = []
        for i in 1...9 {
            if position?.getState(intPosition: i) == Position.State.nothing {
                availablePosition.append(i)
            }
        }
        return availablePosition.randomElement()!
    }
    
    func choose() -> Int {
        if turnCount == 1 {
            return 1
        } else if turnCount == 2 || turnCount == 3 {
            return turnTwoOrThreeChoose()
        } else if turnCount == 9 {
            return random()
        } else {
            return analysis()
        }
    }
    
    func turnTwoOrThreeChoose() -> Int {
        if position?.getState(intPosition: 5) == Position.State.nothing {
            return 5
        } else if position?.getState(intPosition: 1) == Position.State.nothing {
            return 1
        } else if let checkFourPos = checkFourPosition() {
            return checkFourPos
        } else {
            return random()
        }
    }
    
    func analysis() -> Int {
        for i in 1...3 {
            if let checkCircleRow = checkAnyTwoCrossNearby(posAX: i, posAY: 1, posBX: i, posBY: 2, posCX: i, posCY: 3) {
                return checkCircleRow
            } else if let checkCircleColumn = checkAnyTwoCrossNearby(posAX: 1, posAY: i, posBX: 2, posBY: i, posCX: 3, posCY: i) {
                return checkCircleColumn
            }
        }
        
        if let checkCircleLR = checkAnyTwoCrossNearby(posAX: 1, posAY: 1, posBX: 2, posBY: 2, posCX: 3, posCY: 3) {
            return checkCircleLR
        } else if let checkCircleRL = checkAnyTwoCrossNearby(posAX: 3, posAY: 1, posBX: 2, posBY: 2, posCX: 1, posCY: 3) {
            return checkCircleRL
        }
        
        for i in 1...3 {
            if let checkCircleRow = checkAnyTwoCircleNearby(posAX: i, posAY: 1, posBX: i, posBY: 2, posCX: i, posCY: 3) {
                return checkCircleRow
            } else if let checkCircleColumn = checkAnyTwoCircleNearby(posAX: 1, posAY: i, posBX: 2, posBY: i, posCX: 3, posCY: i) {
                return checkCircleColumn
            }
        }
        
        if let checkCircleLR = checkAnyTwoCircleNearby(posAX: 1, posAY: 1, posBX: 2, posBY: 2, posCX: 4, posCY: 4) {
            return checkCircleLR
        } else if let checkCircleRL = checkAnyTwoCircleNearby(posAX: 2, posAY: 2, posBX: 3, posBY: 3, posCX: 6, posCY: 6) {
            return checkCircleRL
        } else if let checkCircleLR = checkAnyTwoCircleNearby(posAX: 4, posAY: 4, posBX: 7, posBY: 2, posCX: 3, posCY: 3) {
            return checkCircleLR
        } else if let checkCircleRL = checkAnyTwoCircleNearby(posAX: 3, posAY: 1, posBX: 2, posBY: 2, posCX: 1, posCY: 3) {
            return checkCircleRL
        }
        
        if let checkCircleLR = checkAnyTwoCircleNearby(posAX: 1, posAY: 1, posBX: 2, posBY: 2, posCX: 3, posCY: 3) {
            return checkCircleLR
        } else if let checkCircleRL = checkAnyTwoCircleNearby(posAX: 3, posAY: 1, posBX: 2, posBY: 2, posCX: 1, posCY: 3) {
            return checkCircleRL
        }
        
        if let checkSpecialCase = checkAnyTwoCircleNearby(posAX: 1, posAY: 1, posBX: 1, posBY: 2, posCX: 2, posCY: 1) {
            return checkSpecialCase
        } else if let checkSpecialCase = checkAnyTwoCircleNearby(posAX: 1, posAY: 2, posBX: 1, posBY: 3, posCX: 2, posCY: 3) {
            return checkSpecialCase
        } else if let checkSpecialCase = checkAnyTwoCircleNearby(posAX: 2, posAY: 1, posBX: 3, posBY: 1, posCX: 3, posCY: 2) {
            return checkSpecialCase
        } else if let checkSpecialCase = checkAnyTwoCircleNearby(posAX: 2, posAY: 3, posBX: 3, posBY: 2, posCX: 3, posCY: 3) {
            return checkSpecialCase
        }
        
        if let checkFourPos = checkFourPosition() {
            return checkFourPos
        }
        return random()
    }
    
    func checkAnyTwoCircleNearby(posAX: Int, posAY: Int, posBX: Int, posBY: Int, posCX: Int, posCY: Int) -> Int? {
        
        let positonA = position?.getState(row: posAX, column: posAY)
        let positonB = position?.getState(row: posBX, column: posBY)
        let positonC = position?.getState(row: posCX, column: posCY)
        
        if positonA == Position.State.circle, positonC != Position.State.cross, positonA == positonB {
            return rowAndCoulumnToIntPosition(posCX, posCY)
        } else if positonA == Position.State.circle, positonB != Position.State.cross, positonA == positonC {
            return rowAndCoulumnToIntPosition(posBX, posBY)
        } else if positonB == Position.State.circle, positonA != Position.State.cross, positonB == positonC {
            return rowAndCoulumnToIntPosition(posAX, posAY)
        }
        
        return nil
    }
    
    func checkAnyTwoCrossNearby(posAX: Int, posAY: Int, posBX: Int, posBY: Int, posCX: Int, posCY: Int) -> Int? {
        
        let positonA = position?.getState(row: posAX, column: posAY)
        let positonB = position?.getState(row: posBX, column: posBY)
        let positonC = position?.getState(row: posCX, column: posCY)
        
        if positonA == Position.State.cross, positonC == Position.State.nothing, positonA == positonB {
            return rowAndCoulumnToIntPosition(posCX, posCY)
        } else if positonA == Position.State.cross, positonB == Position.State.nothing, positonA == positonC {
            return rowAndCoulumnToIntPosition(posBX, posBY)
        } else if positonB == Position.State.cross, positonA == Position.State.nothing, positonB == positonC {
            return rowAndCoulumnToIntPosition(posAX, posAY)
        }
        
        return nil
    }
    
    func checkFourPosition() -> Int? {
        let positions = [2, 4, 6, 8]
        for pos in positions {
            let positionState = position?.getState(intPosition: pos)
            if positionState == Position.State.nothing {
                return pos
            }
        }
        return nil
    }
    
    func rowAndCoulumnToIntPosition(_ row: Int, _ column: Int) -> Int {
        return (row - 1) * 3 + column
    }
}
