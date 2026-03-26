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
    @IBOutlet weak var heightOfField: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var countries: [Country] = []
    let countryPicker = UIPickerView()
    var selectedGender: Gender?
    var selectedImage: UIImage?
    let picker = UIImagePickerController()
    var alertTitle = "Select Image"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.allowsEditing = true
        
        //observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        navigationController?.setupGlobalBackButton()
        self.setupUI()
        self.setupFields()
        self.setupButtonsOfScreen()
        if let response: CountryResponse = JSONLoader.load("countryNames") {
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if isSmallScreen {
//            heightOfField.constant = screenWidth * 0.240
//        }
    }
    
    func setupUI(){
        profileImageVIew.setCornerRadius(cornerRadius: profileImageVIew.frame.height/2)
        profileImageVIew.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageVIew.image = UIImage.profileAvtar
        profileImageVIew.addGestureRecognizer(tap)
    }
    
    @objc func profileImageTapped() {
        openImagePicker()
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
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0,
                                        height: 0)
            popover.permittedArrowDirections = []
        }
        present(alert, animated: true)
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraNotAvailableAlert()
            return
        }
        picker.sourceType = .camera
        present(picker, animated: true)
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
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func setupFields(){
        emailTextField.actualTextField.delegate = self
        passwordTextField.actualTextField.delegate = self
        confirmPasswordTextField.actualTextField.delegate = self
        countryTextField.actualTextField.delegate = self
        
        emailTextField.configure(labelText: "EMAIL",textFieldPlaceholder: "Enter Email")
        
        passwordTextField.configure(labelText: "PASSWORD", textFieldPlaceholder: "Enter Password")
        passwordTextField.actualTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.configure(labelText: "CONFIRM PASSWORD", textFieldPlaceholder: "Enter Confirm Password")
        confirmPasswordTextField.actualTextField.isSecureTextEntry = true
        
        countryTextField.configure(labelText: "COUNTRY",textFieldPlaceholder: "Select Country", textFieldImageName: "dropdown_icon")
        countryTextField.actualTextField.isUserInteractionEnabled = true
    
        radioButtonsField.config(categoryName: "GENDER",itemOne: "MALE",itemTwo: "FEMALE",textcolor: UIColor.systemYellow,mode: .gender)
    }
    
    func setupCountryPicker() {
        countryPicker.delegate = self
        countryPicker.dataSource = self
        // Attach picker to textfield
        countryTextField.actualTextField.inputView = countryPicker
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, done], animated: true)
        countryTextField.actualTextField.inputAccessoryView = toolbar
        // Optional: disable typing
        countryTextField.actualTextField.tintColor = .clear
        countryTextField.imgForTextField.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(countryIconTapped))
        countryTextField.imgForTextField.addGestureRecognizer(tap)
    }
    
    @objc func countryIconTapped() {
        print("tapped")
        countryTextField.actualTextField.becomeFirstResponder()
    }
    
    @objc func doneTapped() {
        let row = countryPicker.selectedRow(inComponent: 0)
        if countries.indices.contains(row) {
            let country = countries[row]
            countryTextField.actualTextField.text = "\(country.name)"
        }
        view.endEditing(true)
    }
    
    func setupButtonsOfScreen() {
        signUpbtn.config(text: "SIGN UP",textColor: UIColor.white)
        signUpbtn.loginButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc func signUpTapped() {
        self.signUpValidation()
    }
    
    func signUpValidation() {
        let email = emailTextField.actualTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.actualTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.actualTextField.text ?? ""
        selectedGender = radioButtonsField.selectedGender
        let country = countryTextField.actualTextField.text ?? ""
        
        //check email,password,Confirm PassWord,country
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || country.isEmpty {
            showError("Please fill all required fields")
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
        if selectedGender == nil {
            showError("Please select gender")
            return
        }
        self.signUpAPI(email: email, password: password, gender: selectedGender!, country: country, url: signupUrl)
    }
    
    func signUpAPI(email: String,password: String,gender: Gender,country: String,url: String) {
        let waitAlert = alert.showWait("Please Wait", subTitle: "",colorStyle: 0xFFEB3B)
        let user = UserData(first_name: nil,last_name: nil,email_id: email,password: password,gender: gender,country: country)
        let request = SignUpRequestModel(request_data: user)
        APIManager.sharedInstance.signUp(request: request, image: selectedImage, urlString: url) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                waitAlert.close()
                switch result {
                case .success(let response):
                    if response.code == 200 {
                        let tempId = response.data?.user_reg_temp_id ?? 0
                        showSuccess(response.message ?? "Success")
                        print("Temp ID:", response.data?.user_reg_temp_id ?? 0)
                        // Navigate next screen if needed
                        self.navigateToOtp(tempId: tempId)
                        
                    } else {
                        showError(response.message ?? "Signup Failed")
                    }
                case .failure(let error):
                    print(error)
                    showError("Something went wrong")
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
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageVIew.image = image
            self.alertTitle = "Replace Image"
            selectedImage = image
        }
        dismiss(animated: true)
    }
}

extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = countries[row]
        print(country)
        return "\(country.name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = countries[row]
        countryTextField.actualTextField.text = selected.name
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
