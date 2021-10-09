//
//  ServiceClient.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/09/21.
//

import Foundation

class ServiceClient {
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1"
        
        case classicLogin
        
        var stringValue: String {
            switch self {
            case .classicLogin:
                return Endpoints.baseUrl + " "
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func classicLogin(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
    }
}
