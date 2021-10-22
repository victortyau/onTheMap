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
        static var objectId = ""
    }
    
    enum Endpoints {
        static let baseUrl = "https://onthemap-api.udacity.com/v1"
        
        case classicLogin
        case fetchStudentLocations
        case signUpLink
        case addLocation
        //case updateLocation
        
        var stringValue: String {
            switch self {
                case .classicLogin: return Endpoints.baseUrl + "/session"
                case .fetchStudentLocations: return Endpoints.baseUrl + "/StudentLocation?limit=100&order=-updatedAt"
                case .signUpLink: return "https://auth.udacity.com/sign-up"
                case .addLocation: return Endpoints.baseUrl + "/StudentLocation"
                //case .updateLocation: return Endpoints.baseUrl + "/StudentLocation/" + Auth.objectId
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
                completion(false, error)
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
    
    class func classicLogout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.classicLogin.url)
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
          if error != nil {
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          print(String(data: newData!, encoding: .utf8)!)
          Auth.sessionId = ""
          completion()
        }
        task.resume()
    }
    
    class func addLocation(studentInformation: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(studentInformation.uniqueKey ?? "")\", \"firstName\": \"\(studentInformation.firstName)\", \"lastName\": \"\(studentInformation.lastName)\",\"mapString\": \"\(studentInformation.mapString ?? "")\", \"mediaURL\": \"\(studentInformation.mediaURL ?? "")\",\"latitude\": \(studentInformation.latitude ?? 0.0), \"longitude\": \(studentInformation.longitude ?? 0.0)}"
        NetworkHelper.taskForPOSTRequest(url: Endpoints.addLocation.url, responseType: PostLocationResponse.self, body: body, httpMethod: "POST") {
            response, error in
            if let response = response, response.createdAt != nil {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            }
            completion(false, error)
        }
    }
}
