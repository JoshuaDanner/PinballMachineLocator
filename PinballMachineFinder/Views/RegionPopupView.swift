//
//  RegionPopupView.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 8/8/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit

class RegionPopupView: UIView {

    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.purple
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createRectangle() {
        
        // Initialize the path.
        path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 10.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        
        // Create the bottom line (bottom-left to bottom-right).
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        // Create the vertical line from the bottom-right to the top-right side.
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 10.0))
        
        // First addition for the point
        path.addLine(to: CGPoint(x: self.frame.size.width/2 + 8, y: 10.0))
        
        // Second addition for the point
        path.addLine(to: CGPoint(x: self.frame.size.width/2, y: 0.0))
        
        // Third addition for the point
        path.addLine(to: CGPoint(x: self.frame.size.width/2 - 8, y: 10.0))
        
        
        // Close the path. This will create the last line automatically.
        path.close()
    }
    override func draw(_ rect: CGRect) {
        self.createRectangle()
        
        // Specify the fill color and apply it to the path.
       
        UIColor.green.setFill()
        
        path.fill()
        
        // Specify a border (stroke) color.
        UIColor.lightGray.setStroke()
        path.stroke()
    }

}
