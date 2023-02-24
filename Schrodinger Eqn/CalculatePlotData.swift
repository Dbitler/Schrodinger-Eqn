//
//  CalculatePlotData.swift
//  Test Plot Threaded Charts
//
//  Created by Jeff Terry on 8/25/22.
//

import Foundation
import SwiftUI


class CalculatePlotData: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var theText = ""
    var logerror = 0.0
    var values = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    var Nstring = ""

    @MainActor func setThePlotParameters(color: String, xLabel: String, yLabel: String, title: String) {
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 10.0
        plotDataModel!.changingPlotParameters.yMin = 0.0
        plotDataModel!.changingPlotParameters.xMax = 10.0
        plotDataModel!.changingPlotParameters.xMin = 0.0
        plotDataModel!.changingPlotParameters.xLabel = xLabel
        plotDataModel!.changingPlotParameters.yLabel = yLabel
    
        
        if color == "Red"{
            plotDataModel!.changingPlotParameters.lineColor = Color.red
        }
        else{
            
            plotDataModel!.changingPlotParameters.lineColor = Color.blue
        }
        plotDataModel!.changingPlotParameters.title = title
        
        plotDataModel!.zeroData()
    }
    
    @MainActor func appendDataToPlot(plotData: [(x: Double, y: Double)]) {
        plotDataModel!.appendData(dataPoint: plotData)
    }
    
    func ploteToTheMinusX() async
    {
        
        //set the Plot Parameters
        
        await setThePlotParameters(color: "Blue", xLabel: "log(n-value)", yLabel: "y = log(error)", title: "error chart")
        
        await resetCalculatedTextOnMainThread()
        
        theText = "y = exp(-x)\n"
        
        var plotData :[(x: Double, y: Double)] =  []
         
         /*
        for i in 0 ..< 9 {

            //create x values here
            let x = log(totalGuesses)

        //create y values here
            let y = exp(-x)
            
            let dataPoint: (x: Double, y: Double) = (x: x, y: y)
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(x), y = \(y)\n"
        }
         */
       /*
        var values = [10.0, 20.0, 50.0, 100.0, 200.0, 500.0, 1000.0, 10000.0, 50000.0]
        for value in values {
            Nstring = String(value)
            myorbitalcalcinstance.monteCarloIntegration()
            let x = log(value)
            
            let y = logerror
            
            let dataPoint: (x: Double, y: Double) = (x: x, y: y)
            plotData.append(contentsOf: [dataPoint])
            theText += "x = \(x), y = \(y)\n"
            
        }
        */
        
        await appendDataToPlot(plotData: plotData)
        await updateCalculatedTextOnMainThread(theText: theText)
        
        return
        
    }
    
    
        @MainActor func resetCalculatedTextOnMainThread() {
            //Print Header
            plotDataModel!.calculatedText = ""
    
        }
    
    
        @MainActor func updateCalculatedTextOnMainThread(theText: String) {
            //Print Header
            plotDataModel!.calculatedText += theText
        }
    
}
