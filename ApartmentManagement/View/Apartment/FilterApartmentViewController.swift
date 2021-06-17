//
//  FilterApartmentViewController.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/10/29.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import MultiSlider

class FilterApartmentViewController: UIViewController {

    @IBOutlet weak var areaSizeLabel: UILabel!
    @IBOutlet weak var sizeSlider: MultiSlider!
    
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var roomSlider: MultiSlider!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSlider: MultiSlider!
    
    var filter: Filter!
    
    weak var delegate: FilterChangeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        priceSlider.minimumValue = 0
        priceSlider.maximumValue = CGFloat(FILTER_PRICE_MAX)
        priceSlider.snapStepSize = 250
        
        let minPrice = Float(filter.minPrice) ?? 0
        let maxPrice = Float(filter.maxPrice) ?? Float(FILTER_PRICE_MAX)
        priceSlider.value = [CGFloat(minPrice), CGFloat(maxPrice)]

        roomSlider.minimumValue = 0
        roomSlider.maximumValue = 5
        roomSlider.snapStepSize = 1
        
        let minNumberRooms = Float(filter.minNumberRooms) ?? 0
        let maxNumberRooms = Float(filter.maxNumberRooms) ?? Float(FILTER_NUMBER_OM_ROOMS_MAX)
        roomSlider.value = [CGFloat(minNumberRooms), CGFloat(maxNumberRooms)]
        
        sizeSlider.minimumValue = 0
        sizeSlider.maximumValue = 7500
        sizeSlider.snapStepSize = 250
        let minAreaSize = Float(filter.minAreaSize) ?? 0
        let maxAreaSize = Float(filter.maxAreaSize) ?? Float(FILTER_FLOOR_AREA_SIZE_MAX)
        sizeSlider.value = [CGFloat(minAreaSize), CGFloat(maxAreaSize)]
        
        priceLabel.text = filter.priceText.isEmpty ? "Any" : filter.priceText
        roomsLabel.text = filter.numberRoomText.isEmpty ? "Any" : filter.numberRoomText
        areaSizeLabel.text = filter.areaSizeText.isEmpty ? "Any" : filter.areaSizeText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sizeChanged(_ sender: Any) {
        let min = Int(sizeSlider.value[0])
        let max = Int(sizeSlider.value[1])
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if max == FILTER_FLOOR_AREA_SIZE_MAX && min == 0 {
            filter.areaSizeText = "Any"
            filter.minAreaSize = ""
            filter.maxAreaSize = ""
        } else if min == 0 {
            filter.areaSizeText = String(format: "No Min-%@ sqft", formatter.string(from: NSNumber(value: Double(max)))!)
            filter.minAreaSize = ""
            filter.maxAreaSize = String(max)
        } else if max == FILTER_FLOOR_AREA_SIZE_MAX {
            filter.areaSizeText = String(format: "%@+ sqft", formatter.string(from: NSNumber(value: Double(min)))!)
            filter.minAreaSize = String(min)
            filter.maxAreaSize = ""
        } else {
            filter.areaSizeText = String(format: "%@-%@ sqft", formatter.string(from: NSNumber(value: Double(min)))!, formatter.string(from: NSNumber(value: Double(max)))!)
            filter.minAreaSize = String(min)
            filter.maxAreaSize = String(max)
        }
        areaSizeLabel.text = filter.areaSizeText
    }
    
    
    @IBAction func numberOfRoomsChanged(_ sender: Any) {
        let min = Int(roomSlider.value[0])
        let max = Int(roomSlider.value[1])
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if max == FILTER_NUMBER_OM_ROOMS_MAX && min == 0 {
            filter.numberRoomText = "Any"
            filter.minNumberRooms = ""
            filter.maxNumberRooms = ""
        } else if min == 0 {
            filter.numberRoomText = String(format: "No Min-%@ rooms", formatter.string(from: NSNumber(value: Double(max)))!)
            filter.minNumberRooms = ""
            filter.maxNumberRooms = String(max)
        } else if max == FILTER_NUMBER_OM_ROOMS_MAX {
            filter.numberRoomText = String(format: "%@+ rooms", formatter.string(from: NSNumber(value: Double(min)))!)
            filter.minNumberRooms = String(min)
            filter.maxNumberRooms = ""
        } else {
            filter.numberRoomText = String(format: "%@-%@ rooms", formatter.string(from: NSNumber(value: Double(min)))!, formatter.string(from: NSNumber(value: Double(max)))!)
            filter.minNumberRooms = String(min)
            filter.maxNumberRooms = String(max)
        }
        roomsLabel.text = filter.numberRoomText        
    }
    
    @IBAction func priceChanged(_ sender: Any) {
        let min = Int(priceSlider.value[0])
        let max = Int(priceSlider.value[1])
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if max == FILTER_PRICE_MAX && min == 0 {
            filter.priceText = "Any"
            filter.minPrice = ""
            filter.maxPrice = ""
        } else if min == 0 {
            filter.priceText = String(format: "No Min-$%@", formatter.string(from: NSNumber(value: Double(max)))!)
            filter.minPrice = ""
            filter.maxPrice = String(max)
        } else if max == FILTER_PRICE_MAX {
            filter.priceText = String(format: "$%@+", formatter.string(from: NSNumber(value: Double(min)))!)
            filter.minPrice = String(min)
            filter.maxPrice = ""
        } else {
            filter.priceText = String(format: "$%@-$%@", formatter.string(from: NSNumber(value: Double(min)))!, formatter.string(from: NSNumber(value: Double(max)))!)
            filter.minPrice = String(min)
            filter.maxPrice = String(max)
        }
        priceLabel.text = filter.priceText
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        delegate?.onFilterChanged(filter: filter)
        
        navigationController?.popViewController(animated: true)
    }
}
