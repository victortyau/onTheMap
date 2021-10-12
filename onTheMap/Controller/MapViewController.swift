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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchStudentsPins()
    }
    
    func fetchStudentsPins() {
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
            }
        }
    }
    
    
    
}
