//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/1/21.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var firstname = ""
        static var lastname = ""
        static var nickname = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case getStudentLocations
        case postSession
        case postUserLocation
        case getUserData(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations:
                return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .postSession:
                return Endpoints.base + "session"
            case .postUserLocation:
                return Endpoints.base + "StudentLocation"
            case .getUserData(let userId):
                return Endpoints.base + "users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getUserData(completion: @escaping (String?, Error?) -> Void) {
//        let request = URLRequest(url: Endpoints.getUserData(Auth.accountKey).url)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(nil, error)
//            }

//            let fixedData = self.fixJSONResposeData(data: data)
            
            taskForGETRequest(url: Endpoints.getUserData(Auth.accountKey).url, response: UserResponse.self, chompResponse: true) { (response, error) in
                if error != nil {
                    completion(nil, error)
                }
                
                Auth.firstname = (response?.firstName)!
                Auth.lastname = (response?.lastName)!
                Auth.nickname = (response?.nickname)!
                print("*** This is the user's name for the session \(Auth.nickname)")
                completion(response?.nickname, nil)
                
                
            }
    
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(UserResponse.self, from: fixedData)
//                DispatchQueue.main.async {
//                    Auth.firstname = responseObject.firstName
//                    Auth.lastname = responseObject.lastName
//                    Auth.nickname = responseObject.nickname
//                    print("*** This is the user's name for the session \(Auth.nickname)")
//                    completion(responseObject.nickname, nil)
//                }
//            } catch {
//                print("In getUserData while decoding UserReposnse response \(error)")
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//            }
//        }
//        task.resume()
    }
    
    class func postUserLocation(location: StudentLocationData, completion: @escaping (Bool, Error?) -> Void) {
//        var request = URLRequest(url: Endpoints.postUserLocation.url)
//        var request = URLRequest(url: URL(string: "www")!)
        //completion(true, nil)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = StudentLocationRequest(uniqueKey: Auth.accountKey, firstName: location.firstName, lastName: location.lastName, mapString: location.mapString, mediaURL: location.mediaURL, latitude: location.latitude, longitude: location.longitude)
        
        taskForPOSTRequest(url: Endpoints.postUserLocation.url, responseType: UserResponse.self, body: body) { (response, error) in
            if error != nil { // Handle error…
                completion(true, error)
            }
            //print(String(data: data!, encoding: .utf8)!)
            completion(true, nil)
        }
       
        
//        request.httpBody = try! JSONEncoder().encode(body)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                completion(true, error)
//            }
//            //print(String(data: data!, encoding: .utf8)!)
//            completion(true, nil)
//        }
//        task.resume()
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
         let loginRequest = LoginRequest(udacity: ["username":"cary.guca@gmail.com","password":"puRsuc-4tawxo-vipvir"])
//        let loginRequest = LoginRequest(udacity: ["username":username,"password":password])
        taskForPOSTRequest(url: Endpoints.postSession.url, responseType: SessionResponse.self, body: loginRequest) { (response, error)
        in
            if let response = response {
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
//    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//        let loginRequest = LoginRequest(udacity: ["username":"cary.guca@gmail.com","password":"puRsuc-4tawxo-vipvir"])
////        let loginRequest = LoginRequest(udacity: ["username":username,"password":password])
//        var request = URLRequest(url: Endpoints.postSession.url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        let body = loginRequest
//        request.httpBody = try! JSONEncoder().encode(body)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if error != nil {
//                completion(false, error)
//                return
//             }
//            let range = 5..<data!.count
//            let newData = data?.subdata(in: range)
//             print(String(data: newData!, encoding: .utf8)!)
//
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(SessionResponse.self, from: newData!)
//                Auth.accountKey = responseObject.account.key
//                Auth.sessionId = responseObject.session.id
//                print(responseObject)
//                DispatchQueue.main.async {
//                    completion(true, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(false, error)
//                }
//            }
//        }
//        task.resume()
//    }
    
    class func deleteSession(completion: @escaping (Bool, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.postSession.url, responseType: DeleteSessionResponse.self) { (response, error)
        in
            if let _ = response {
                Auth.accountKey = ""
                Auth.sessionId = ""
                Auth.nickname = ""
                Auth.firstname = ""
                Auth.lastname = ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, response: StudentLocationsResponse.self, chompResponse: false) { (response, error)
        in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, chompResponse: Bool, completion: @escaping (ResponseType?, Error?)->Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            var fixedData = data
            if chompResponse {
                fixedData = self.fixJSONResposeData(data: data)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: fixedData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    class func taskForPOSTRequest <RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion(nil, error)
                return
             }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("The data is empty")
                    completion(nil, error)
                }
                return
            }
            
//            let range = 5..<data.count
//            let newData = data.subdata(in: range) /* subset response data! */
            let fixedData = self.fixJSONResposeData(data: data)
            print(String(data: fixedData, encoding: .utf8)!)
        
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: fixedData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    /*
     Utility function
     */
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
   
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            
            let fixedData = self.fixJSONResposeData(data: data)
            print(String(data: fixedData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: fixedData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("In taskForDELETERequest while decoding fixedData response \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func getCurrentUserName() -> (String, String, String) {
        return (fistname: Auth.firstname, lastname: Auth.lastname, nickname: Auth.nickname)
    }
    
    /*
     Utility function to 'fix' certain JSON responses by removing invalid leading characters
     */
    class func fixJSONResposeData(data: Data?) -> Data{
        let range = 5..<data!.count
        let newData = data?.subdata(in: range) /* subset response data! */
        return newData!
    }
}
