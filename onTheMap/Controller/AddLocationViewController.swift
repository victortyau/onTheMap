//
//  AddLocationViewController.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/12/21.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var lookLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let newLocation = locationTextField.text
        
        if UIApplication.shared.canOpenURL(URL(string: websiteTextField.text!)!) {
            print("error with url")
            return
        }
        setGeocodePosition(newLocation: newLocation ?? "")
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
    }
    
    func setGeocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { newMarker, error in
            if let error = error {
                print(error.localizedDescription)
                print("error")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadLocation(location.coordinate)
                } else {
                    print("error")
                }
            }
        }
    }
    
    func loadLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FindLocationViewController") as! FindLocationViewController
        // controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
