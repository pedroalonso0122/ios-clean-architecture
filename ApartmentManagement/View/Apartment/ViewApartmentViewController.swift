//
//  ViewApartmentViewController.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/9/1.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit

class ViewApartmentViewController: UIViewController, Alertable {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var numberRoomField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var rentStatusLabel: UILabel!
    @IBOutlet weak var realtorLabel: UILabel!
    
    var apartment: Apartment!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameField.text = apartment.name
        descriptionView.text = apartment.description
        sizeField.text = String(apartment.floorAreaSize)
        priceField.text = String(apartment.price)
        numberRoomField.text = String(apartment.numberOfRooms)
        addressField.text = apartment.address
        if apartment.status == RentStatus.available.rawValue {
            rentStatusLabel.text = "Available"
        } else {
            rentStatusLabel.text = "Rented"
        }
        realtorLabel.text = apartment.realtorName
        
        let placeholderImage = UIImage(named: "NoImage")!
        guard let fileName = apartment.image else {
            imageView.image = placeholderImage
            return
        }
        let url = URL(string: APIEndpoint.imageURL + fileName)!
        imageView.af.setImage(withURL: url, placeholderImage: placeholderImage)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backTapped(_ sender: Any) {
        // Back Action
        navigationController?.popViewController(animated: true)
    }
}
