//
//  HomeScreenViewController.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 21/03/26.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var underLineTextView: UIView!
    @IBOutlet weak var charCounter: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textViewField: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var selectorImage: UIImageView!
    @IBOutlet weak var selectCategoryField: SelectCatagoryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let custFont = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        selectCategoryField.configure(placeHolder: "SELECT CATEGORY", imageName: "dropdown_icon")
        questionLabel.text = "QUESTIONS"
        questionLabel.font = custFont
        descriptionLabel.text = "DESCRIPTION"
        descriptionLabel.font = custFont
        selectorImage.layer.borderWidth = 2
        selectorImage.layer.borderColor = UIColor.white.cgColor
        selectorImage.image = UIImage(named: "ask_question_logo")
        
    }
    
    

}
