//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let signUpURL = "https://auth.udacity.com/sign-up"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
     }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showLoginFailure(message: "Please enter an email address")
            return
        }
        
        guard let pword = passwordTextField.text, !pword.isEmpty else {
            showLoginFailure(message: "Please enter a password")
            return
        }
                
        OnTheMapClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:)
        )
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OnTheMapClient.getUserData(completion: handleUserDataResponse(name:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleUserDataResponse(name: String?, error: Error?) {
        if let _ = name {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: signUpURL)!)
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
