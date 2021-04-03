//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/1/21.
//

import Foundation

class OnTheMapClient {
    enum Endpoints {
//        static let base = "https://api.themoviedb.org/3"
//        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getStudentLocations
        case posterImageURL(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations:
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100"
            case .posterImageURL(let posterPath):
                return "https://image.tmdb.org/t/p/w500/\(posterPath)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
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

}
