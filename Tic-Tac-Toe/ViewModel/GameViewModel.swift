//
//  GAmeViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Coder ACJHP on 13.07.2023.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let colums: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let winPatterns: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],
        [0, 3, 6], [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6]
    ]
    
    let centerSquare = 4
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    public func processPlayerMove(for position: Int) {
        
        // Wait for human to play
        if isSquareIsOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        isGameBoardDisabled.toggle()
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.gameOver
            return
        }
    
        // Make computer move after few sec delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerMovePosition = determineComputerMovePosition(in: moves)
            moves[computerMovePosition] = Move(player: .computer, boardIndex: computerMovePosition)
            isGameBoardDisabled.toggle()
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.gameOver
                return
            }
        }
    }
    
    private func isSquareIsOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    private func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        // If AI can win, then win
    
        let computerPositions = getPositions(for: .computer)
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                // Check avaliability of square
                let isAvailable = !isSquareIsOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't win, then block
        
        let humanPositions = getPositions(for: .human)
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                // Check avaliability of square
                let isAvailable = !isSquareIsOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't block, then take middle square
        
        if !isSquareIsOccupied(in: moves, forIndex: centerSquare) { return centerSquare }
        
        
        // If AI can't take middle square, then take random square
        var movePosition = Int.random(in: 0 ..< 9)
        while isSquareIsOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0 ..< 9)
        }
        return  movePosition
    }
    
    private func getPositions(for player: Player) -> Set<Int> {
        let moves = moves.compactMap { $0 }.filter { $0.player == player }
        let positions = Set(moves.map { $0.boardIndex })
        return  positions
    }
    
    private func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let playerPositions = getPositions(for: player)
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false
    }
    
    private func checkForDraw(in moves: [Move?]) -> Bool {
        moves.compactMap { $0 }.count == 9
    }
    
    public func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
        alertItem = nil
    }
}
