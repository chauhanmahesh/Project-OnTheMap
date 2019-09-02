//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 1/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    
    let status: Int
    let error: String
    
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
