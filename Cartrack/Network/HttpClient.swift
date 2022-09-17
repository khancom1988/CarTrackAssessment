//
//  HttpClient.swift
//  Cartrack
//
//  Created by Aadil Majeed on 14/09/22.
//

import Foundation

let kUserURL = "https://jsonplaceholder.typicode.com/users"

class HttpClient {
        
    public class func fetchUsers(completionHandler: @escaping(_ result: Result<[User], Error>) -> Void) -> Void {
        
        guard let userUrl = URL(string: kUserURL) else {
            return
        }
        
        let request = URLRequest(url: userUrl)
        
        self.request(request: request, decodableType: [User].self) { result in
            OperationQueue.main.addOperation({
                completionHandler(result)
            })
        }
    }
    
    private class func request<T>(request: URLRequest, decodableType: T.Type, completionHandler: @escaping(_ result: Result<T, Error>) -> Void) -> Void where T : Decodable {
        
        let dataDecodableTypeType = decodableType
        
        self.request(request: request) { result in

            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let responseModel = try decoder.decode(dataDecodableTypeType.self, from: data)
                    completionHandler(.success(responseModel))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
    
    private class func request(request: URLRequest, completionHandler: @escaping(_ result: Result<Data, Error>) -> Void) -> Void {
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            var responseCode = 500
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                responseCode = statusCode
            }
            // Parse JSON data
            if let serverData = data, responseCode == 200 {
                completionHandler(.success(serverData))
            }
            else {
                let error = NSError(domain: "CarTrack", code: responseCode, userInfo: [NSLocalizedDescriptionKey: "Somthing went wrong, Please try again later "])
                completionHandler(.failure(error))
            }
        })
        task.resume()
    }

}
