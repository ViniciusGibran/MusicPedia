//
//  APIRequest.swift
//  BlipMusicLibrary
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import Foundation
import Combine

enum ResponseResult<T, E: APIError> {
    case success(T)
    case failure(E)
    
    func map<U>(_ transform: (T) -> U) -> ResponseResult<U, E> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}

final class APIError: Error, LocalizedError {
    
    enum ErrorType {
        case unknown, apiError(reason: String), notFound
    }
    
    var errorType: ErrorType
    
    init(_ errorType: APIError.ErrorType) {
        self.errorType = errorType
    }
    
    var errorDescription: String {
        switch errorType {
        case .unknown:
            return "Oops. Something went wrong! 💔"
        case .apiError(let reason):
            return reason
        case .notFound:
            return ""
        }
    }
}

class APIRequest: NSObject {
    var cancelBag = Set<AnyCancellable>()
    let decoder: JSONDecoder = JSONDecoder()
    
    func fetchDataFrom(url: URL) -> AnyPublisher<Data, APIError> {
        let request = URLRequest(url: url)
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError(.unknown)
                }
                
                // debug only
                //                guard let responsejson = String(data: data, encoding: .utf8) else { return data }
                //                print(responsejson)
                return data
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError(.apiError(reason: error.localizedDescription))
                }
            }
            .eraseToAnyPublisher()
    }
}
