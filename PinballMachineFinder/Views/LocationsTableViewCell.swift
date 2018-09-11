//
//  LocationsTableViewCell.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 7/30/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    
    var location: Location? {
        didSet {
            updateViews()
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: IBOutlets
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    @IBOutlet weak var locationCity: UILabel!
    @IBOutlet weak var locationState: UILabel!
    @IBOutlet weak var locationDistance: UILabel!
    @IBOutlet weak var totalMachineAtLocation: UILabel!
    @IBOutlet weak var pinView: UIView!

    func pinViewProperties() {

    }
    
    func updateViews() {
//        DispatchQueue.main.async {
//            self.pinViewProperties()
//        }
        guard let location = location else { return }
        self.locationName.text = location.locationName
        self.locationAddress.text = location.street
        self.locationCity.text = location.city
        self.locationState.text = location.state
    }
}

class PinView: UIView {
    
    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.purple
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.width/2),
                            radius: self.frame.size.height/2,
                            startAngle: CGFloat(180.0),
                            endAngle: CGFloat(0.0),
                            clockwise: false)
    }
}
