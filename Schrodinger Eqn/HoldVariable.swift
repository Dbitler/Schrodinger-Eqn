//
//  HoldVariable.swift
//  Quantum-Orbital
//
//  Created by IIT PHYS 440 on 2/10/23.
//

import SwiftUI

class HoldVariable: ObservableObject {
    
    @ObservedObject private var calculator = CalculatePlotData()
    @Published var insideData = [(xPoint: Double, yPoint: Double)]()
    @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    
    enum Orientation: String, CaseIterable, Identifiable {
        case XY, XZ, YZ
        var id: Self { self }
    }
    
    
    @Published var selectedOrientation: Orientation = .XY
    
    var xmaxstring = ""
    var xminstring = ""
    var ymaxstring = ""
    var yminstring = ""
    var zmaxstring = ""
    var zminstring = ""
    var integral = 0.0
    var guesses = 0
    var inneratomicspacing = ""
    //inner atomic spacing
    var iterations = ""

    

}
