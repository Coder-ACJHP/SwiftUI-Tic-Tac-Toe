//
//  GameModel.swift
//  Tic-Tac-Toe
//
//  Created by Coder ACJHP on 13.07.2023.
//

import Foundation

public enum Player {
    case computer, human
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        player == .human ? "xmark" : "circle"
    }
}
