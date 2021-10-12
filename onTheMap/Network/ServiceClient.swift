//
//  ServiceClient.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/09/21.
//

import Foundation

class ServiceClient {
    
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
    }
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1"
        
        case classicLogin
        case fetchStudentLocations
        
        var stringValue: String {
            switch self {
                case .classicLogin: return Endpoints.baseUrl + "/session"
                case .fetchStudentLocations: return Endpoints.baseUrl + "/StudentLocation?limit=100"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func classicLogin(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        NetworkHelper.taskForPOSTRequest(url: Endpoints.classicLogin.url, responseType: LoginResponse.self, body: body, httpMethod: "POST"){ response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func fetchStudentLocations(completion: @escaping([StudentInformation]?, Error?) -> Void) {
        NetworkHelper.taskForGETRequest(url: Endpoints.fetchStudentLocations.url, responseType: StudentsLocation.self){
            response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    
}
