//
//  SignUpVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 19/03/26.
//

import UIKit
import SCLAlertView

class SignUpVC: UIViewController {
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    
    @IBOutlet weak var emailTextField: AuthTextFieldView!
    @IBOutlet weak var passwordTextField: AuthTextFieldView!
    @IBOutlet weak var confirmPasswordTextField: AuthTextFieldView!
    @IBOutlet weak var radioButtonsField: RadioButtonsView!
    @IBOutlet weak var countryTextField: AuthTextFieldView!
    @IBOutlet weak var signUpbtn: yellowButtonView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var countries: [Country] = []
    let countryPicker = UIPickerView()
    var selectedGender: Gender?
    var selectedImage: UIImage?
    let picker = UIImagePickerController()
    var alertTitle = "Select Image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.allowsEditing = true
        //observer
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
        navigationController?.setupGlobalBackButton()
        self.setupUI()
        self.setupFields()
        self.setupButtonsOfScreen()
        if let response: CountryResponse = JSONloader("countryNames") {
            countries = response.countryJSON
        }
        self.setupCountryPicker()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupUI(){
        setCornerRadius(view: profileImageVIew,cornerRadius: profileImageVIew.frame.height/2)
        self.profileImageVIew.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        self.profileImageVIew.image = UIImage.profileAvtar
        self.profileImageVIew.addGestureRecognizer(tap)
    }
    
    @objc func profileImageTapped() {
        self.openImagePicker()
    }
    
    func openImagePicker() {
        let alert = UIAlertController(title: self.alertTitle, message: nil, preferredStyle: .actionSheet)
        // Camera
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        // Gallery
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        // Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(alert, animated: true)
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraNotAvailableAlert()
            return
        }
        self.picker.sourceType = .camera
        present(self.picker, animated: true)
    }
    
    func showCameraNotAvailableAlert() {
        let alert = UIAlertController(
            title: "Camera Not Available",
            message: "This device does not support camera.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func openGallery() {
        self.picker.sourceType = .photoLibrary
        present(self.picker, animated: true)
    }
    
    func setupFields(){
        self.emailTextField.actualTextField.delegate = self
        self.passwordTextField.actualTextField.delegate = self
        self.confirmPasswordTextField.actualTextField.delegate = self
        self.countryTextField.actualTextField.delegate = self
        self.emailTextField.configure(labelText: "EMAIL",textFieldPlaceholder: "Enter Email")
        self.passwordTextField.configure(labelText: "PASSWORD", textFieldPlaceholder: "Enter Password")
        self.passwordTextField.actualTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.configure(labelText: "CONFIRM PASSWORD", textFieldPlaceholder: "Enter Confirm Password")
        self.confirmPasswordTextField.actualTextField.isSecureTextEntry = true
        self.countryTextField.configure(labelText: "COUNTRY",textFieldPlaceholder: "Select Country", textFieldImageName: "dropdown_icon")
        self.countryTextField.actualTextField.isUserInteractionEnabled = true
        self.radioButtonsField.config(categoryName: "GENDER",itemOne: "MALE",itemTwo: "FEMALE",textcolor: UIColor.systemYellow,mode: .gender)
    }
    
    func setupCountryPicker() {
        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        // Attach picker to textfield
        self.countryTextField.actualTextField.inputView = countryPicker
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, done], animated: true)
        self.countryTextField.actualTextField.inputAccessoryView = toolbar
        // Optional: disable typing
        self.countryTextField.actualTextField.tintColor = .clear
        self.countryTextField.imgForTextField.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(countryIconTapped))
        self.countryTextField.imgForTextField.addGestureRecognizer(tap)
    }
    
    @objc func countryIconTapped() {
        print("tapped")
        self.countryTextField.actualTextField.becomeFirstResponder()
    }
    
    @objc func doneTapped() {
        let row = self.countryPicker.selectedRow(inComponent: 0)
        if self.countries.indices.contains(row) {
            let country = countries[row]
            self.countryTextField.actualTextField.text = "\(country.name)"
        }
        view.endEditing(true)
    }
    
    func setupButtonsOfScreen() {
        self.signUpbtn.config(text: "SIGNUP",textColor: UIColor.white, size: 0.048)
        self.signUpbtn.loginButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc func signUpTapped() {
        self.signUpValidation()
    }
    
    func signUpValidation() {
        let email = self.emailTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = self.passwordTextField.actualTextField.text ?? ""
        let confirmPassword = self.confirmPasswordTextField.actualTextField.text ?? ""
        self.selectedGender = radioButtonsField.selectedGender
        let country = self.countryTextField.actualTextField.text ?? ""
        //check email,password,Confirm PassWord,country
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || country.isEmpty {
            showError("Please fill all required fields")
            return
        }
        if selectedImage == nil {
            showError("Please select a profile image")
            return
        }
        if let emailError = email.emailValidationError() {
            showError(emailError)
            return
        }
        // Strong password validation
        if let pwError = password.passwordValidationError() {
            showError(pwError)
            return
        }
        //check passwords matches or not
        if password != confirmPassword {
            showError("Passwords do not match")
            return
        }
        //check gender is selected or not
        if self.selectedGender == nil {
            showError("Please select gender")
            return
        }
        self.signUpAPI(email: email, password: password, gender: selectedGender!, country: country, url: signupUrl)
    }
    
    func signUpAPI(email: String,password: String,gender: Gender,country: String,url: String) {
        showWait()
        let user = UserData(first_name: nil,last_name: nil,email_id: email,password: password,gender: gender,country: country)
        let request = SignUpRequestModel(request_data: user)
        APIManager.sharedInstance.signUp(request: request, image: selectedImage) { response, error, isSuccess in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hideWait()
                if isSuccess {
                    let tempId = response?.data?.user_reg_temp_id ?? 0
                    showSuccess(response?.message ?? "Success")
                    print("Temp ID:", tempId)
                    // Navigate next screen if needed
                    self.navigateToOtp(tempId: tempId)
                } else {
                    print(error ?? "")
                    showError(error ?? "Something went wrong")
                }
            }
        }
    }
    
    func navigateToOtp(tempId: Int) {
        let vc = storyboardOfMain.instantiateViewController(withIdentifier: "OTPScreenVC") as! OTPScreenVC
        vc.userRegTempID = tempId
        vc.screenState = .otp
        vc.isForgotPassword = false
        vc.modalTransitionStyle = .crossDissolve
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileImageVIew.image = image
            self.alertTitle = "Replace Image"
            self.selectedImage = image
        }
        dismiss(animated: true)
    }
}

extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = countries[row]
        print(country)
        return "\(country.name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = self.countries[row]
        self.countryTextField.actualTextField.text = selected.name
    }
}

extension SignUpVC {
    //KeyBoard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let keyboardHeight = keyboardFrame.height
        self.scrollView.contentInset.bottom = keyboardHeight
        self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}


extension SignUpVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields: [UITextField] = [
            self.emailTextField.actualTextField,
            self.passwordTextField.actualTextField,
            self.confirmPasswordTextField.actualTextField,
            self.countryTextField.actualTextField
        ]
        if let index = fields.firstIndex(of: textField), index < fields.count - 1 {
            fields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
