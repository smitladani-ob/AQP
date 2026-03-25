//
//  AddQuestionVC.swift
//  AskQuestionPoll
//
//  Created by OBMac-7 on 21/03/26.
//

import UIKit

enum ImageSelectionType {
    case optionOne
    case optionTwo
}

enum PickerType {
    case category
    case location
    case gender
}

class AddQuestionVC: UIViewController {
    
    //first container
    @IBOutlet weak var underLineTextView: UIView!
    @IBOutlet weak var charCounter: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textViewField: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var selectorImage: UIImageView!
    @IBOutlet weak var hiderImage: UIImageView!
    @IBOutlet weak var selectCategoryField: SelectCatagoryView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    //second Container
    @IBOutlet weak var chooseOption: RadioButtonsView!
    @IBOutlet weak var optionsView: OptionsView!
    
    //Third Container
    @IBOutlet weak var prefernceLabel: UILabel!
    @IBOutlet weak var chooseLocationField: SelectCatagoryView!
    @IBOutlet weak var afterLocationLbl: UILabel!
    @IBOutlet weak var chooseGenderField: SelectCatagoryView!
    @IBOutlet weak var afterGenderLbl: UILabel!
    
    //Fourth Container
    @IBOutlet weak var submitButton: yellowButtonView!
    @IBOutlet weak var previewButton: yellowButtonView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let categories: [(name: String, id: Int)] = [
        ("World Affairs", 3),
        ("Entertainment", 4),
        ("Geography", 5),
        ("History", 6),
        ("Wildlife", 2),
        ("Trending News", 1)
    ]
    var countries: [Country] = []
    let pickerView = UIPickerView()
    let picker = UIImagePickerController()
    var selectedCategoryId: Int?
    
    var currentImageSelection: ImageSelectionType?
    //To Save Image
    var optionOneSelectedImage: UIImage?
    var optionTwoSelectedImage: UIImage?
    //To Save Text
    var optionOneText: String?
    var optionTwoText: String?
    
