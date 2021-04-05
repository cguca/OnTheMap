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
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showLoginFailure(message: "Please enter an email address")
            return
        }
        
        guard let pword = passwordTextField.text, !pword.isEmpty else {
            showLoginFailure(message: "Please enter a password")
            return
        }
                
        OnTheMapClient.login(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
            if success! {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
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
