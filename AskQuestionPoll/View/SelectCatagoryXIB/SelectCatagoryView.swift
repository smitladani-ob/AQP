//
//  SelectCatagoryView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 21/03/26.
//

import UIKit

class SelectCatagoryView: NibView {
    
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var imageOfTextFIeld: UIImageView!
    @IBOutlet weak var textFIeld: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        underLineView.layer.cornerRadius = 2.5
    }
    
    func configure(placeHolder: String,imageName: String = ""){
        let fontSize = CGFloat(0.048 * screenWidth)
        guard let font = UIFont(name: "SFAtarianSystemExtended", size: fontSize) else {
            print("❌ Font not found")
            return
        }
        textFIeld.font = font
        let paragraphStyle = NSMutableParagraphStyle()
        textFIeld.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
        )
        imageOfTextFIeld.image = UIImage(named: imageName)
        
    }
}
