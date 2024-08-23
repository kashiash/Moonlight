//
//  ContentView.swift
//  Moonlight
//
//  Created by Jacek Kosinski U on 22/08/2024.
//

import SwiftUI

struct ContentView: View {
    //let astronauts = Bundle.main.decode("astronauts.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    let missions: [Mission] = Bundle.main.decode("missions.json")


    @AppStorage("showingGrid") private var showingGrid = true
    
    var body: some View {
        NavigationStack {
            Group {
                if showingGrid {
                    GridLayout(astronauts: astronauts, missions: missions)
                } else {
                    ListLayout(astronauts: astronauts, missions: missions)
                }
            }
            .toolbar {
                Button {
                    showingGrid.toggle()
                } label: {
                    if showingGrid {
                        Label("Show as table", systemImage: "list.dash")
                    } else {
                        Label("Show as grid", systemImage: "square.grid.2x2")
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Moonshot")
            .background(.darkBackground)
        }

    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
