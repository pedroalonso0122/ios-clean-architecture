//
//  ViewController.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/27.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, Alertable {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bind View Model
        bind()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

 
        // Dismiss keyboard when tap view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        let type = AuthManager.shared.getType()
        let email = AuthManager.shared.getEmail()
        let password = AuthManager.shared.getPassword()

        // Auto Login if saved credential
        switch type {
        case LoginType.email.rawValue:
            if !email.isEmpty && !password.isEmpty {
                emailTextField.text = email
                passwordTextField.text = password
                login()
            }
            break
        case LoginType.google.rawValue:
//            GIDSignIn.sharedInstance()?.signInSilently()
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            break
        case LoginType.facebook.rawValue:
            guard let token = AccessToken.current else {
                break
            };
            self.viewModel.socialLogin(provider: LoginType.facebook.rawValue, token: token.tokenString)
            break
        default:
            break
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSelectRole" {
            if let destinationVC = segue.destination as? SelectRoleViewController {
                destinationVC.user = AuthManager.shared.userInfo
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Called when login button is tapped
        login()
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        LoginManager.init().logIn(permissions: [Permission.publicProfile, Permission.email], viewController: self) { (loginResult) in
            switch loginResult {
                case .success(_, _, let token):
                    self.viewModel.socialLogin(provider: LoginType.facebook.rawValue, token: token.tokenString)
                case .cancelled:
                    self.showAlert(message: "Login: cancelled")
                case .failed(let error):
                    self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func login() {
        // Login action
        // Validate if email and password is not empty
        // Call login api
        guard let email = self.emailTextField.text else {
            showAlert(message: "The email field is required")
            return
        }
        
        guard let password = self.passwordTextField.text else {
            showAlert(message: "The password field is required")
            return
        }
        
        self.viewModel.login(email: email, password: password)
    }
    
    @objc func dismissKeyboard() {
       //Causes the view (or one of its embedded text fields) to resign the first responder status.
       view.endEditing(true)
   }
}

// MARK: - UITextField Deleage

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - Google Sign

extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                showAlert(message: "The user has not signed in before or they have since signed out.")
            } else {
                showAlert(message: error.localizedDescription)
            }
            return
        }
        
        guard let token = user.authentication.accessToken else { return };
        NSLog(token)
        viewModel.socialLogin(provider: LoginType.google.rawValue, token: token)
    }
}

// MARK: - Facebook Sign

extension LoginViewController {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            showAlert(message: error.localizedDescription)
            return
        }
        
        guard let token = result?.token?.tokenString else { return };
        
        viewModel.socialLogin(provider: LoginType.facebook.rawValue, token: token)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}

// MARK: - ViewModel

extension LoginViewController {
    private func bind() {
        viewModel = AuthViewModel()
        
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
            
            if role == Role.admin.rawValue || role == Role.client.rawValue || role == Role.realtor.rawValue {
                // Admin/User can add/edit/list/view apartment
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchToApartment()
            } else {
                self.performSegue(withIdentifier: "showSelectRole", sender: self)
            }
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
