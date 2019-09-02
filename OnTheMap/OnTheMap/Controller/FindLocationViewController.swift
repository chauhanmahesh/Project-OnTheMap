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
    
    var placeMarkFound: CLPlacemark!
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        // Let's guard for the information entered.
        
        guard let location = locationField.text else {
            showErrorMessage(message: "Type location before searching.")
            return
        }

        guard let link = linkField.text else {
            showErrorMessage(message: "Type link before searching.")
            return
        }

        searchLocation(address: location, linkToPost: link)
    }
    
    func searchLocation(address: String, linkToPost: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            if (error != nil) {
                self.showErrorMessage(message: "Not able to find this location. Please try again.")
                return
            }
            
            if let placemark = placemarks?[0]  {
                self.placeMarkFound = placemark
                self.performSegue(withIdentifier: "postLocation", sender: nil)
            } else {
                self.showErrorMessage(message: "Not able to find this location. Please try again.")
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
    
    func showErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Can't find Location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
