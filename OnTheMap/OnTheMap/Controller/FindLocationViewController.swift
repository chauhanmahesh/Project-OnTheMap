//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 1/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findingLocation: UIButton!
    
    var placeMarkFound: CLPlacemark!
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        // Let's guard for the information entered.
        if locationField.text?.isEmpty == true || linkField.text?.isEmpty == true {
            showError(title: "Can't find Location", message: "Please enter both location and link before searching.") {}
            return;
        }
        setFindingLocation(true)
        searchLocation(address: locationField.text ?? "", linkToPost: linkField.text ?? "")
    }
    
    func searchLocation(address: String, linkToPost: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            if (error != nil) {
                self.showError(title: "Can't find Location", message: "Not able to find this location. Please try again.") {
                    self.setFindingLocation(false)
                }
                return
            }
            
            if let placemark = placemarks?[0]  {
                self.setFindingLocation(false)
                self.placeMarkFound = placemark
                self.performSegue(withIdentifier: "postLocation", sender: nil)
            } else {
                self.showError(title: "Can't find Location", message: "Not able to find this location. Please try again.") {
                    self.setFindingLocation(false)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postLocation" {
            let postLocationViewController = segue.destination as! PostLocationViewController
            
            let lat = placeMarkFound.location?.coordinate.latitude ?? 0.0
            let lon = placeMarkFound.location?.coordinate.longitude ?? 0.0
            let studentLocationToPost = StudentLocation(firstName: UdacityAPIClient.Auth.firstName, lastName: UdacityAPIClient.Auth.lastName, longitude: lon, latitude: lat, mapString: placeMarkFound.name ?? "", mediaURL: linkField.text!, uniqueKey: UdacityAPIClient.Auth.key)
            postLocationViewController.studentLocationToPost = studentLocationToPost
        }
    }
    
    func setFindingLocation(_ finding: Bool) {
        if finding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        findingLocation.isEnabled = !finding
    }
    
}
