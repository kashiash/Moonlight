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

    var body: some View {
        Text(String(astronauts.count))
        NavigationStack {
            NavigationLink {
                Text("Detail View")
                Image(.example)
            } label: {
                VStack {
                    Text("This is the label")
                    Text("So is this")
                    Image(.example)
                }
                .font(.largeTitle)
            }
        }
    }
}

#Preview {
    ContentView()
}
