//
//  BoundingBoxParameters.swift
//  Sphere2Project
//
//  Created by IIT PHYS 440 on 1/17/23.
//

import SwiftUI
/// <#Description#>
class BoundingBoxParameters: NSObject {
    @ObservedObject var myholdvariableinstance = HoldVariable()
    
    var boxradius = ""
    var ylength = 0.0
    var xlength = 0.0
    var zlength = 0.0
    
    var xmin = ""
    var xmax = ""
    var ymin = ""
    var ymax = ""
    var zmax = ""
    var zmin = ""

    
    
    
    //rewrite this code to calculate two separate lengths for a rectangular prism
    
    /* Doubles the input radius, to be the diameter (length) of the cube. The equation of the surface area of the cube is just
     2
     A = 6 * L^
     
     */
    /// Calculates the surface area of the bounding box of a sphere of radius X
    /// - Returns: Returns the Bounding Box surface Area given the input of box radius
    ///
    ///
    ///
    ///
    ///
    func calculateBoundingBoxArea() {
        xmin = myholdvariableinstance.xminstring
        xmax = myholdvariableinstance.xmaxstring
        ymin = myholdvariableinstance.yminstring
        ymax = myholdvariableinstance.ymaxstring
        zmin = myholdvariableinstance.zminstring
        zmax = myholdvariableinstance.zmaxstring
        
        zlength = Double(zmax)! - Double(zmin)!
        ylength = Double(ymax)! - Double(ymin)!
        xlength = Double(xmax)! - Double(xmin)!
        
        
    }
    
    
} 
