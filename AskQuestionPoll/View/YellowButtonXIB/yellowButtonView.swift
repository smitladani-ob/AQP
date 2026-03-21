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
    
    func config(text: String){
        titleLabel.text = text
        titleLabel.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        titleLabel.textColor = UIColor.white
    }
    
}
