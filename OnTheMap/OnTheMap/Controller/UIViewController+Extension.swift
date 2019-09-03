//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 1/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityAPIClient.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func showError(title: String, message: String, actionHandler: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            actionHandler()
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func fetchStudentLocations(completion: @escaping (Bool, OnTheMapError?) -> Void) {
        ParseAPIClient.getStudentLocations(completion: completion)
    }
    
}
