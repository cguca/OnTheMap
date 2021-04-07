//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/2/21.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocationCoordinate2D? = nil
    var locationText: String = ""
    var urlMessage: String = ""
    let latitudeDelta = 0.05
    let longitudeDelta = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: location!, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location!
        annotation.title = locationText
        
        DispatchQueue.main.async {
            self.mapView.region = region
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func finishPressed(_ sender: Any) {
        
        let result = OnTheMapClient.getCurrentUserName()
        let studentLocation = StudentLocationData()
        studentLocation.nickname = result.2
        studentLocation.firstName = result.0
        studentLocation.lastName = result.1
        studentLocation.latitude = Float(location!.latitude)
        studentLocation.longitude = Float(location!.longitude)
        studentLocation.mapString = locationText
        studentLocation.mediaURL = urlMessage
        
        OnTheMapClient.postUserLocation(location: studentLocation) { (success, error) in
            print("DID it succeed? \(success)")

        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension AddLocationMapViewController: MKMapViewDelegate {
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
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
