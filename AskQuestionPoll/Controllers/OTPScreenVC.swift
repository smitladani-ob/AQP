//
//  OTPScreenVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import UIKit

enum ScreenState {
    case otp
    case email
    case setNewPassword
}

class OTPScreenVC: UIViewController {

    @IBOutlet weak var setNewPassword: AuthTextFieldView!
    @IBOutlet weak var submitButton: yellowButtonView!
    @IBOutlet weak var otpField: AuthTextFieldView!
    
    var userRegTempID: Int?//passed from SignUpVC, used in signup OTP verification
    var isForgotPassword: Bool = false //Which Flow Are In
    var screenState: ScreenState = .otp //Current Active State (Screen State)
    var enteredEmail: String? //For Save Email Which use type in email state
    var resetToken: String? //server sends this after OTP verification, needed for password reset API
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setupGlobalBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.title = nil
    }
    
    func setupUI() {
        self.submitButton.loginButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        self.resetFields()
        // Delegate for keyboard handling
        self.otpField.actualTextField.delegate = self
        self.setNewPassword.actualTextField.delegate = self
        // Reset accessory view by default
        self.otpField.actualTextField.inputAccessoryView = nil
        switch screenState {
        case .email:
            self.otpField.configure(labelText: "EMAIL", textFieldPlaceholder: "Enter Email")
            self.otpField.actualTextField.keyboardType = .emailAddress
            self.otpField.actualTextField.isSecureTextEntry = false
            self.otpField.actualTextField.returnKeyType = .done
            if let email = enteredEmail, !email.isEmpty {
                otpField.actualTextField.text = email
            }
            self.setNewPassword.isHidden = true
            self.submitButton.config(text: "NEXT", textColor: .white, size: 0.048)
        case .otp:
            self.otpField.configure(labelText: "OTP", textFieldPlaceholder: "Enter OTP")
            self.otpField.actualTextField.keyboardType = .numberPad
            self.otpField.actualTextField.isSecureTextEntry = false
            self.otpField.actualTextField.returnKeyType = .done
            self.addToolbarToOTPField() // Adds 'Done' button for numpad
            self.setNewPassword.isHidden = true
            self.submitButton.config(text: "OK", textColor: .white, size: 0.048)
        case .setNewPassword:
            self.otpField.configure(labelText: "NEW PASSWORD", textFieldPlaceholder: "Enter New Password")
            self.otpField.actualTextField.keyboardType = .default
            self.otpField.actualTextField.isSecureTextEntry = true
            self.otpField.actualTextField.returnKeyType = .next
            self.setNewPassword.isHidden = false
            self.setNewPassword.configure(labelText: "CONFIRM PASSWORD", textFieldPlaceholder: "Confirm Password")
            self.setNewPassword.actualTextField.keyboardType = .default
            self.setNewPassword.actualTextField.isSecureTextEntry = true
            self.setNewPassword.actualTextField.returnKeyType = .done
            self.submitButton.config(text: "SUBMIT", textColor: .white, size: 0.048)
        }
    }
    
    private func addToolbarToOTPField() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneBtn]
        self.otpField.actualTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    func resetFields() {
        self.otpField.actualTextField.text = ""
        self.setNewPassword.actualTextField.text = ""
    }
    
    //This Calls When User Come from the SignUp (
    func verifyUserAPI(tempID: Int, otp: Int) {
        let device = DeviceInfo()
        let request = VerifyUserRequest(userId: tempID,token: otp,device: device)
        showWait()
        APIManager.sharedInstance.verifyUser(request: request) { response, error, isSuccess in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hideWait()
                if isSuccess {
                    showSuccess(response?.message ?? "Success")
//                        print("JWT Token:", response.data?.token ?? "")
//                        print("User Email:", response.data?.user?.email_id ?? "")
                    // Save token if needed
                    let token = response?.data?.token
                    self.navigationController?.popToRootViewController(animated: true) //Goes to Login screen
                } else {
                    print(error ?? "")
                    showError(error ?? "Something went wrong")
                }
            }
        }
    }
    
    //this validates email is in server or not (From Forgot Password button)
    func forgotPasswordAPI(email: String) {
        showWait()
        let request = ForgotPasswordRequestModel(email_id: email)
        APIManager.sharedInstance.forgotPassword(request: request) { response, error, isSuccess in
            DispatchQueue.main.async {
                hideWait()
                if isSuccess {
                    showSuccess(response?.message ?? "Success")
                    self.isForgotPassword = true
                    self.screenState = .otp
                    self.setupUI()
                } else {
                    showError(error ?? "Something went wrong")
                }
            }
        }
    }
    
    //This calles when user email is verify for forgot password
    func verifyForgotOTPAPI(otp: String) {
        guard let email = self.enteredEmail, !email.isEmpty else {
            showError("Email missing")
            return
        }
        guard let otpInt = Int(otp) else {
            showError("Invalid OTP")
            return
        }
        showWait()
        let request = VerifyForgotOTPRequest(email: email, token: otpInt)
        APIManager.sharedInstance.verifyForgotOTP(request: request) { response, error, isSuccess in
            DispatchQueue.main.async {
                hideWait()
                if isSuccess {
                    showSuccess(response?.message ?? "Your OTP is verified successfully")
                    // Save token if needed
                    self.resetToken = response?.data?.token
                    print("Reset Token:", self.resetToken ?? "")
                    self.screenState = .setNewPassword
                    self.setupUI()
                } else {
                    print(error ?? "")
                    showError(error ?? "Something went wrong")
                }
            }
        }
    }
    
    //API CALL FOR GENERATE PASSWORD
    func setPasswordAPI(password: String) {
        guard let email = enteredEmail, let token = resetToken else {
            showError("Missing data")
            return
        }
        showWait()
        let request = GenerateNewPasswordRequest(email: email,password: password,token: token)
        APIManager.sharedInstance.setNewPassword(request: request) { response, error, isSuccess in
            DispatchQueue.main.async {
                hideWait()
                if isSuccess {
                    showSuccess(response?.message ?? "Password Updated")
                    //  OPTIONAL CLEANUP (recommended)
                    self.resetToken = nil
                    self.enteredEmail = nil
                    // Go back to Login
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    showError(error ?? "Something went wrong")
                }
            }
        }
    }
    
    @objc func submitButtonTapped() {
        let text = otpField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        switch self.screenState {
        case .email:
            if text.isEmpty {
                showError("Please Enter Email")
                return
            }
            if let emailError = text.emailValidationError() {
                showError(emailError)
                return
            }
            self.enteredEmail = text
            self.forgotPasswordAPI(email: text)
        case .otp:
            if text.isEmpty {
                showError("Please Enter OTP")
                return
            }
            if isForgotPassword {
                self.verifyForgotOTPAPI(otp: text) // forgot password path
                // Move to Set Password
                self.screenState = .setNewPassword
            } else {
                self.verifyUserAPI(tempID: self.userRegTempID!, otp: Int(text)!)
            }
        case .setNewPassword:
            let confirmText = self.setNewPassword.actualTextField.text ?? ""
            if text.isEmpty || confirmText.isEmpty {
                showError("Please fill all fields")
                return
            }
            if let error = text.passwordValidationError() {
                showError(error)
                return
            }
            if text != confirmText {
                showError("Passwords do not match")
                return
            }
            // Call Set Password API here
            self.setPasswordAPI(password: text)
        }
    }
}

extension OTPScreenVC: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if screenState == .setNewPassword && textField == otpField.actualTextField {
            self.setNewPassword.actualTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
