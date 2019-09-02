//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 1/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        fetchStudentLocations() {
            print("Successfully refreshed locations.")
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseAPIClient.CachedLocations.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        
        let locationForIndex = ParseAPIClient.CachedLocations.studentLocations[indexPath.row]
        let firstName = locationForIndex.firstName ?? ""
        let lastName = locationForIndex.lastName ?? ""
        let mediaURL = locationForIndex.mediaURL ?? ""
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text = mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if let toOpen = ParseAPIClient.CachedLocations.studentLocations[indexPath.row].mediaURL {
            if let url = URL(string: toOpen) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
}
