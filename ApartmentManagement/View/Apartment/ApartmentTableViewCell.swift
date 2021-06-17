//
//  ApartmentTableViewCell.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/31.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ApartmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoVoew: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var apartmentItem: Apartment? {
        didSet {
            if let apartment = apartmentItem {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                
                let priceString = formatter.string(from: NSNumber(value: apartment.price))!
                let sizeString = formatter.string(from: NSNumber(value: apartment.floorAreaSize))!

                self.priceLabel.text = "US$" + priceString + "/mo"
                self.descriptionLabel.text = String(apartment.numberOfRooms) + " rooms | " + sizeString + " sqft"
                self.addressLabel.text = apartment.address
                
                let placeholderImage = UIImage(named: "NoImage")!
                
                guard let fileName = apartment.image else {
                    self.photoVoew.image = placeholderImage
                    return
                }
                                
                let url = URL(string: APIEndpoint.imageURL + fileName)!
                self.photoVoew.af.setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
