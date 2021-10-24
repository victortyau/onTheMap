//
//  FindLocationViewController.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/12/21.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocationButton: UIButton!
    var currentIndicator: UIActivityIndicatorView!
    
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        setupIndicator(currentIndicator: currentIndicator)
        
        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            displayLocation(location: studentLocation)
        }
    }
    
    func displayLocation(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    @IBAction func addLocation(_ sender: Any) {
        displayActivityIndicator(currentIndicator: currentIndicator)
        if let studentLocation = studentInformation {
            if ServiceClient.Auth.objectId == "" {
                ServiceClient.addLocation(studentInformation: studentLocation){
                    success, error in
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            self.hideActivityIndicator(currentIndicator: self.currentIndicator)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.hideActivityIndicator(currentIndicator: self.currentIndicator)
                            self.alertBox(title: "Error", message: error?.localizedDescription ?? "")
                            
                        }
                    }
                }
            }
        }
    }
}
