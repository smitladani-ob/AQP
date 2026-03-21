//
//  HomeScreenViewController.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 21/03/26.
//

import UIKit

class HomeScreenViewController: UIViewController {

    //first container
    @IBOutlet weak var underLineTextView: UIView!
    @IBOutlet weak var charCounter: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textViewField: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var selectorImage: UIImageView!
    @IBOutlet weak var selectCategoryField: SelectCatagoryView!
    
    //second Container
    @IBOutlet weak var optionsView: RadioButtonsView!
    @IBOutlet weak var optionOneImageBg: UIImageView!
    @IBOutlet weak var optionOneTextview: UITextView!
    @IBOutlet weak var optionOneView: UIView!
    @IBOutlet weak var optionOneLOne: UILabel!
    @IBOutlet weak var optionOneLTwo: UILabel!
    @IBOutlet weak var optionTwoImageBg: UIImageView!
    @IBOutlet weak var optionTwoTextview: UITextView!
    @IBOutlet weak var optionTwoView: UIView!
    @IBOutlet weak var optionTwoLOne: UILabel!
    @IBOutlet weak var optionTwoLTwo: UILabel!
    
    //Third Container
    @IBOutlet weak var prefernceLabel: UILabel!
    @IBOutlet weak var chooseLocationField: SelectCatagoryView!
    @IBOutlet weak var afterLocationLbl: UILabel!
    @IBOutlet weak var chooseGenderField: SelectCatagoryView!
    @IBOutlet weak var afterGenderLbl: UILabel!
    
    //Fourth Container
    @IBOutlet weak var submitButton: yellowButtonView!
    @IBOutlet weak var previewButton: yellowButtonView!
    
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
