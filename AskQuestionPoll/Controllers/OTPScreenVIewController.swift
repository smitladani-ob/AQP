//
//  OTPScreenVIewController.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 20/03/26.
//

import UIKit

class OTPScreenVIewController: UIViewController {

    @IBOutlet weak var submitButton: yellowButtonView!
    @IBOutlet weak var otpField: AuthTextFieldView!
    
    var userRegTempID: Int?
    
    var isForgotPassword: Bool = false
    var isEmailState: Bool = false
    
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
        if isForgotPassword && isEmailState {
            otpField.configure(labelText: "EMAIL", textFieldPlaceholder: "Enter Email")
            otpField.iconImage.isHidden = true
            otpField.imgForTextField.isHidden = true
            submitButton.config(text: "NEXT")
            submitButton.loginButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        } else {
            otpField.configure(labelText: "OTP", textFieldPlaceholder: "Enter OTP")
            otpField.iconImage.isHidden = true
            otpField.actualTextField.keyboardType = .numberPad
            otpField.imgForTextField.isHidden = true
            submitButton.config(text: "OK")
            submitButton.loginButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        }
        
    }
    
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
                        // Now switch UI to OTP mode
                        self.isForgotPassword = false
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
    
    func verifyForgotOTPAPI(otp: String) {
        guard let email = otpField.actualTextField.text, !email.isEmpty else {
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
                        showSuccess(response.message ?? "Success")
                        //  IMPORTANT: Save token for reset password
                        let resetToken = response.data?.token
                        // Go to Set Password Screen
                        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "SetPasswordViewController") as! SetPasswordViewController
                        vc.resetToken = resetToken   // pass token
                        vc.navigationItem.backButtonTitle = ""
                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func submitButtonTapped() {
        let text = otpField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if isForgotPassword && isEmailState {
            if text.isEmpty {
                showError("Please Enter Email")
                return
            }
            forgotPasswordAPI(email: text)
        } else if isForgotPassword && !isEmailState {
            verifyForgotOTPAPI(otp: text)
        } else {
            if text.isEmpty {
                showError("Please Enter OTP")
                return
            }
            verifyUserAPI(tempID: userRegTempID!, otp: Int(text)!)
        }
    }
}
