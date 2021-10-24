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
    var currentIndicator: UIActivityIndicatorView!
    
    var objectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        setupIndicator(currentIndicator: currentIndicator)
        locationTextField.text = "Obarrio, Panama, Panama"
        websiteTextField.text = "https://classic.yarnpkg.com/lang/en/"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hideActivityIndicator(currentIndicator: self.currentIndicator)
    }
    
    @IBAction func searchLocation(_ sender: UIButton) {
        displayActivityIndicator(currentIndicator: currentIndicator)
        let newLocation = locationTextField.text
        
        guard let url = URL(string: self.websiteTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.alertBox(title: "Invalid URL", message: "Please add a valid link")
            return
        }
        
        setGeocodePosition(newLocation: newLocation ?? "")
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setGeocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { newMarker, error in
            if let error = error {
                self.hideActivityIndicator(currentIndicator: self.currentIndicator)
                self.alertBox(title: "Location not found", message: error.localizedDescription)
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadLocation(location.coordinate)
                } else {
                    self.hideActivityIndicator(currentIndicator: self.currentIndicator)
                    self.alertBox(title: "Error", message: "Please try again")
                }
            }
        }
    }
    
    func loadLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "FindLocationController") as! FindLocationViewController
        controller.studentInformation = createStudentInfo(coordinate)
        self.navigationController!.pushViewController(controller, animated: true)
        self.hideActivityIndicator(currentIndicator: self.currentIndicator)
    }
    
    func createStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        let first_name = ["Danyaal", "Shreya", "Luca", "Alessio", "Mirza", "Faraz", "Samanta", "Hettie", "Shaan", "Waleed"]
        let last_name = ["Cousins", "Mcgill", "Beck", "Wheeler", "Wagner", "Doyle", "Mcgowan", "Matthews", "Burn", "Beltran"]
        
        var studentData = [
            "uniqueKey": ServiceClient.Auth.key,
            "firstName": first_name.randomElement() as Any,
            "lastName": last_name.randomElement() as Any,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentData["objectId"] = objectId as AnyObject
        }
        
        return StudentInformation(studentData)
    }
}
