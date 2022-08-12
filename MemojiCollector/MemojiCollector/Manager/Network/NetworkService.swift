//
//  NetworkService.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/08/12.
//

import Foundation

typealias NetworkClosure = (Result<Data, NetworkError>) -> Void

enum NetworkService {
    static let baseURL = "http://ec2-107-21-154-253.compute-1.amazonaws.com/"
    static let manager = NetworkManager(baseURL: baseURL)
}

/*
 /card      POST    : 카드 생성 POST
 /card      DELETE  : 나의 카드 지우기 DELETE
 /card/:id  GET     : 카드 단일 조회 GET
 
 /user/createUserID/:id     GET : User 등록하기
 /user/:id                  GET : User 정보 가져오기
 /user/:id                  DELETE : User 정보 지우기
 /user                      PATCH : User 이름 바꾸기
 /user/card                 PATCH : 공유받은 카드 업데이트
 */


extension NetworkService {
    enum Card: Route {
        case base
        case parameter(String)
        
        var route: String {
            switch self {
            case .base:
                return "card"
            case .parameter(let cardID):
                return "card/\(cardID)"
            }
        }
    }
    
    enum User {
        case base
        case create(String)
        case parameter(String)
        case update
        
        var route: String {
            switch self {
            case .base:
                return "user"
            case .create(let userName):
                return "user/createUserID/\(userName)"
            case .parameter(let userID):
                return "user/\(userID)"
            case .update:
                return "user/card"
            }
        }
    }
    
    static func requestCreateCard(requestDTO: RequestDTO, completeHandler: @escaping NetworkClosure) {
        
        guard let bodyData = try? JSONEncoder().encode(requestDTO) else {
            completeHandler(.failure(.errorEncodingJson))
            return
        }
        
        manager.requestPOST(route: Card.base.route, bodyData: bodyData, completeHandler: completeHandler)
    }
    
    static func requestDeleteCard(requestDTO: RequestDTO, completeHandler: @escaping NetworkClosure) {
        
        guard let bodyData = try? JSONEncoder().encode(requestDTO) else {
            completeHandler(.failure(.errorEncodingJson))
            return
        }
        
        manager.requestDELETE(route: Card.base.route, bodyData: bodyData, completeHandler: completeHandler)
    }
    
    static func requestCardData(cardID: String, completeHandler: @escaping NetworkClosure) {
        manager.requestGET(route: Card.parameter(cardID).route, completeHandler: completeHandler)
    }

//    enum ModelRoute: String, RouteProtocol {
//        var stringValue: String {
//            self.rawValue
//        }
//
//        var method: HTTPMethod {
//            return .GET
//        }
//
//        case character
//        case location
//        case episode
//
//        static func convertToString<M: Codable>(to model: M.Type) -> ModelRoute? {
//            switch model {
//            case is Character.Type:
//                return .character
//            case is Location.Type:
//                return .location
//            case is Episode.Type:
//                return .episode
//            default:
//                return nil
//            }
//        }
//    }
//
//    static func requestTotalObject<M: Codable>(as model: M.Type, completeHandler: @escaping NetworkClosure<ModelList<M>>) {
//        guard let route = ModelRoute.convertToString(to: model) else {
//            completeHandler(nil, .invalidType)
//            return
//        }
//
//        manager.sendRequest(route: route, decodeTo: ModelList<M>.self) { info, error in
//            completeHandler(info, error)
//        }
//    }
//
//    static func requestObject<M: Codable, F: FilterProtocol>(as model: M.Type, filterBy filter: [F] = [], completeHandler: @escaping NetworkClosure<ModelList<M>>) {
//        guard let route = ModelRoute.convertToString(to: model) else {
//            completeHandler(nil, .invalidType)
//            return
//        }
//
//        manager.sendRequest(route: route, filterBy: filter, decodeTo: ModelList<M>.self) { info, error in
//            completeHandler(info, error)
//        }
//    }
//
//    // Single or Multile Object(s)
//    static func requestSingleObject<M: Codable>(as model: M.Type, id: Int, completeHandler: @escaping NetworkClosure<M>) {
//        guard let route = ModelRoute.convertToString(to: model) else {
//            completeHandler(nil, .invalidType)
//            return
//        }
//
//        manager.sendRequest(route: route, ids: [id], decodeTo: model.self) { result, error in
//            completeHandler(result, error)
//        }
//    }
//
//    static func requestSingleObjectToURL<M: Codable>(as model: M.Type, url: String?) async throws -> M {
//        guard let url = URL(string: url ?? "") else {
//            throw NetworkError.invalidURL
//        }
//
//        let data = try await manager.sendRequest(url: url)
//        return try manager.jsonDecode(data: data, decodeTo: model.self)
//    }
//
//    static func requestMultipleObjects<M: Codable>(as model: M.Type, id: [Int], completeHandler: @escaping NetworkClosure<[M]>) {
//        guard let route = ModelRoute.convertToString(to: model) else {
//            completeHandler(nil, .invalidType)
//            return
//        }
//
//        manager.sendRequest(route: route, ids: id, decodeTo: [M].self) { result, error in
//            completeHandler(result, error)
//        }
//    }
//
//    static func requestImageData(url: String) throws -> Data {
//        guard let url = URL(string: url) else {
//            throw NetworkError.invalidURL
//        }
//
//        do {
//            let imageData = try manager.sendRequestImageData(url: url)
//            return imageData
//        } catch (let e as NetworkError) {
//            throw e
//        }
//    }
//
//    static func requestImageData(url: String) async throws -> Data {
//        guard let url = URL(string: url) else {
//            throw NetworkError.invalidURL
//        }
//
//        do {
//            let imageData = try await manager.sendRequestImageData(url: url)
//            return imageData
//        } catch (let e as NetworkError) {
//            throw e
//        }
//    }
}
