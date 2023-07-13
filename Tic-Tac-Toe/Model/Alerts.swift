//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Coder ACJHP on 13.07.2023.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    
    static let humanWin = AlertItem(
        title: Text("You Win 🎉"),
        message: Text("You're so smart. You beat your own AI."),
        buttonTitle: Text("Hell Yeah")
    )
    
    static let computerWin = AlertItem(
        title: Text("You Lose! 😱"),
        message: Text("You programmed a super AI."),
        buttonTitle: Text("Rematch")
    )
    
    static let gameOver = AlertItem(
        title: Text("Game Over"),
        message: Text("Would you like to try again?"),
        buttonTitle: Text("Try Again")
    )
}
