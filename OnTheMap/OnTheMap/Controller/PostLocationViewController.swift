//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 2/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var postLocation: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var studentLocationToPost: StudentLocation!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLocationPin()
    }
    
    @IBAction func postLocationTapped(_ sender: Any) {
        // Let's see if we need to post the location or update the existing one.
        if let postedLocationObjectId = ParseAPIClient.PostedLocation.postedLocationObjectId {
            ParseAPIClient.updateStudentLocation(objectId: postedLocationObjectId, studentLocation: studentLocationToPost, completion: handlePostLocationResponse(success:error:))
        } else {
            ParseAPIClient.postStudentLocation(studentLocation: studentLocationToPost, completion: handlePostLocationResponse(success:error:))
        }
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?) {
        if success {
            // Successfully posted the location. let's close the view.
            self.dismiss(animated: true, completion: nil)
        } else {
            showErrorMessage(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLocationPin() {
        // let's create the annotations.
        var annotations = [MKPointAnnotation]()
        let lat = CLLocationDegrees(studentLocationToPost.latitude)
        let long = CLLocationDegrees(studentLocationToPost.longitude)

        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        let firstName = studentLocationToPost.firstName
        let lastName = studentLocationToPost.lastName

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = studentLocationToPost.mediaURL
        annotations.append(annotation)

        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen) {
                    app.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func setPostingLocation(_ posting: Bool) {
        if posting {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        postLocation.isEnabled = !posting
    }
    
    func showErrorMessage(message: String) {
        let alertVC = UIAlertController(title: "Can't post Location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.setPostingLocation(false)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