    var alertTitle = "Select Image"
    var currentPickerType: PickerType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        setupView()
        setupPicker()
        if let response: CountryResponse = JSONLoader.load("countryNames") {
            countries = response.countryJSON
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        selectorImage.isUserInteractionEnabled = true
        selectorImage.addGestureRecognizer(tap)
        picker.delegate = self
        picker.allowsEditing = true
        //observer
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    func setupView() {
        //First Container
        let custFont = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth))
        selectCategoryField.configure(placeHolder: "select category", imageName: "dropdown_icon")
        questionLabel.text = "QUESTIONS"
        questionLabel.textColor = UIColor.systemYellow
        questionLabel.font = custFont
        descriptionLabel.text = "DESCRIPTION"
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = custFont
        selectorImage.setBorder(color: UIColor.white.cgColor, width: 2)
        selectorImage.image = UIImage(named: "selector_image")
        charCounter.text = "0/200"
        charCounter.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.038 * screenWidth))
        charCounter.textColor = UIColor.white
        
        //Second Container
        optionsView.optionOneTextview.delegate = self
        optionsView.optionTwoTextview.delegate = self
        chooseOption.config(categoryName: "OPTIONS",itemOne: "TEXT",itemTwo: "IMAGE",textcolor: UIColor.white,mode: .options)
        let bigLabel = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.052 * screenWidth))
        let smlLabel = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.042 * screenWidth))
        optionsView.optionOneLOne.font = bigLabel
        optionsView.optionOneLTwo.font = smlLabel
        optionsView.optionTwoLOne.font = bigLabel
        optionsView.optionTwoLTwo.font = smlLabel
        optionsView.optionOneBtn.addTarget(self, action: #selector(optionOneTapped), for: .touchUpInside)
        optionsView.optionTwoBtn.addTarget(self, action: #selector(optionTwoTapped), for: .touchUpInside)
        chooseOption.onSelectionChanged = { [weak self] in
            guard let self = self else { return }
            switch self.chooseOption.selectedOptionType {
            case .text:
                self.handleTextOption()
            case .image:
                self.handleImageOption()
            }
        }
        if chooseOption.selectedOptionType == .text {
                handleTextOption()
            } else {
                handleImageOption()
        }
        
        //Third Container
        prefernceLabel.text = "PREFERENCES"
        prefernceLabel.textColor = UIColor.systemYellow
        prefernceLabel.font = custFont
        chooseLocationField.configure(placeHolder: "select location", imageName: "dropdown_icon")
        chooseGenderField.configure(placeHolder: "select gender", imageName: "dropdown_icon")
        afterLocationLbl.font = smlLabel
        afterGenderLbl.font = smlLabel
        
        //Buttons
        submitButton.config(text: "SUBMIT",textColor: UIColor.black)
        submitButton.loginButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        previewButton.config(text: "PREVIEW",textColor: UIColor.black)
        previewButton.loginButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        selectCategoryField.onTap = { [weak self] in
            self?.selectCategoryField.textFIeld.becomeFirstResponder()
        }

        chooseLocationField.onTap = { [weak self] in
            self?.chooseLocationField.textFIeld.becomeFirstResponder()
        }

        chooseGenderField.onTap = { [weak self] in
            self?.chooseGenderField.textFIeld.becomeFirstResponder()
        }
    }
    
    func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self

        // Attach same picker to all fields
        selectCategoryField.textFIeld.inputView = pickerView
        chooseLocationField.textFIeld.inputView = pickerView
        chooseGenderField.textFIeld.inputView = pickerView

        // Set delegates to detect active field
        selectCategoryField.textFIeld.delegate = self
        chooseLocationField.textFIeld.delegate = self
        chooseGenderField.textFIeld.delegate = self

        addToolbar()
    }
    
    
    //When Text Selected
    func handleTextOption() {
        optionsView.optionOneTextview.text = optionOneText ?? ""
        optionsView.optionTwoTextview.text = optionTwoText ?? ""
        optionsView.optionOneImageBg.image = UIImage.optionButton
        optionsView.optionTwoImageBg.image = UIImage.optionButton
        optionsView.optionOneTextview.isHidden = false
        optionsView.optionTwoTextview.isHidden = false
        optionsView.optionOneView.isHidden = !(optionOneText?.isEmpty ?? true)
        optionsView.optionTwoView.isHidden = !(optionTwoText?.isEmpty ?? true)
        optionsView.optionOneBtn.isHidden = true
        optionsView.optionTwoBtn.isHidden = true
    }

    //When Image Selected
    func handleImageOption() {
        optionsView.optionOneImageBg.image = optionOneSelectedImage ?? UIImage.image1
        optionsView.optionTwoImageBg.image = optionTwoSelectedImage ?? UIImage.image2
        
        optionsView.optionOneTextview.isHidden = true
        optionsView.optionTwoTextview.isHidden = true
        optionsView.optionOneView.isHidden = true
        optionsView.optionTwoView.isHidden = true
        optionsView.optionOneBtn.isHidden = false
        optionsView.optionTwoBtn.isHidden = false
    }
    
    @objc func catagoryTapped() {
        selectCategoryField.textFIeld.becomeFirstResponder()
    }
    
    func addToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.setItems([done], animated: true)
        selectCategoryField.textFIeld.inputAccessoryView = toolbar
        chooseLocationField.textFIeld.inputAccessoryView = toolbar
        chooseGenderField.textFIeld.inputAccessoryView = toolbar
    }

    @objc func doneTapped() {
        let row = pickerView.selectedRow(inComponent: 0)
        switch currentPickerType {
        case .category:
            let selected = categories[row]
            selectCategoryField.textFIeld.text = selected.name
            selectedCategoryId = selected.id
        case .location:
            if countries.indices.contains(row) {
                let selected = countries[row]
                chooseLocationField.textFIeld.text = selected.name
            }
        case .gender:
            let genders = ["Male", "Female"]
            chooseGenderField.textFIeld.text = genders[row]
        case .none:
            break
        }
        view.endEditing(true)
    }
    
    @objc func optionOneTapped() {
        currentImageSelection = .optionOne
        openImagePicker()
    }

    @objc func optionTwoTapped() {
        currentImageSelection = .optionTwo
        openImagePicker()
    }
    
    @objc func openImagePicker() {
        if optionsView.optionOneImageBg.image == UIImage.image1 || optionsView.optionTwoImageBg.image == UIImage.image2 {
            self.alertTitle = "Select Image"
        }
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
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
            popover.sourceRect = CGRect(x: self.view.bounds.midX,y: self.view.bounds.midY,width: 0,height: 0)
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
        let alert = UIAlertController(title: "Camera Not Available",message: "This device does not support camera.",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showGalleryNotAvailableAlert()
            return
        }
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func showGalleryNotAvailableAlert() {
        let alert = UIAlertController(title: "Gallery Not Available",message: "Photo library is not accessible.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func submitButtonTapped(_ sender: UIButton) {
        if let errorMessage = validateHomeScreen() {
            showError(errorMessage)
            return
        }
        // Prepare request model
        let request = AddQuestionRequest(
            category_id: selectedCategoryId,
            country: chooseLocationField.textFIeld.text,
            gender: chooseGenderField.textFIeld.text == "Male" ? 1 : 2,
            description: descriptionTextView.text,
            option_type: chooseOption.selectedOptionType == .text ? 1 : 2,
            option1: optionsView.optionOneTextview.isHidden ? nil : optionsView.optionOneTextview.text,
            option2: optionsView.optionTwoTextview.isHidden ? nil : optionsView.optionTwoTextview.text
        )
        // Prepare images
        let images = AddQuestionImages(
            questionImage: selectorImage.image,
            option1Image: optionOneSelectedImage,
            option2Image: optionTwoSelectedImage
        )
        // Call API
        APIManager.sharedInstance.addQuestion(requestModel: request, images: images) { result in
            switch result {
            case .success(let response):
                showSuccess(response.message ?? "Question added successfully")
            case .failure(let error):
                showError(error.localizedDescription)
            }
        }
    }
    
    @objc func previewButtonTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewScreenVC") as! PreviewScreenVC
        vc.descriptionText = descriptionTextView.text
        vc.optionType = chooseOption.selectedOptionType
        vc.option1Text = optionOneText
        vc.option2Text = optionTwoText
        vc.option1Image = optionOneSelectedImage ?? UIImage.image1
        vc.option2Image = optionTwoSelectedImage ?? UIImage.image2
        vc.questionImage = selectorImage.image
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AddQuestionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currentPickerType {
        case .category:
            return categories.count
        case .location:
            return countries.count
        case .gender:
            return 2
        case .none:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentPickerType {
        case .category:
            return categories[row].name
        case .location:
            return countries[row].name
        case .gender:
            return ["Male", "Female"][row]
        case .none:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentPickerType {
        case .category:
            let selected = categories[row]
            selectCategoryField.textFIeld.text = selected.name
            selectedCategoryId = selected.id
        case .location:
            if countries.indices.contains(row) {
                let selected = countries[row]
                chooseLocationField.textFIeld.text = selected.name
            }
        case .gender:
            let genders = ["Male", "Female"]
            chooseGenderField.textFIeld.text = genders[row]
            
        case .none:
            break
        }
    }
}

extension AddQuestionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        guard let image = selectedImage else {
            picker.dismiss(animated: true)
            return
        }
        switch currentImageSelection {
        case .optionOne:
            optionsView.optionOneImageBg.image = image
            optionOneSelectedImage = image
        case .optionTwo:
            optionsView.optionTwoImageBg.image = image
            optionTwoSelectedImage = image
        case .none:
            // fallback (your top selector image)
            selectorImage.image = image
            hiderImage.isHidden = true
        }
        self.alertTitle = "Replace Image"
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddQuestionVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectCategoryField.textFIeld {
            currentPickerType = .category
        } else if textField == chooseLocationField.textFIeld {
            currentPickerType = .location
        } else if textField == chooseGenderField.textFIeld {
            currentPickerType = .gender
        }
        pickerView.reloadAllComponents()
    }
}

