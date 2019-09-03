//
//  APIClient.swift
//  OnTheMap
//
//  Created by Mahesh Chauhan on 31/8/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import Foundation

class APIClient {
    
    static let base = "https://onthemap-api.udacity.com/v1"

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, OnTheMapError?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            self.handleResponse(data, response, error, responseType, completion)
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, OnTheMapError?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            self.handleResponse(data, response, error, responseType, completion)
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, OnTheMapError?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            self.handleResponse(data, response, error, responseType, completion)
        }
        task.resume()
    }
    
    private class func handleResponse<ResponseType: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ responseType: ResponseType.Type, _ completion: @escaping (ResponseType?, OnTheMapError?) -> Void) {
        if error != nil {
            DispatchQueue.main.async {
                completion(nil, OnTheMapError(errorCode: nil))
            }
            return
        }
        
        // Let's check the response to see if its a success or not.
        guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
            // Ideally this should never happen.
            completion(nil, OnTheMapError(errorCode: nil))
            return
        }
        
        if httpStatusCode >= 200 && httpStatusCode < 300 {
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, OnTheMapError(errorCode: .NoResponse))
                }
                return
            }
            // Success case
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, OnTheMapError(errorCode: .DecodingFailed))
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(nil, OnTheMapError(errorCode: .ServerError))
            }
        }
    }
    
    class func taskForDELETERequest<RequestType: Encodable>(url: URL, body: RequestType, completion: @escaping () -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
    
}
