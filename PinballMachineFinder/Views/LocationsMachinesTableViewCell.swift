//
//  LocationsMachinesTableViewCell.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 9/11/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit

class LocationsMachinesTableViewCell: UITableViewCell {
    
    var machine: Machine? {
        didSet {
            updateViews()
        }
    }

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var machineName: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var linkURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        
        guard let machine = machine else { return }
        guard let manufacturer = machine.manufacturer else { return }
        guard let year = machine.year else { return }
        guard let ipdbLink = machine.IPDBLink else { return }
        
        
        self.machineName.text = machine.name
        self.manufacturer.text = "Manufacturer: \(manufacturer)"
        self.year.text = ("Made: \(String(describing: year))")
        self.linkURL.text = "IPDB Link: \(ipdbLink)"
        
     }
    
    @IBAction func ipdbLinkButtonSlammed(_ sender: Any) {
        guard let url = machine?.IPDBLink else { return }
        UIApplication.shared.open(URL(string: url)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
