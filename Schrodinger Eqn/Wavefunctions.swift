//
//  Wavefunctions.swift
//  Quantum-Orbital
//
//  Created by IIT PHYS 440 on 2/17/23.
//

import SwiftUI

class Wavefunctions: ObservableObject {
    @Published var wavefxnData = [(xPoint: Double, PsiPoint: Double)]()
    @Published var wavefxnprimeData = [(xPoint: Double, PsiprimePoint: Double)]()
    @Published var wavefxndoubleprimeData = [(xPoint: Double, PsidoubleprimePoint: Double)]()
    
}
