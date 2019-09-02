//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 2/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    
}
