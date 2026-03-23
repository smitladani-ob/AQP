//
//  Constant.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

let storyboardOfMain = UIStoryboard(name: "Main", bundle: nil)

var screenWidth: CGFloat {
    return isiPadDevice ? 475 : UIScreen.main.bounds.size.width
}

var isiPadDevice: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

let isSmallScreen = UIScreen.main.bounds.height <= 667

//MARK: APIs
let serverUrl = "ttp://192.168.0.110/ask_question_poll/api/public/api/"
let loginForUser = serverUrl + "loginForUser"
let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"
//let signup = serverUrl + "signup"

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

//For Custom Xibs
class NibView: UIView {
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
}
private extension NibView {
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}


//For left nav bar button

