//
//  MapViewController.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/11/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    var currentIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        setupIndicator(currentIndicator: currentIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchStudentsPins()
    }
    
    @IBAction func logout(_ sender: Any) {
        displayActivityIndicator(currentIndicator: currentIndicator)
        ServiceClient.classicLogout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator(currentIndicator: self.currentIndicator)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        fetchStudentsPins()
    }
  
    func fetchStudentsPins() {
        displayActivityIndicator(currentIndicator: currentIndicator)
        ServiceClient.fetchStudentLocations() {
            locations, error in
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.locations = locations ?? []
            for location in locations ?? [] {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude ?? 0.0), longitude: CLLocationDegrees(location.longitude ?? 0.0))
                let first_name = location.firstName
                let last_name = location.lastName
                let media_url = location.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title =  first_name+" "+last_name
                annotation.subtitle = media_url
                self.annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.hideActivityIndicator(currentIndicator: self.currentIndicator)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openLink(toOpen)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        openLink((view.annotation?.subtitle ?? "") ?? "")
    }
}
