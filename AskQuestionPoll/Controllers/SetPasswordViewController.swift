//
//  SetPasswordViewController.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import UIKit

class SetPasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextfield: AuthTextFieldView!
    @IBOutlet weak var confirmPasswordTextfield: AuthTextFieldView!
    @IBOutlet weak var saveButton: yellowButtonView!
    
    var resetToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setupGlobalBackButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
        
    func setupUI() {
        newPasswordTextfield.configure(labelText: "NEW PASSWORD", textFieldPlaceholder: "Enter New Password")
        confirmPasswordTextfield.configure(labelText: "CONFIRM PASSWORD", textFieldPlaceholder: "Enter Confirm Password")
        saveButton.config(text: "SAVE",textColor: UIColor.white)
    }
    
    @objc func saveButtonTapped() {
        let newPassWord = newPasswordTextfield.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirmPassWord = confirmPasswordTextfield.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if newPassWord.isEmpty && confirmPassWord.isEmpty {
            showError("Please Enter New Password and Confirm Password")
        }
        if newPassWord.isEmpty {
            showError("Please Enter New Password")
        }
        if confirmPassWord.isEmpty {
            showError("Please Enter Confirm Password")
        }
    }
}
