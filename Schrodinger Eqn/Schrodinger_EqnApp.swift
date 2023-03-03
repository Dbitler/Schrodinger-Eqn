//
//  Schrodinger_EqnApp.swift
//  Schrodinger Eqn
//
//  Created by IIT PHYS 440 on 2/24/23.
//

import SwiftUI

@main
struct Schrodinger_EqnApp: App {
    @StateObject var plotData = PlotClass()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plotData)
                .tabItem {
                    Text("Plot")
                }
        }
    }
}
