//
//  EditApartmentViewController.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/9/1.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import GooglePlaces

class EditApartmentViewController: UIViewController, Alertable, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField:UITextField?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var numberRoomField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var statusSwitch: UISwitch!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    private var viewModel: ApartmentViewModel!
    
    var apartment: Apartment!
    
    private var country: String!
    private var locality: String!
    private var latitude: Double = 0
    private var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bind View Model
        bind()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set value of apartment
        country = apartment.country
        locality = apartment.locality
        latitude = apartment.latitude
        longitude = apartment.longitude
        
        nameField.text = apartment.name
        descriptionView.text = apartment.description
        sizeField.text = String(apartment.floorAreaSize)
        priceField.text = String(apartment.price)
        numberRoomField.text = String(apartment.numberOfRooms)
        addressField.text = apartment.address
        
        if apartment.status == RentStatus.available.rawValue {
            statusSwitch.isOn = true
        } else {
            statusSwitch.isOn = false
        }
        
        let placeholderImage = UIImage(named: "NoImage")!
        guard let fileName = apartment.image else {
            imageView.image = placeholderImage
            return
        }
        let url = URL(string: APIEndpoint.imageURL + fileName)!
        imageView.af.setImage(withURL: url, placeholderImage: placeholderImage)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // Photo Tap
        let photoTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.takePhoto))
        imageView.addGestureRecognizer(photoTap)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveTapped(_ sender: Any) {
        // Regiser action
        // Call register api
        guard let name = self.nameField.text, !name.isEmpty else {
            showAlert(message: "The title field is required")
            return
        }
        
        guard let description = self.descriptionView.text, !description.isEmpty else {
            showAlert(message: "The description field is required")
            return
        }
                
        guard let size = Int(self.sizeField.text ?? "") else {
            showAlert(message: "The floor area size field is required")
            return
        }
        
        guard let price = Int(self.priceField.text ?? "") else {
            showAlert(message: "The price per month field is required")
            return
        }
        
        guard let numberOfRooms = Int(self.numberRoomField.text ?? "") else {
            showAlert(message: "The number of rooms field is required")
            return
        }
        
        guard let address = self.addressField.text, !address.isEmpty else {
            showAlert(message: "The address field is required")
            return
        }
        
        guard let imageData = imageView.image?.pngData() else {
            showAlert(message: "The photo field is required")
            return
        }
        
        let status = statusSwitch.isOn ? RentStatus.available : RentStatus.rented
        
        self.viewModel.update(id: apartment.id, realtorId: apartment.realtorId, name: name, description: description, floorAreaSize: size, price: price, numberOfRooms: numberOfRooms, country: country, locality: locality, address: address, latitude: latitude, longitude: longitude, image: imageData, status: status.rawValue)
    }
        
    @IBAction func deleteTapped(_ sender: Any) {
        self.viewModel.delete(id: apartment.id)
    }
    
    // MARK: Image Pick Management
    @objc func takePhoto() {
        let alert:UIAlertController = UIAlertController(title: "Choose Image",
                                                        message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        let picker = UIImagePickerController()
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
        else {
            self.openGallery()
        }
    }
    
    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
}

// MARK: - UITextField Deleage

extension EditApartmentViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressField {
            self.dismissKeyboard()
            showAutoCompleteController()
            return false
        }
        activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - Keyboard

extension EditApartmentViewController {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets : UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
}

// MARK: - UIImagePickerControllerDelegate Deleage

extension EditApartmentViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        imageView.image = image
    }
}

// MARK: - ViewModel

extension EditApartmentViewController {
    private func bind() {
        viewModel = ApartmentViewModel()
        
        viewModel.state.observe(on: self) { [weak self] in self?.updateState($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.updateError($0) }
    }
    
    private func updateState(_ state: ActionState?) {
        // Hide Indicator
        ProgressHUD.instance.dismiss()
        
        switch state {
        case .waiting:
            ProgressHUD.instance.show(parentView: self.view)
            break
        case .success:
            // Hide Indicator
            navigationController?.popViewController(animated: true)
            break
        case .uploadSuccess:
            break;
        default:
            break
        }
    }
    
    private func updateError(_ message: String) {
        guard !message.isEmpty else { return }
        self.showError(message: message)
    }
}

extension EditApartmentViewController {
    private func showAutoCompleteController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
}
extension EditApartmentViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    latitude = place.coordinate.latitude
    longitude = place.coordinate.longitude
    
    country = place.addressComponents?.first(where: { $0.types.contains("country") })?.name ?? ""
    locality = place.addressComponents?.first(where: { $0.types.contains("locality") })?.name ?? ""
    
    addressField.text = place.formattedAddress
    
    dismiss(animated: true, completion: nil)
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
