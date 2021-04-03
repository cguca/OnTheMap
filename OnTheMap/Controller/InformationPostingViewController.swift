//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/2/21.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        guard !(locationTextField?.text?.isEmpty)! else {
            let message = "Please enter a location"
            let alertVC = UIAlertController(title: "Location Error", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        guard !(linkTextField?.text?.isEmpty)! else {
            let message = "Please enter a link"
            let alertVC = UIAlertController(title: "Link Error", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        
        let location = locationTextField.text!
        getCoordinate(addressString: location) { (coordinate, error) in
            if error != nil {
                let message = "Location cannot be geo coded"
                let alertVC = UIAlertController(title: "Location Error", message: message, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
           
            let controller: AddLocationMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController

            controller.location = coordinate
            controller.urlMessage = self.linkTextField.text!
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    func showLoginFailure(message: String) {
        
    }
   
}

extension InformationPostingViewController: UITextFieldDelegate {
    
}
