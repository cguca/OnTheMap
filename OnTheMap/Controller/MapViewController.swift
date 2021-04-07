//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/2/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
//        OnTheMapClient.getStudentLocations(completion: handleStudentLocations(locations:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        OnTheMapClient.getStudentLocations(completion: handleStudentLocations(locations:error:))
    }
    
    func handleStudentLocations(locations:[StudentLocation], error: Error?) {
        
        var annotations = [MKPointAnnotation]()
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        OnTheMapClient.deleteSession { (sucess, error) in
            if sucess {
                print("Logging out is sucessful")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("MapViewController:logoutPressed: Error \(String(describing: error))")
            }
        }
    }
    @IBAction func refreshPressed(_ sender: Any) {
        OnTheMapClient.getStudentLocations(completion: handleStudentLocations(locations:error:))
    }
    
    @IBAction func dropPinPressed(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingViewController") as! InformationPostingViewController
        let backItem = UIBarButtonItem()
           backItem.title = "CANCEL"
        
           navigationItem.backBarButtonItem = backItem
        self.navigationController!.pushViewController(controller, animated: true)
//        performSegue(withIdentifier: "dropPinSegue", sender: nil)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let canOpen = app.canOpenURL(URL(string: toOpen)!)
                if canOpen {
                    app.open(URL(string: toOpen)!)
                } else {
                    showInvalidUrlAlert(message: "Invalid URL provide by usser.")
                }
            }
        }
    }
    
    func showInvalidUrlAlert(message: String) {
        //let message = "Please enter a location"
        let alertVC = UIAlertController(title: "Invaild URL", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        return
        
//        let alertVC = UIAlertController(title: "Invalid URL", message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        show(alertVC, sender: nil)
    }
}
