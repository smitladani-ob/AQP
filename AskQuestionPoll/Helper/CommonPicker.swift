import UIKit

class CommonPicker: NSObject {

    static let shared = CommonPicker()

    private var data: [String] = []
    private var onSelect: ((String, Int) -> Void)?

    private weak var textField: UITextField?

    func attachPicker(
        to textField: UITextField,
        data: [String],
        onSelect: @escaping (String, Int) -> Void
    ) {
        self.data = data
        self.onSelect = onSelect
        self.textField = textField

        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self

        textField.inputView = picker

        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let done = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneTapped)
        )

        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        toolbar.setItems([space, done], animated: true)
        textField.inputAccessoryView = toolbar
    }

    @objc private func doneTapped() {
        guard let textField = textField,
              let picker = textField.inputView as? UIPickerView else { return }

        let row = picker.selectedRow(inComponent: 0)
        let value = data[row]

        textField.text = value
        onSelect?(value, row)

        textField.resignFirstResponder()
    }
}

// MARK: - Picker Delegate
extension CommonPicker: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}
