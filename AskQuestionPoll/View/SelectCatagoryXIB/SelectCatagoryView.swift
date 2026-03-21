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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        underLineView.layer.cornerRadius = 2.5
    }
    
    func configure(placeHolder: String,imageName: String = ""){
        textFIeld.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        textFIeld.placeholder = placeHolder
        textFIeld.font = UIFont.systemFont(ofSize: 14)
        imageOfTextFIeld.image = UIImage(named: imageName)
        
    }
}
