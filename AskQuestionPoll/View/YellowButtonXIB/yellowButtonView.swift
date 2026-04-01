//
//  yellowButtonView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 18/03/26.
//

import UIKit

class yellowButtonView: NibView {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(text: String,textColor: UIColor, size: CGFloat){
        titleLabel.text = text
        titleLabel.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(size * screenWidth),type: .DEFAULT)
        titleLabel.textColor = textColor
    }
    
}
