//
//  NetworkManager.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/12.
//

import Foundation

class NetworkManager {
    let baseURL: String
    private var session = URLSession(configuration: URLSessionConfiguration.default,
                                     delegate: nil,
                                     delegateQueue: nil)
    
    private let request: (_ url: URL,_ method: HTTPMethod, _ body: Data?) -> URLRequest = { url, method, body in
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    deinit {
        self.session.finishTasksAndInvalidate()
    }
}

extension NetworkManager {
    /// Get Method Request
    func requestGET(route: String, completeHandler: @escaping NetworkClosure) {
        let urlString = self.baseURL + route

        guard let url = URL(string: urlString) else {
            completeHandler(.failure(.invalidURL))
            return
        }

        let request = self.request(url, .GET, nil)
        sendRequest(request: request, completeHandler: completeHandler)
    }
    
    /// Post Method Request
    func requestPOST(route: String, bodyData: Data, completeHandler: @escaping NetworkClosure) {
        let urlString = self.baseURL + route

        guard let url = URL(string: urlString) else {
            completeHandler(.failure(.invalidURL))
            return
        }
        
        let request = self.request(url, .POST, bodyData)
        sendRequest(request: request, completeHandler: completeHandler)
    }
    
    /// Post Method Request
    func requestDELETE(route: String, bodyData: Data? = nil, completeHandler: @escaping NetworkClosure) {
        let urlString = self.baseURL + route

        guard let url = URL(string: urlString) else {
            completeHandler(.failure(.invalidURL))
            return
        }
        
        let request = self.request(url, .DELETE, bodyData)
        sendRequest(request: request, completeHandler: completeHandler)
    }
    
    /// Post Method Request
    func requestPATCH(route: String, bodyData: Data? = nil, completeHandler: @escaping NetworkClosure) {
        let urlString = self.baseURL + route

        guard let url = URL(string: urlString) else {
            completeHandler(.failure(.invalidURL))
            return
        }
        
        let request = self.request(url, .PATCH, bodyData)
        sendRequest(request: request, completeHandler: completeHandler)
    }
    
    func sendRequest(request: URLRequest, completeHandler: @escaping NetworkClosure) {
        self.session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completeHandler(.failure(.nilResponse))
                return
            }

            completeHandler(.success(data))
        }
        .resume()
    }
}