extension AddQuestionVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        if textView == descriptionTextView {
            charCounter.text = "\(count)/200"
            updateTextViewHeight(textView, heightConstraint: descriptionHeight, maxHeight: .infinity)
        } else if textView == optionsView.optionOneTextview {
            optionOneText = textView.text
            updateTextViewHeight(textView, heightConstraint: optionsView.optionOneHeight, maxHeight: CGFloat((textView.superview?.frame.height)!))
        } else if textView == optionsView.optionTwoTextview {
            optionTwoText = textView.text
            updateTextViewHeight(textView, heightConstraint: optionsView.optionTwoHeight, maxHeight: 100)
        }
    }
    
    func textView(_ textView: UITextView,shouldChangeTextIn range: NSRange,replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        }
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if textView == optionsView.optionOneTextview || textView == optionsView.optionTwoTextview {
            if textView.text.count == 30 {
                showError("You are reach the maximum limit of 30 characters")
                textView.resignFirstResponder()
            }
            return updatedText.count <= 30
        }
        if textView == descriptionTextView {
            if textView.text.count == 200 {
                showError("You are reach the maximum limit of 200 characters")
                textView.resignFirstResponder()
            }
        }
        return updatedText.count <= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == optionsView.optionOneTextview {
            optionsView.optionOneView.isHidden = true
        } else if textView == optionsView.optionTwoTextview {
            optionsView.optionTwoView.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == optionsView.optionOneTextview {
            optionsView.optionOneView.isHidden = !textView.text.isEmpty
        } else if textView == optionsView.optionTwoTextview {
            optionsView.optionTwoView.isHidden = !textView.text.isEmpty
        }
    }
    
    func updateTextViewHeight(_ textView: UITextView, heightConstraint: NSLayoutConstraint, maxHeight: CGFloat = 120) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        heightConstraint.constant = min(estimatedSize.height, maxHeight)
    }
}

