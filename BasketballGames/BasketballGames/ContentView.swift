//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var score: Score
    var team: String
    var opponent: String
    var isHomeGame: Bool
    var date: String
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results: [Result] = []

    var body: some View {
        NavigationStack {
            List(results, id: \.id) { game in
                let won: Bool = game.score.unc > game.score.opponent
                VStack {
                    HStack {
                        Text("\(game.team) \(game.isHomeGame ? "vs." : "@") \(game.opponent)")
                        Spacer()
                        Text("\(game.score.unc) - \(game.score.opponent)")
                        Text(won ? "W" : "L")
                            .fontWeight(.bold)
                            .foregroundStyle(won ? .green : .red)
                    }
                    HStack {
                        Text(game.date)
                        Spacer()
                        Text(game.isHomeGame ? "Home" : "Away")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("UNC Basketball")
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball")
        else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
