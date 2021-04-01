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
    
    @IBAction func loginPressed(_ sender: Any) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
}
