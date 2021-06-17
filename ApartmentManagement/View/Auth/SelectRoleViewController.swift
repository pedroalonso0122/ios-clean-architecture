//
//  SelectRoleViewController.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/10/28.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit

class SelectRoleViewController: UIViewController, Alertable {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    
    var user: User!
    
    private var rolePicker = UIPickerView()
    
    private var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind View Model
        bind()
        
        self.emailTextField.text = user.email
        self.nameTextField.text = user.name
        
        // Dismiss keyboard when tap view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Role Picker
        let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(self.dismissKeyboard))
        roleTextField.inputAccessoryView = toolBar
        
        rolePicker.dataSource = self
        rolePicker.delegate = self
        roleTextField.inputView = rolePicker
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        // Regiser action
        // Validate if email and password is not empty
        // Call register api
        
        guard let role = self.roleTextField.text else {
            showAlert(message: "The role field is required")
            return
        }
        
        ProgressHUD.instance.show(parentView: self.view)
        
        self.viewModel.update(id: user.id, email: user.email, name: user.name ?? "", password: "", role: role)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

// MARK: - UITextField Delegate

extension SelectRoleViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - UIPicker Delegate And Datasource Methods

extension SelectRoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Role.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Role.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        roleTextField.text = Role.allCases[row].rawValue
    }
}

// MARK: - ViewModel

extension SelectRoleViewController {
    private func bind() {
        viewModel = ProfileViewModel()
        
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
            // Check User Role
            guard let role = AuthManager.shared.userInfo?.role else {
                showAlert(message: "No role of this user")
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToApartment()
            
            break
        case .fail:
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
