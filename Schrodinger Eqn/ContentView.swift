//
//  ContentView.swift
//  Schrodinger Eqn
//
//  Created by IIT PHYS 440 on 2/24/23.
//

/* make a program that calculates the solution for a 1D Schrodinger eqn using the differential form of the eqn use Runge Kutta 4 to solve the differential equation. should be able to load in and solve. TIME INDEPENDENT.
 
    eqn: -(h-bar)^2/2m dPhi^2/dx^2 + V(x)Phi = E_Phi.
 plot the wave function, the potential, and the functional.
 
 */

import SwiftUI
import Charts

struct ContentView: View {
    @ObservedObject var myfunctionalinstance = Functional()
    @ObservedObject var mypotentialinstance = Potential()
    @ObservedObject var mywavefxnvariableinstance = Wavefunctions()
    @ObservedObject var myholdvariableinstance = HoldVariable()
    @EnvironmentObject var plotData :PlotClass
    //@State var plotData = [PlotDataStruct]()
    @ObservedObject private var calculator = CalculatePlotData()
    @State var isChecked:Bool = false
    @State var tempInput = ""
    @State var selector = 0
    @MainActor func setObjectWillChange(theObject:PlotClass){
        
        theObject.objectWillChange.send()
        
    }
    @MainActor func setupPlotDataModel(selector: Int){
        
        calculator.plotDataModel = self.plotData.plotArray[selector]
    }
 
    @State var psi_0 = 0.0
    @State var psi_n = 0.0
    @State var psi_nplus1 = 0.0
    @State var psi_prime_n = 0.0
    @State var psi_prime_nplus1 = 0.0
    @State var delta_xstring = "0.05" //The size of delta_x determines the granularity of the Euler's solution, how accurate it is.
    @State var delta_x = 0.005
    @State var x_max = 10.0
    @State var x_min = 0.0
    @State var x_maxstring = "10.0"
    @State var x_minstring = "0.0"
    @State var length = 10.0
    @State var potential = 0.0
    @State var psi_doubleprime_n = 0.0
    @State var m_e = 510998.950 //MeV/c^2 (0.51 MeV)v FIX THESEE UNITS   eV* s^2/(eV^2 * s^2 * m^2) = 1/eV * m^2
    @State var h_barc = 0.1973269804 //eV⋅μm
    @State var E0string = "0.0" //E0 is an input
    @State var E_maxstring = "30.0" //E would be an input.
    @State var E0 = 0.0
    @State var E_max = 30.0
    @State var E_step = 0.005
    @State var E_stepstring = "0.05" //also an input.
    
