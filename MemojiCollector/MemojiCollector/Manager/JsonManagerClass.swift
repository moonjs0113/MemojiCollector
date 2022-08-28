//
//  JsonManager.swift
//  MemojiCollector
//
//  Created by Moon Jongseek on 2022/05/01.
//

import Foundation

class JsonManagerClass {
    public static var shared: JsonManagerClass = JsonManagerClass()
    
    func jsonDecoder(decodingData: Data) -> [MemojiCard] {
        let decoder = JSONDecoder()
        if let myMemojiCardList = try? decoder.decode([MemojiCard].self, from: decodingData) {
            return myMemojiCardList
        } else {
            return []
        }
    }
    
    func jsonEncoder(ecodingData: [MemojiCard]) -> Data {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(ecodingData) {
            return data
        } else {
            return Data()
        }
    }
    
//    func jsonToGroupDecoder(decodingData: Data) -> [Group] {
//        let decoder = JSONDecoder()
//        if let groupList = try? decoder.decode([Group].self, from: decodingData) {
//            return groupList
//        } else {
//            return []
//        }
//    }
//
//    func groupToJsonEncoder(ecodingData: [Group]) -> Data {
//        let encoder = JSONEncoder()
//        if let data = try? encoder.encode(ecodingData) {
//            return data
//        } else {
//            return Data()
//        }
//    }
    
    func jsonToStringDecoder(decodingData: Data) -> [String] {
        let decoder = JSONDecoder()
        if let stringList = try? decoder.decode([String].self, from: decodingData) {
            return stringList
        } else {
            return []
        }
    }
    
    func stringToJsonEncoder(ecodingData: [String]) -> Data {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(ecodingData) {
            return data
        } else {
            return Data()
        }
    }
}

enum JsonManager {
    static func jsonDecoder<D: Decodable>(decodingData: Data) throws -> D? {
        let decoder = JSONDecoder()
        guard let decodeObject = try? decoder.decode(D.self, from: decodingData) else {
//            throw NetworkError.errorDecodingJson
            return nil
        }
        return decodeObject
    }
    
    static func jsonEncoder<D: Encodable>(ecodingData: D) throws -> Data? {
        let encoder = JSONEncoder()
        guard let encodeData = try? encoder.encode(ecodingData) else {
//            throw NetworkError.errorEncodingJson
            return nil
        }
        return encodeData
    }
}
