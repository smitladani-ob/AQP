//
//  Extensions.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit


//Extension of hex converter
extension UIColor {
    convenience init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

// for navbar back button
extension UINavigationController {
    func setupGlobalBackButton() {
        let backImage = UIImage(named: "back_btn")?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}

extension UIView {
    func setBorder(color: CGColor, width: CGFloat = 1) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
    func setCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}

//for load image from server
extension UIImageView {
    func load(url: String?) {
        guard let urlString = url,
              let url = URL(string: urlString) else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

// MARK: - Password Validation
extension String {
    /// Returns a user-facing error message if the password fails strong-password rules, or nil if valid.
    /// Rules: 8–16 characters, ≥1 uppercase, ≥1 digit, ≥1 special character.
    func passwordValidationError() -> String? {
        let minLength = 8
        let maxLength = 16
        guard self.count >= minLength else {
            return "Password must be at least \(minLength) characters"
        }
        guard self.count <= maxLength else {
            return "Password must be at most \(maxLength) characters"
        }
        let hasUppercase = self.contains(where: { $0.isUppercase })
        guard hasUppercase else {
            return "Password must contain at least one uppercase letter"
        }
        let hasDigit = self.contains(where: { $0.isNumber })
        guard hasDigit else {
            return "Password must contain at least one digit"
        }
        let specialChars = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;':\",./<>?`~\\")
        let hasSpecial = self.unicodeScalars.contains(where: { specialChars.contains($0) })
        guard hasSpecial else {
            return "Password must contain at least one special character (!@#$%^&* etc.)"
        }
        return nil
    }
}
