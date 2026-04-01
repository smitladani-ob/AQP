//
//  cornerRadiusHelper.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 31/03/26.
//
import UIKit

//JSON Parser
func JSONloader<T: Decodable>(_ fileName: String) -> T? {
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

//Set Border
func setBorder(view: UIView, color: CGColor = UIColor.black.cgColor, width: CGFloat = 1) {
    view.layer.borderColor = color
    view.layer.borderWidth = width
}
  
//Set CornerRadius
func setCornerRadius(view: UIView,cornerRadius: CGFloat = 8) {
    view.layer.cornerRadius = cornerRadius
    view.clipsToBounds = true
}
