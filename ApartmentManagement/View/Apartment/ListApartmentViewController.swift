//
//  ListApartmentViewController.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/30.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMaps
import GooglePlaces

protocol FilterChangeProtocol: class {
    func onFilterChanged(filter: Filter)
}

class ListApartmentViewController: UIViewController, Alertable {

    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var mapView: GMSMapView!
    
    private var viewModel: ApartmentViewModel!
    private var apartments: [Apartment] = [Apartment]()
    
    @IBOutlet weak var switchButton: UIButton!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var priceFilterBtn: UIButton!
    @IBOutlet weak var areaSizeFilterBtn: UIButton!
    @IBOutlet weak var numberRoomFilterBtn: UIButton!

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var infoWindow = MapMarkerWindow()
    
    private var selectedApartment: Apartment?
    
    var filter: Filter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
        
        if AuthManager.shared.userInfo?.role == Role.admin.rawValue || AuthManager.shared.userInfo?.role == Role.realtor.rawValue {
            addButton.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.infoWindow = loadMarkerWindow()
        
        filter = Filter(minPrice: "", maxPrice: "", priceText: "Any", minAreaSize: "", maxAreaSize: "", areaSizeText: "Any", minNumberRooms: "", maxNumberRooms: "", numberRoomText: "Any")
        
        mapView.delegate = self
        
        // Hide clear button
//        if let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField {
//            searchTextField.clearButtonMode = .never
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh() {
        // Refresh UI
        hideMarkerWindow()
        
        // Called when view appear/filter condition change
        self.viewModel.load(country: filter.country, locality: filter.locality, minPrice: filter.minPrice, maxPrice: filter.maxPrice, minAreaSize: filter.minAreaSize, maxAreaSize: filter.maxAreaSize, minNumberRooms: filter.minNumberRooms, maxNumberRooms: filter.maxNumberRooms)
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    func editApartment(apartment: Apartment) {
        selectedApartment = apartment
        self.performSegue(withIdentifier: "showApartmentEdit", sender: self)
    }
    
    func viewApartment(apartment: Apartment) {
        selectedApartment = apartment
        self.performSegue(withIdentifier: "showApartmentView", sender: self)
    }
    
    func deleteApartment(apartment: Apartment) {
        self.viewModel.delete(id: apartment.id)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showApartmentEdit" {
            if let destinationVC = segue.destination as? EditApartmentViewController {
                destinationVC.apartment = selectedApartment
            }
        }
        if segue.identifier == "showApartmentView" {
            if let destinationVC = segue.destination as? ViewApartmentViewController {
                destinationVC.apartment = selectedApartment
            }
        }
        
        if segue.identifier == "showFilter" {
            if let destinationVC = segue.destination as? FilterApartmentViewController {
                destinationVC.filter = filter
                destinationVC.delegate = self
            }
        }
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Menu, Add, Filter

    @IBAction func menuTapped(_ sender: Any) {
        // Show the menu
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showApartmentAdd", sender: self)
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showFilter", sender: self)

    }
    
    @IBAction func switchTapped(_ sender: Any) {
        if mapView.isHidden {
            mapView.isHidden = false
            tableView.isHidden = true
            switchButton.setTitle("List", for: .normal)
        } else {
            mapView.isHidden = true
            tableView.isHidden = false
            switchButton.setTitle("Map", for: .normal)
        }
    }
    
    // MARK: - Map Mark View Tapped
    
    @objc func tapMapMarkerWindow() {
        guard let role = AuthManager.shared.userInfo?.role else {
            showAlert(message: "No role of this user")
            return
        }
        guard let apartment = infoWindow.apartment else {
            return
        }
        
        if role == Role.admin.rawValue || role == Role.realtor.rawValue {
            self.editApartment(apartment: apartment)
        } else {
            self.viewApartment(apartment: apartment)
        }
    }
}

// MARK: - UITableView Delegate And Datasource Methods

extension ListApartmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apartments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: ApartmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ApartmentTableViewCell", for: indexPath as IndexPath) as? ApartmentTableViewCell else {
            fatalError("ApartmentTableViewCell cell is not found")
        }
        
        cell.apartmentItem = apartments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let role = AuthManager.shared.userInfo?.role else {
            showAlert(message: "No role of this user")
            return
        }
        
        if role == Role.admin.rawValue || role == Role.realtor.rawValue {
            self.editApartment(apartment: apartments[indexPath.row])
        } else {
            self.viewApartment(apartment: apartments[indexPath.row])
        }
    }
}

// MARK: - ViewModel

