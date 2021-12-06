//
//  ApiService.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 01/12/21.
//

import Foundation

protocol APIServiceProtocol {
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void)
}

class ApiServiceManager :  APIServiceProtocol {
    
    static let shared: ApiServiceManager = ApiServiceManager()

    enum HTTPError: Error {
        case invalidURL
        case invalidResponse(Data?, URLResponse?)
    }
    
    func get(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                    return
            }

            completionBlock(.success(responseData))
        }
        task.resume()
    }
    
//    func apiToGetAstronomyPicture(completion : @escaping (PictureModel) -> ()){
//        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
//            guard let url = URL(string: urlString) else {
//                completionBlock(.failure(HTTPError.invalidURL))
//                return
//            }
//            
//            if let data = data {
//                
//                let jsonDecoder = JSONDecoder()
//                
//                let pictureData = try! jsonDecoder.decode(PictureModel.self, from: data)
//                    completion(pictureData)
//            }
//        }.resume()
//    }
}
