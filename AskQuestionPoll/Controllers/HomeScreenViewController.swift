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
    @IBOutlet weak var hiderImage: UIImageView!
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
    
    let categories: [(name: String, id: Int)] = [
        ("World Affairs", 3),
        ("Entertainment", 4),
        ("Geography", 5),
        ("History", 6),
        ("Wildlife", 2),
        ("Trending News", 1)
    ]
    let categoryPicker = UIPickerView()
    let picker = UIImagePickerController()
    var selectedCategoryId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        setupView()
        setupCategoryPicker()
        let tap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        selectorImage.isUserInteractionEnabled = true
        selectorImage.addGestureRecognizer(tap)
        picker.delegate = self
        picker.allowsEditing = true
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
        selectorImage.layer.borderWidth = 2
        selectorImage.layer.borderColor = UIColor.white.cgColor
        selectorImage.image = UIImage(named: "selector_image")
        charCounter.text = "0/200"
        charCounter.font = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.038 * screenWidth))
        charCounter.textColor = UIColor.white
        
        //Second Container
        optionsView.config(categoryName: "OPTIONS", itemOne: "TEXT", itemTwo: "IMAGE",textcolor: UIColor.white)
        let bigLabel = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.052 * screenWidth))
        let smlLabel = UIFont(name: "SFAtarianSystemExtended", size: CGFloat(0.042 * screenWidth))
        optionOneLOne.font = bigLabel
        optionOneLTwo.font = smlLabel
        optionTwoLOne.font = bigLabel
        optionTwoLTwo.font = smlLabel
        
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
        previewButton.config(text: "PREVIEW",textColor: UIColor.black)
    }
    
    func setupCategoryPicker() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        selectCategoryField.textFIeld.inputView = categoryPicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneCategoryPicker))
        toolbar.setItems([done], animated: true)
        selectCategoryField.textFIeld.inputAccessoryView = toolbar
    }
    
    @objc func doneCategoryPicker() {
        let selectedRow = categoryPicker.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedRow]
        selectCategoryField.textFIeld.text = selectedCategory.name
        print("Selected ID:", selectedCategory.id)
        view.endEditing(true)
    }
    
    @objc func openImagePicker() {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
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
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showGalleryNotAvailableAlert()
            return
        }
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func showGalleryNotAvailableAlert() {
        let alert = UIAlertController(
            title: "Gallery Not Available",
            message: "Photo library is not accessible.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeScreenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCategoryField.textFIeld.text = categories[row].name
    }
}

extension HomeScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            selectorImage.image = image
            hiderImage.isHidden = true
        } else if let image = info[.originalImage] as? UIImage {
            selectorImage.image = image
            hiderImage.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension HomeScreenViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        charCounter.text = "\(count)/200"
    }
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 200
    }
}
