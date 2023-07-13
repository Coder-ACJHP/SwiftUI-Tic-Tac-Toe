//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Coder ACJHP on 13.07.2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        GeometryReader { reader in
            VStack {
                
                Spacer()
                
                LazyVGrid(columns: viewModel.colums) {
                    ForEach(0 ..< 9) { index in
                        ZStack {
                            // Create circles
                            GameCirleView(proxy: reader)
                            // Draw indicators for players
                            PlayerIndicatorView(systemImageName: viewModel.moves[index]?.indicator ?? "")
                        }
                        .onTapGesture {
                            // What's happening when user taps on circles
                            viewModel.processPlayerMove(for: index)
                        }
                    }
                }
                // Disable all touches for a while
                .disabled(viewModel.isGameBoardDisabled)
                .padding([.leading, .trailing], 30)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(
                        title: alertItem.title,
                        message: alertItem.message,
                        dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() })
                    )
                }
                
                Spacer()
            }
        }
    }
}

struct GameCirleView: View {
    
    let proxy: GeometryProxy
    
    var body: some View {
        let circleRadius = (proxy.size.width - 90) / 3
        Circle()
            .foregroundColor(Color.yellow)
            .frame(width: circleRadius, height: circleRadius)
    }
}

struct PlayerIndicatorView: View {
    
    let systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
