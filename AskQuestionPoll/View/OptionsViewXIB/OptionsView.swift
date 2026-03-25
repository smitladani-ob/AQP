//
//  OptionsView.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 24/03/26.
//

import UIKit



class OptionsView: NibView {
    
    enum OptionsDisplayMode {
        case edit
        case preview
    }
    
    @IBOutlet weak var optionOneImageBg: UIImageView!
    @IBOutlet weak var optionOneTextview: UITextView!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var optionOneView: UIView!
    @IBOutlet weak var optionOneLOne: UILabel!
    @IBOutlet weak var optionOneLTwo: UILabel!
    @IBOutlet weak var optionTwoImageBg: UIImageView!
    @IBOutlet weak var optionTwoTextview: UITextView!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var optionTwoView: UIView!
    @IBOutlet weak var optionTwoLOne: UILabel!
    @IBOutlet weak var optionTwoLTwo: UILabel!
    @IBOutlet weak var optionOneHeight: NSLayoutConstraint!
    @IBOutlet weak var optionTwoHeight: NSLayoutConstraint!
    
    var displayMode: OptionsDisplayMode = .edit
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureForPreview(optionType: OptionType,
                             option1Text: String?,
                             option2Text: String?,
                             option1Image: UIImage?,
                             option2Image: UIImage?) {
        
        displayMode = .preview
        // Disable editing
        optionOneTextview.isEditable = false
        optionTwoTextview.isEditable = false
        optionOneTextview.isUserInteractionEnabled = false
        optionTwoTextview.isUserInteractionEnabled = false
        optionOneBtn.isHidden = true
        optionTwoBtn.isHidden = true
        optionOneView.isHidden = true
        optionTwoView.isHidden = true
        
        // TEXT MODE
        if optionType == .text {
            optionOneTextview.text = option1Text
            optionTwoTextview.text = option2Text
            optionOneTextview.isHidden = false
            optionTwoTextview.isHidden = false
            optionOneImageBg.image = UIImage.optionButton
            optionTwoImageBg.image = UIImage.optionButton
        }
        // IMAGE MODE
        else {
            optionOneImageBg.image = option1Image
            optionTwoImageBg.image = option2Image
            optionOneTextview.isHidden = true
            optionTwoTextview.isHidden = true
        }
        // Limit text size (no scroll)
        optionOneTextview.isScrollEnabled = false
        optionTwoTextview.isScrollEnabled = false
        optionOneTextview.textContainer.maximumNumberOfLines = 3
        optionTwoTextview.textContainer.maximumNumberOfLines = 3
    }
    
}