extension AddQuestionVC {
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


extension AddQuestionVC {
    
    func validateHomeScreen() -> String? {
        let descriptionText = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let option1Text = optionsView.optionOneTextview.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let option2Text = optionsView.optionTwoTextview.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let categoryText = selectCategoryField.textFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let locationText = chooseLocationField.textFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let genderText = chooseGenderField.textFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        // All fields empty
        if (categoryText?.isEmpty ?? true) && (descriptionText?.isEmpty ?? true) && (option1Text?.isEmpty ?? true) && (option2Text?.isEmpty ?? true) &&
            optionOneSelectedImage == nil && optionTwoSelectedImage == nil && (locationText?.isEmpty ?? true) && (genderText?.isEmpty ?? true) {
            return "Please enter all details"
        }
        // Individual field validations
        if categoryText?.isEmpty ?? true {
            return "Choose Category"
        }
        if descriptionText?.isEmpty ?? true {
            return "Fill Description"
        }
        if optionsView.optionOneTextview.isHidden == false && (option1Text?.isEmpty ?? true) {
            return "Fill Option 1 data"
        }
        if optionsView.optionTwoTextview.isHidden == false && (option2Text?.isEmpty ?? true) {
            return "Fill Option 2 data"
        }
        if optionsView.optionOneBtn.isHidden == false && optionOneSelectedImage == nil {
            return "Select Option 1 Image"
        }
        if optionsView.optionTwoBtn.isHidden == false && optionTwoSelectedImage == nil {
            return "Select Option 2 Image"
        }
        if locationText?.isEmpty ?? true {
            return "Select Country"
        }
        if genderText?.isEmpty ?? true {
            return "Select Gender"
        }
        return nil
    }
    
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Validation", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