    var body: some View {
        HStack{
            VStack {
                Text("Enter length parameters")
                HStack {
                    TextField("x-step", text: $delta_xstring)
                    TextField("x-max", text: $x_minstring)
                    TextField("x-min", text: $x_maxstring)
                }
                Text("Enter energy Parameters")
                HStack {
                    TextField("E-step", text: $E_stepstring)
                    TextField("E-min", text: $E0string)
                    TextField("E-max", text: $E_maxstring)
                }
                
                
                Button(action: self.schrodingersoln) {
                    Text("Calculate")
                }
                Button(action: self.graph) {
                    Text("Plot")
                }
            }
            VStack{
                Chart($plotData.plotArray[selector].plotData.wrappedValue) {
                    LineMark(
                        x: .value("Energy", $0.xVal),
                        y: .value("Functional", $0.yVal)
                        
                    )
                    .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                    PointMark(x: .value("Position", $0.xVal), y: .value("Height", $0.yVal))
                    
                        .foregroundStyle($plotData.plotArray[selector].changingPlotParameters.lineColor.wrappedValue)
                    
                    
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .padding()
                Text($plotData.plotArray[selector].changingPlotParameters.xLabel.wrappedValue)
                    .foregroundColor(.red)
             }
            }
            
        }
    

    func potentials(){
        
    }
    /// function utilizes the schrodinger equation, Looping over E, looping over x within that loop, 
    ///
    ///it finds the value of phi double prime first, utilizing the given potential and that loop's E, and then uses that with the following equations to find the next phi, Phi n+1. Then it redoes the steps
    ///
    ///
    ///
    func schrodingersoln(){
        
        
        
        /* at the boundaries of the bounding box, psi_0 = 0, and psi_L = 0.
         */
        delta_x = Double(delta_xstring)!
         E0 = Double(E0string)!
        E_max = Double(E_maxstring)!
        psi_prime_n = 5
        E_step = Double(E_stepstring)!

        let C = -((2.0 * m_e) / pow(h_barc, 2.0)) * pow(1E-4,2) // h = eV*s ; m_e = eV/c^2 = eV * s^2/ m^2 => h^2/m = eV*m => eV* Angstrom = eV* m * 1E-10
        //h-bar * c = 0.1973269804... eV⋅μm
        print(C)
        print((2/C))
        
        mypotentialinstance.PotentialData = []
        mywavefxnvariableinstance.wavefxnData = []
        mywavefxnvariableinstance.wavefxnprimeData = []
        mywavefxnvariableinstance.wavefxndoubleprimeData = []
        myfunctionalinstance.functionalData = []
        
        mypotentialinstance.particleinaboxcalc(xmin: 0, xmax: length, delta_x: self.delta_x)
//        print(mypotentialinstance.PotentialData)
        
        
        for energy in stride(from: E0, to: E_max, by: E_step) {
            mywavefxnvariableinstance.wavefxnData = []
            mywavefxnvariableinstance.wavefxnprimeData = []
            
            
            mywavefxnvariableinstance.wavefxnData.append((xPoint: x_min, PsiPoint:  0.0))
            mywavefxnvariableinstance.wavefxnprimeData.append((xPoint: x_min, PsiprimePoint: 7.0)) //Psiprimepoint is arbitrarily chosen number, could be anything
            
            psi_doubleprime_n = C * mywavefxnvariableinstance.wavefxnData[0].PsiPoint * ( energy - mypotentialinstance.PotentialData[0].PotentialPoint)
            
            mywavefxnvariableinstance.wavefxndoubleprimeData.append((xPoint: x_min, PsidoubleprimePoint: psi_doubleprime_n))
            
            for n in stride(from: 1, to: mypotentialinstance.PotentialData.count, by: 1){
                let x = Double(n) * delta_x
               
                    psi_doubleprime_n = C * mywavefxnvariableinstance.wavefxnData[n-1].PsiPoint * ( energy - mypotentialinstance.PotentialData[n-1].PotentialPoint)
                    psi_prime_nplus1 = mywavefxnvariableinstance.wavefxnprimeData[n-1].PsiprimePoint + (psi_doubleprime_n * delta_x)
                    psi_nplus1 = mywavefxnvariableinstance.wavefxnData[n-1].PsiPoint + (mywavefxnvariableinstance.wavefxnprimeData[n-1].PsiprimePoint * delta_x)
                    
                    mywavefxnvariableinstance.wavefxnprimeData.append((xPoint: x, PsiprimePoint: psi_prime_nplus1))
                    mywavefxnvariableinstance.wavefxnData.append((xPoint: x, PsiPoint:  psi_nplus1))
                    
                    mywavefxnvariableinstance.wavefxndoubleprimeData.append((xPoint: x, PsidoubleprimePoint: psi_doubleprime_n))

                
                
            }
            print(mywavefxnvariableinstance.wavefxnData)
            
            
            let functionalpoint = mywavefxnvariableinstance.wavefxnData[ mywavefxnvariableinstance.wavefxnData.count-1].PsiPoint - 0.0
            
            myfunctionalinstance.functionalData.append((energyPoint: energy, FunctionalPoint: functionalpoint))
            print(energy)
        }
        print(myfunctionalinstance.functionalData)
    }
    
    func graph(){
        schrodingersoln()
        self.plotData.plotArray[0].plotData = []
        calculator.plotDataModel = self.plotData.plotArray[0]
        
        for m in 0...myfunctionalinstance.functionalData.count-1{
            calculator.appendDataToPlot(plotData: [(x: myfunctionalinstance.functionalData[m].energyPoint, y: myfunctionalinstance.functionalData[m].FunctionalPoint)])
        }
        
        setObjectWillChange(theObject: self.plotData)
        
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
