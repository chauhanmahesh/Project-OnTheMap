//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 1/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

struct UdacityLoginRequest: Codable {
    let udacity: LoginDetail
}

struct LoginDetail: Codable {
    let username: String
    let password: String
}
