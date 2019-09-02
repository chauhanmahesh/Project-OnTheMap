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
    
    func fetchStudentLocations(completion: @escaping () -> Void) {
        ParseAPIClient.getStudentLocations() {
            completion()
        }
    }
    
}
