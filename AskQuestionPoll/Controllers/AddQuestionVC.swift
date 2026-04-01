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
    
    let categories: [(name: String, id: Int)] = [("World Affairs", 3),("Entertainment", 4),("Geography", 5),("History", 6),("Wildlife", 2),("Trending News", 1)]
    var countries: [Country] = []
    var pickerView = UIPickerView()
    var toolbarTitleLabel = UILabel()
    let imagePicker = UIImagePickerController()
    var currentImageSelection: ImageSelectionType?// Which Image Select OptionOne And OptionTwo for imagePicker
    var currentPickerType: PickerType? // Which picker is Use for Picker
    var selectedCategoryId: Int? //selected Category
    //To Save Image
    var selectedQuestionImage: UIImage?
    var optionOneSelectedImage: UIImage?
    var optionTwoSelectedImage: UIImage?
    //To Save Text
    var optionOneText: String?
    var optionTwoText: String?
    var alertTitle = "Select Image"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.delegate = self
        self.setupView()
        self.setupPicker()
        if let response: CountryResponse = JSONloader("countryNames") {
            self.countries = response.countryJSON
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.topImageTapped))
        self.selectorImage.isUserInteractionEnabled = true
        self.selectorImage.addGestureRecognizer(tap)
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.scrollView.keyboardDismissMode = .onDrag
        //observer
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        //First Container
        let custFont = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.048 * screenWidth),type: .DEFAULT)
        self.selectCategoryField.configure(placeHolder: "select category", imageName: "dropdown_icon", fontsize: 0.048)
        self.questionLabel.text = "QUESTIONS"
        self.questionLabel.textColor = UIColor.systemYellow
        self.questionLabel.font = custFont
        self.descriptionLabel.text = "DESCRIPTION"
        self.descriptionLabel.textColor = UIColor.white
        self.descriptionLabel.font = custFont
        self.selectorImage.image = UIImage(named: "selector_image")
        self.charCounter.text = "0/200"
        self.charCounter.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.038 * screenWidth), type: .DEFAULT)
        self.charCounter.textColor = UIColor.white
        self.underLineTextView.backgroundColor = .white
        
        //Second Container
        self.optionsView.optionOneTextview.delegate = self
        self.optionsView.optionTwoTextview.delegate = self
        self.chooseOption.config(categoryName: "OPTIONS",itemOne: "TEXT",itemTwo: "IMAGE",textcolor: UIColor.white,mode: .options)
        let bigLabel = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.052 * screenWidth), type: .DEFAULT)
        let smlLabel = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.042 * screenWidth), type: .DEFAULT)
        self.chooseOption.imgOptionOne.tintColor = UIColor.white
        self.chooseOption.imgOptionTwo.tintColor = UIColor.white
        self.optionsView.optionOneLOne.font = bigLabel
        self.optionsView.optionOneLTwo.font = smlLabel
        self.optionsView.optionTwoLOne.font = bigLabel
        self.optionsView.optionTwoLTwo.font = smlLabel
        self.optionsView.optionOneBtn.addTarget(self, action: #selector(optionOneTapped), for: .touchUpInside)
        self.optionsView.optionTwoBtn.addTarget(self, action: #selector(optionTwoTapped), for: .touchUpInside)
        self.chooseOption.onSelectionChanged = { [weak self] in
            guard let self = self else { return }
            switch self.chooseOption.selectedOptionType {
            case .text:
                self.handleTextOption()
            case .image:
                self.handleImageOption()
            }
        }
        if self.chooseOption.selectedOptionType == .text {
                self.handleTextOption()
            } else {
                self.handleImageOption()
        }
        //Third Container
        prefernceLabel.text = "PREFERENCES"
        prefernceLabel.textColor = UIColor.systemYellow
        prefernceLabel.font = custFont
        chooseLocationField.configure(placeHolder: "select location", imageName: "dropdown_icon", fontsize: 0.048)
        chooseGenderField.configure(placeHolder: "select gender", imageName: "dropdown_icon", fontsize: 0.048)
        afterLocationLbl.font = smlLabel
        afterGenderLbl.font = smlLabel
        //Buttons
        submitButton.config(text: "SUBMIT",textColor: UIColor.black, size: 0.048)
        submitButton.loginButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        previewButton.config(text: "PREVIEW",textColor: UIColor.black, size: 0.048)
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
        var fields = [selectCategoryField,chooseLocationField,chooseGenderField]
        for field in fields {
            field!.textFIeld.inputView = pickerView
            field!.textFIeld.delegate = self
            field!.textFIeld.tintColor = .clear
        }
        addToolbar()
    }
    
    //When Text Selected
    func handleTextOption() {
        // Restore previously typed text (preserved in optionOneText/optionTwoText)
        optionsView.optionOneTextview.text = optionOneText ?? ""
        optionsView.optionTwoTextview.text = optionTwoText ?? ""
        // Reset background images to default button style
        optionsView.optionOneImageBg.image = UIImage.optionButton
        optionsView.optionTwoImageBg.image = UIImage.optionButton
        // Show text views
        optionsView.optionOneTextview.isHidden = false
        optionsView.optionTwoTextview.isHidden = false
        // Show placeholder view only if text is empty
        optionsView.optionOneView.isHidden = !(optionOneText?.isEmpty ?? true)
        optionsView.optionTwoView.isHidden = !(optionTwoText?.isEmpty ?? true)
        // Hide image picker buttons (not needed in text mode)
        optionsView.optionOneBtn.isHidden = true
        optionsView.optionTwoBtn.isHidden = true
    }

    //When Image Selected
    func handleImageOption() {
        // Show selected image or default placeholder
        optionsView.optionOneImageBg.image = optionOneSelectedImage ?? UIImage.image1
        optionsView.optionTwoImageBg.image = optionTwoSelectedImage ?? UIImage.image2
        // Hide text views (not needed in image mode)
        optionsView.optionOneTextview.isHidden = true
        optionsView.optionTwoTextview.isHidden = true
        // Hide placeholder views
        optionsView.optionOneView.isHidden = true
        optionsView.optionTwoView.isHidden = true
        // Show image picker buttons
        optionsView.optionOneBtn.isHidden = false
        optionsView.optionTwoBtn.isHidden = false
    }
    
    @objc func catagoryTapped() {
        selectCategoryField.textFIeld.becomeFirstResponder()
    }
    
    func addToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbarTitleLabel.font = .systemFont(ofSize: 14, weight: .light)
        toolbarTitleLabel.textColor = .systemGray
        toolbarTitleLabel.textAlignment = .center
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let titleItem = UIBarButtonItem(customView: toolbarTitleLabel)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.items = [space, titleItem, space, done]
        selectCategoryField.textFIeld.inputAccessoryView = toolbar
        chooseLocationField.textFIeld.inputAccessoryView = toolbar
        chooseGenderField.textFIeld.inputAccessoryView = toolbar
    }

    @objc func doneTapped() {
        let row = pickerView.selectedRow(inComponent: 0)
        switch currentPickerType {
        case .category:
            let selected = categories[row]
            selectCategoryField.textFIeld.text = selected.name.lowercased()
            selectedCategoryId = selected.id
        case .location:
            if countries.indices.contains(row) {
                let selected = countries[row]
                chooseLocationField.textFIeld.text = selected.name.lowercased()
            }
        case .gender:
            let genders = ["Male", "Female"]
            chooseGenderField.textFIeld.text = genders[row].lowercased()
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
    
    @objc func topImageTapped() {
        currentImageSelection = nil
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
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
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
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func showGalleryNotAvailableAlert() {
        let alert = UIAlertController(title: "Gallery Not Available",message: "Photo library is not accessible.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func clearAllFields() {
        // 1. Clear text fields
        descriptionTextView.text = ""
        descriptionHeight.constant = 35
        chooseLocationField.textFIeld.text = ""
        chooseGenderField.textFIeld.text = ""
        selectCategoryField.textFIeld.text = ""
        // 2. Clear state variables
        selectedCategoryId = nil
        optionOneText = nil
        optionTwoText = nil
        optionOneSelectedImage = nil
        optionTwoSelectedImage = nil
        selectedQuestionImage = nil
        // 3. Reset main question image
        selectorImage.image = UIImage(named: "selector_image")
        hiderImage.isHidden = false
        charCounter.text = "0/200"
        // 4. Reset options views using existing helpers (this fixes the image backgrounds!)
        if chooseOption.selectedOptionType == .text {
            handleTextOption()
        } else {
            handleImageOption()
        }
        // Dismiss keyboard
        view.endEditing(true)
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
        // Prepare images — send only the user-selected question image, not the placeholder
        let images = AddQuestionImages(questionImage: selectedQuestionImage,option1Image: optionOneSelectedImage,option2Image: optionTwoSelectedImage)
        // Call API
        APIManager.sharedInstance.addQuestion(requestModel: request, images: images) { response, error, isSuccess in
            if isSuccess {
                firstTabNeedsRefresh = true
                fourthTabNeedsRefresh = true
                showSuccess(response?.message ?? "Question added successfully")
                self.clearAllFields()
            } else {
                showError(error ?? "Something went wrong")
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
        if let errorMessage = validateHomeScreen() {
            showError(errorMessage)
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            selectCategoryField.textFIeld.text = selected.name.lowercased()
            selectedCategoryId = selected.id
        case .location:
            if countries.indices.contains(row) {
                let selected = countries[row]
                chooseLocationField.textFIeld.text = selected.name.lowercased()
            }
        case .gender:
            let genders = ["Male", "Female"]
            chooseGenderField.textFIeld.text = genders[row].lowercased()
            
        case .none:
            break
        }
    }
}

extension AddQuestionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
            selectedQuestionImage = image
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
            toolbarTitleLabel.text = "Choose Category"
        } else if textField == chooseLocationField.textFIeld {
            currentPickerType = .location
            toolbarTitleLabel.text = "Choose Location"
        } else if textField == chooseGenderField.textFIeld {
            currentPickerType = .gender
            toolbarTitleLabel.text = "Choose Gender"
        }
        pickerView.reloadAllComponents()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // Option 1 & 2 limit: 30
        if textView == optionsView.optionOneTextview || textView == optionsView.optionTwoTextview {
            if updatedText.count > 30 {
                showError("You have reached the maximum limit of 30 characters")
                textView.resignFirstResponder()
            }
        }
        // Description limit: 200
        if textView == descriptionTextView {
            if updatedText.count > 200 {
                showError("You have reached the maximum limit of 200 characters")
                textView.resignFirstResponder()
            }
        }
        return true
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
        if selectedQuestionImage == nil {
            return "Please select a question image"
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
}
