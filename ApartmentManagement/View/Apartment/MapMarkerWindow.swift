//
//  MapMarkerWindow.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/10/30.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit

class MapMarkerWindow: UIView {

    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var apartment: Apartment!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> UIView {
            return UINib(nibName: "MapMarkerWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        }

}
