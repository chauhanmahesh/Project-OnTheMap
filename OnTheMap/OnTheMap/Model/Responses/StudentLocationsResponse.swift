//
//  StudentLocationResponse.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 31/8/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

struct StudentLocationsResponse: Codable {
    
    let results: [StudentLocationResponse]
    
}

struct StudentLocationResponse: Codable {
    
    let firstName: String?
    let lastName: String?
    let longitude: Double?
    let latitude: Double?
    let mapString: String?
    let mediaURL: String?
    let uniqueKey: String
    let objectId: String
    let createdAt: String?
    let updatedAt: String?
    
}

