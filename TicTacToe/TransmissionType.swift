//
//  TransmissionType.swift
//  TicTacToe
//
//  Created by Jason Chow on 14/1/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import Foundation

enum TransmissionType: String {
    case isYourStart = "IS_YOUR_TURN"
    case isNotYourStart = "IS_NOT_YOUR_TURN"
    case isRestarted = "IS_RESTART"
}
