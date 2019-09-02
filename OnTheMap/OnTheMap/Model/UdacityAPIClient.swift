//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 31/8/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

class UdacityAPIClient: APIClient {
    
    struct Auth {
        static var key = ""
        static var sessionId = ""
        static var firstName = ""
        static var lastName = "'"
    }
    
    enum Endpoints {
        
        case postSession
        case deleteSession
        case getPublicUserData(String)
        
        var stringValue: String {
            switch self {
            case .postSession: return base + "/session"
            case .deleteSession: return base + "/session"
            case .getPublicUserData(let userId): return base + "/users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: self.Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            Auth.key = ""
            Auth.sessionId = ""
            DispatchQueue.main.async {
                // Irrespective of whether this request is success or not, we will logout.
                completion()
            }
        }
        task.resume()
    }
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: self.Endpoints.postSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = try! JSONEncoder().encode(UdacityLoginRequest(udacity: LoginDetail(username: email, password: password)))
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            
            guard let data = newData else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LoginResponse.self, from: data)
                Auth.key = responseObject.account.key
                Auth.sessionId = responseObject.session.id
                getUserData(userId: responseObject.session.id, completion: completion)
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getUserData(userId: String, completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: self.Endpoints.getPublicUserData(userId).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            
            guard let data = newData else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UserData.self, from: data)
                Auth.firstName = responseObject.firstName ?? ""
                Auth.lastName = responseObject.lastName ?? ""
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
