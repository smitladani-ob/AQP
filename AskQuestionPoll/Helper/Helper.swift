//
//  Helper.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 27/03/26.
//

import UIKit

//JSON Parser
class JSONLoader {
    static func load<T: Decodable>(_ fileName: String) -> T? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File not found: \(fileName)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding \(fileName):", error)
            return nil
        }
    }
}
