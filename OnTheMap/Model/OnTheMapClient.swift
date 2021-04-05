//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/1/21.
//

import Foundation

class OnTheMapClient {
    
    struct Auth {
        static var accountId = ""
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
//        static let base = "https://onthemap-api.udacity.com/v1/"
//        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getStudentLocations
        case postSession
        case postUserLocation
        case posterImageURL(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
            case .postSession:
                return "https://onthemap-api.udacity.com/v1/session"
            case .postUserLocation:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .posterImageURL(let posterPath):
                return "https://image.tmdb.org/t/p/w500/\(posterPath)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func postUserLocation(location: StudentLocationData, completion: @escaping (Bool, Error?) -> Void) {
//        var request = URLRequest(url: Endpoints.postUserLocation.url)
        var request = URLRequest(url: URL(string: "www")!)
        //completion(true, nil)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = StudentLocationRequest(uniqueKey: Auth.accountId, firstName: location.firstName, lastName: location.lastName, mapString: location.mapString, mediaURL: location.mediaURL, latitude: location.latitude, longitude: location.longitude)
        
        request.httpBody = try! JSONEncoder().encode(body)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(true, error)
            }
            //print(String(data: data!, encoding: .utf8)!)
            completion(true, nil)
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool?, Error?) -> Void) {
        let loginRequest = LoginRequest(udacity: ["username":"cary.guca@gmail.com","password":"puRsuc-4tawxo-vipvir"])
//        let loginRequest = LoginRequest(udacity: ["username":username,"password":password])
        var request = URLRequest(url: Endpoints.postSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let body = loginRequest
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { // Handle error…
                completion(false, error)
                return
             }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
             print(String(data: newData!, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(SessionResponse.self, from: newData!)
                Auth.accountId = responseObject.account.key
                print(responseObject)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func deleteSession(completion: @escaping (Bool, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.postSession.url, responseType: DeleteSessionResponse.self) { (response, error)
        in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, response: StudentLocationsResponse.self) { (response, error)
        in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?)->Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
           
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
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
        return task
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let body = body
        print("Here is the body before encoding \(try! JSONEncoder().encode(body))")
        request.httpBody = try! JSONEncoder().encode(body)
        
        print("Here is the request json \(request.httpBody)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil { // Handle error…
                 return
             }
            
            let range = 5..<data!.count
             let newData = data?.subdata(in: range) /* subset response data! */
             print(String(data: newData!, encoding: .utf8)!)
            
            guard let data = data else {
//                DispatchQueue.main.async {
                    print("The data is empty")
                    completion(nil, error)
//                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
//                do {
//                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
//                }
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
    
    /*
     Utility function to 'fix' certain JSON responses by removing invalid leading characters
     */
    class func fixJSONResposeData(data: Data?) -> Data{
        let range = 5..<data!.count
        let newData = data?.subdata(in: range) /* subset response data! */
        return newData!
    }
}
