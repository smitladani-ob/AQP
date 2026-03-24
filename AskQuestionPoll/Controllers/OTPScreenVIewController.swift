//
//  OTPScreenVIewController.swift
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
    
    var userRegTempID: Int?
    var isForgotPassword: Bool = false
    var isEmailState: Bool = false
    //ScreenState
    var screenState: ScreenState = .otp
    var enteredEmail: String?
    var resetToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setupGlobalBackButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupUI() {
        submitButton.loginButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        resetFields()
        switch screenState {
        case .email:
            otpField.configure(labelText: "EMAIL", textFieldPlaceholder: "Enter Email")
            otpField.actualTextField.keyboardType = .emailAddress
            otpField.actualTextField.isSecureTextEntry = false
            setNewPassword.isHidden = true
            submitButton.config(text: "NEXT", textColor: .white)
        case .otp:
            otpField.configure(labelText: "OTP", textFieldPlaceholder: "Enter OTP")
            otpField.actualTextField.keyboardType = .numberPad
            otpField.actualTextField.isSecureTextEntry = false
            setNewPassword.isHidden = true
            submitButton.config(text: "VERIFY", textColor: .white)
        case .setNewPassword:
            otpField.configure(labelText: "NEW PASSWORD", textFieldPlaceholder: "Enter New Password")
            otpField.actualTextField.isSecureTextEntry = true
            setNewPassword.isHidden = false
            setNewPassword.configure(labelText: "CONFIRM PASSWORD", textFieldPlaceholder: "Confirm Password")
            setNewPassword.actualTextField.isSecureTextEntry = true
            submitButton.config(text: "SUBMIT", textColor: .white)
        }
    }
    
    func resetFields() {
        otpField.actualTextField.text = ""
        setNewPassword.actualTextField.text = ""
    }
    
    //This Calls When User Come from the SignUp
    func verifyUserAPI(tempID: Int, otp: Int) {
        let device = DeviceInfo()
        let request = VerifyUserRequest(
            userId: tempID,
            token: otp,
            device: device
        )
        let waitAlert = alert.showWait("Please Wait", subTitle: "",colorStyle: 0xFFEB3B)
        APIManager.sharedInstance.verifyUser(request: request) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                waitAlert.close()
                switch result {
                case .success(let response):
                    if response.code == 200 {
                        showSuccess(response.message ?? "Success")
                        print("JWT Token:", response.data?.token ?? "")
                        print("User Email:", response.data?.user?.email_id ?? "")
                        // Save token if needed
                        let token = response.data?.token
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        showError(response.message ?? "Verification Failed")
                    }
                case .failure(let error):
                    print(error)
                    showError("Something went wrong")
                }
            }
        }
    }
    
    //this validates email is in server or not
    func forgotPasswordAPI(email: String) {
        let waitAlert = alert.showWait("Please Wait", subTitle: "", colorStyle: 0xFFEB3B)
        let request = ForgotPasswordRequestModel(email_id: email)
        APIManager.sharedInstance.forgotPassword(request: request) { result in
            DispatchQueue.main.async {
                waitAlert.close()
                switch result {
                case .success(let response):
                    if response.code == 200 {
                        showSuccess(response.message ?? "Success")
                        self.isForgotPassword = true
                        self.screenState = .otp
                        self.setupUI()
                    } else {
                        showError(response.message ?? "Failed")
                    }
                case .failure:
                    showError("Something went wrong")
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
        let waitAlert = alert.showWait("Please Wait", subTitle: "", colorStyle: 0xFFEB3B)
        let request = VerifyForgotOTPRequest(email: email, token: otpInt)
        APIManager.sharedInstance.verifyForgotOTP(request: request) { result in
            DispatchQueue.main.async {
                waitAlert.close()
                switch result {
                case .success(let response):
                    if response.code == 200 {
                        showSuccess("Your OTP is verified successfully")
                        // Save token if needed
                        self.resetToken = response.data?.token
                        print("Reset Token:", self.resetToken ?? "")
                        self.screenState = .setNewPassword
                        self.setupUI()
                        print(response.message)
                    } else {
                        showError(response.message ?? "Verification Failed")
                    }
                case .failure(let error):
                    print(error)
                    showError("Something went wrong")
                }
            }
        }
    }
    
    //API CALL FOR GENERATE PASSWORD
    func setPasswordAPI(password: String) {
        guard let email = enteredEmail,   // FIXED
              let token = resetToken else {
            showError("Missing data")
            return
        }
        let waitAlert = alert.showWait("Please Wait", subTitle: "", colorStyle: 0xFFEB3B)
        let request = GenerateNewPasswordRequest(
            email: email,
            password: password,
            token: token
        )
        APIManager.sharedInstance.setNewPassword(request: request) { result in
            DispatchQueue.main.async {
                waitAlert.close()
                switch result {
                case .success(let response):
                    if response.code == 200 {
                        showSuccess(response.message ?? "Password Updated")
                        //  OPTIONAL CLEANUP (recommended)
                        self.resetToken = nil
                        self.enteredEmail = nil
                        self.screenState = .email
                        self.setupUI()
                        // Go back to Login
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        showError(response.message ?? "Failed")
                    }
                case .failure:
                    showError("Something went wrong")
                }
            }
        }
    }
    
    @objc func submitButtonTapped() {
        let text = otpField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        switch screenState {
        case .email:
            if text.isEmpty {
                showError("Please Enter Email")
                return
            }
            enteredEmail = text
            forgotPasswordAPI(email: text)

        case .otp:
            if text.isEmpty {
                showError("Please Enter OTP")
                return
            }
            if isForgotPassword {
                verifyForgotOTPAPI(otp: text)
                // Move to Set Password
                screenState = .setNewPassword
            } else {
                verifyUserAPI(tempID: userRegTempID!, otp: Int(text)!)
                // Signup flow → go back
                navigationController?.popToRootViewController(animated: true)
            }
            
        case .setNewPassword:
            let confirmText = setNewPassword.actualTextField.text ?? ""            
            if text.isEmpty || confirmText.isEmpty {
                showError("Please fill all fields")
                return
            }
            if text != confirmText {
                showError("Passwords do not match")
                return
            }
            // Call Set Password API here
            self.setPasswordAPI(password: text)
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

