//
//  UserData.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 2/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    
    let user: UserData

}

struct UserData: Codable {
    
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
}
