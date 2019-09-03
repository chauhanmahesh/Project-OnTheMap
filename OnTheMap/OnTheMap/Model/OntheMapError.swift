//
//  UnknownError.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 3/9/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

struct OnTheMapError: LocalizedError {
    
    var errorCode: ErrorCode?
    
    var localizedDescription: String {
        if let errorCode = errorCode {
            switch errorCode {
            case .NoResponse: return "No response from server."
            case .DecodingFailed: return "Unable to decode the response."
            case .ServerError: return "Server Error. Please try again."
            }
        } else {
            return "Unknown Error. Please try again."
        }
    }

}

enum ErrorCode {
    case NoResponse, DecodingFailed, ServerError
}