extension ListApartmentViewController {
    private func bind() {
        viewModel = ApartmentViewModel()
        
        viewModel.apartments.observe(on: self) { [weak self] in self?.updateApartment($0) }
        viewModel.state.observe(on: self) { [weak self] in self?.updateState($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.updateError($0) }
    }
    
    private func updateApartment(_ apartments: [Apartment]) {
        self.apartments = apartments
        self.tableView.reloadData()
        
        mapView.clear()
        for apartment in apartments {
            let position = CLLocationCoordinate2DMake(apartment.latitude, apartment.longitude)
            let marker = GMSMarker(position: position)
            marker.title = apartment.name
            marker.userData = apartment
            marker.map = mapView
        }
        
        if apartments.count > 0 {
            let camera = GMSCameraPosition.camera(withLatitude: apartments.first!.latitude, longitude: apartments.first!.longitude, zoom: 10.0)
            mapView.camera = camera
        }
    }
    
    private func updateState(_ state: ActionState?) {
        // Hide Indicator
        ProgressHUD.instance.dismiss()
        
        switch state {
        case .waiting:
            ProgressHUD.instance.show(parentView: self.view)
            break
        default:
            break
        }
    }
    
    private func updateError(_ message: String) {
        guard !message.isEmpty else { return }
        self.showError(message: message)
    }
}

// MARK: - ViewModel

extension ListApartmentViewController: FilterChangeProtocol {
    func onFilterChanged(filter: Filter) {
        self.filter = filter
        
        if self.filter.priceText.isEmpty || self.filter.priceText == "Any" {
            self.priceFilterBtn.setTitle("Any Price", for: .normal)
        } else {
            self.priceFilterBtn.setTitle(self.filter.priceText, for: .normal)
        }
        
        if self.filter.areaSizeText.isEmpty || self.filter.areaSizeText == "Any" {
            self.areaSizeFilterBtn.setTitle("Any Size", for: .normal)
        } else {
            self.areaSizeFilterBtn.setTitle(self.filter.areaSizeText, for: .normal)
        }
        
        if self.filter.numberRoomText.isEmpty || self.filter.numberRoomText == "Any" {
            self.numberRoomFilterBtn.setTitle("Any Rooms", for: .normal)
        } else {
            self.numberRoomFilterBtn.setTitle(self.filter.numberRoomText, for: .normal)
        }
        
        refresh()
    }
}

// MARK: - Map Delegate/Marker
extension ListApartmentViewController {
    
    func loadMarkerWindow() -> MapMarkerWindow {
        let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapMapMarkerWindow))
        infoWindow.addGestureRecognizer(tap)
        
        return infoWindow
    }
    
    func showMarkerWindow(apartment: Apartment) {
        infoWindow.apartment = apartment
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        let priceString = formatter.string(from: NSNumber(value: apartment.price))!
        let sizeString = formatter.string(from: NSNumber(value: apartment.floorAreaSize))!

        infoWindow.priceLabel.text = "US$" + priceString + "/mo"
        infoWindow.descriptionLabel.text = String(apartment.numberOfRooms) + " rooms | " + sizeString + " sqft"
        infoWindow.addressLabel.text = apartment.address
        
        let placeholderImage = UIImage(named: "NoImage")!
        
        guard let fileName = apartment.image else {
            infoWindow.photoView.image = placeholderImage
            return
        }
                        
        let url = URL(string: APIEndpoint.imageURL + fileName)!
        infoWindow.photoView.af.setImage(withURL: url, placeholderImage: placeholderImage)

        let frame = self.view.frame.size
        
        let width = frame.width - 20
        let height = width * 0.6 + 78
        
        let centerX = frame.width / 2
        
        infoWindow.frame = CGRect(x: centerX - width / 2, y: frame.height - height - 5, width: width, height: height)

        self.view.addSubview(infoWindow)
    }
    
    func hideMarkerWindow() {
        infoWindow.removeFromSuperview()
    }
}

extension ListApartmentViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        infoWindow.removeFromSuperview()
        infoWindow = loadMarkerWindow()
        
        guard let apartment = marker.userData as? Apartment else {
            return false
        }
        
        showMarkerWindow(apartment: apartment)
        
        return true // or false as needed.
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hideMarkerWindow()
    }
}

// MARK: - Search Delegate / Place Auto Complte

extension ListApartmentViewController {
    private func showAutoCompleteController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension ListApartmentViewController: UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showAutoCompleteController()
        return false
    }
    
  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    filter.country = place.addressComponents?.first(where: { $0.types.contains("country") })?.name ?? ""
    filter.locality = place.addressComponents?.first(where: { $0.types.contains("locality") })?.name ?? ""
    
    self.searchBar.text = filter.locality
    
    dismiss(animated: true, completion: nil)
    
    refresh()
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

}
