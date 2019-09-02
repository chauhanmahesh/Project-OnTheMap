//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 31/8/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

class ParseAPIClient: APIClient {
    
    struct CachedLocations {
        static var studentLocations: [StudentLocationResponse] = []
    }
    
    struct PostedLocation {
        static var postedLocationObjectId: String?
        static var createdOrUpdatedAt: String?
    }
    
    enum Endpoints {
        case getStudentLocations(Int)
        case postStudentLocation
        case updateStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit): return  base + "/StudentLocation?limit=\(limit)&order=-updatedAt"
            case .postStudentLocation: return base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return base + "/StudentLocation/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getStudentLocations(completion: @escaping () -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations(100).url, responseType: StudentLocationsResponse.self) { (response, error) in
            if let response = response {
                CachedLocations.studentLocations = response.results
                completion()
            } else {
                completion()
            }
        }
    }
    
    class func postStudentLocation(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostStudentLocationResponse.self, body: studentLocation) { (response, error) in
            if let response = response {
                PostedLocation.postedLocationObjectId = response.objectId
                PostedLocation.createdOrUpdatedAt = response.createdAt
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateStudentLocation(objectId: String, studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPUTRequest(url: Endpoints.updateStudentLocation(objectId).url, responseType: UpdateStudentLocationResponse.self, body: studentLocation) { (response, error) in
            if let response = response {
                PostedLocation.createdOrUpdatedAt = response.updatedAt
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}
