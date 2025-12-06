//
//  ViewController.swift
//  MiraclePills
//
//  Created by Reiss Zurbyk on 2017-01-17.
//  Copyright © 2017 Reiss Zurbyk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var successImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var statePickerButton: UIButton!

    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!

    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var zipCodeTextField: UITextField!

    @IBOutlet weak var buyNowButton: UIButton!
    
    // MARK: - Data
    let states = [
        "Alaska", "Arkansas", "Alabama",
        "California", "Maine", "New York"
    ]
    
    private var pickerContainer: UIView!
    private var statePicker: UIPickerView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        successImage.isHidden = true

        setupPicker()
        setupTapToDismissKeyboard()
        stylizeUI()
    }

    // MARK: - Picker Setup
    private func setupPicker() {
        pickerContainer = UIView(frame: CGRect(x: 0,
                                               y: view.frame.height,
                                               width: view.frame.width,
                                               height: 250))
        pickerContainer.backgroundColor = UIColor.white
        pickerContainer.layer.shadowColor = UIColor.black.cgColor
        pickerContainer.layer.shadowOpacity = 0.3
        pickerContainer.layer.shadowOffset = CGSize(width: 0, height: -2)
        
        statePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerContainer.frame.width, height: 200))
        statePicker.dataSource = self
        statePicker.delegate = self
        pickerContainer.addSubview(statePicker)
        
        let doneButton = UIButton(frame: CGRect(x: pickerContainer.frame.width - 80, y: 200, width: 70, height: 40))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.addTarget(self, action: #selector(donePickingState), for: .touchUpInside)
        pickerContainer.addSubview(doneButton)
        
        view.addSubview(pickerContainer)
    }
    
    // MARK: - Styling
    private func stylizeUI() {
        statePickerButton.layer.cornerRadius = 8
        buyNowButton.layer.cornerRadius = 8
        buyNowButton.setTitleColor(.white, for: .normal)

        let fields = [
            nameTextField, addressTextField, cityTextField,
            countryTextField, zipCodeTextField
        ]
        fields.forEach {
            $0?.layer.borderWidth = 0.8
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            $0?.layer.cornerRadius = 6
            $0?.setLeftPaddingPoints(8)
        }
    }

    private func setupTapToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @IBAction func stateButtonPressed(_ sender: Any) {
        showPicker()
    }

    @IBAction func buyNowButtonPressed(_ sender: Any) {
        hideFormAndShowSuccess()
    }
    
    @objc private func donePickingState() {
        let selectedRow = statePicker.selectedRow(inComponent: 0)
        statePickerButton.setTitle(states[selectedRow], for: .normal)
        hidePicker()
    }

    private func showPicker() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = self.view.frame.height - self.pickerContainer.frame.height
        }
    }

    private func hidePicker() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainer.frame.origin.y = self.view.frame.height
        }
    }

    private func hideFormAndShowSuccess() {
        let allViewsToHide: [UIView] = [
            nameLabel, nameTextField,
            addressLabel, addressTextField,
            cityLabel, cityTextField,
            stateLabel, statePickerButton,
            countryLabel, countryTextField,
            zipCodeLabel, zipCodeTextField,
            buyNowButton
        ]

        UIView.animate(withDuration: 0.3, animations: {
            allViewsToHide.forEach { $0.alpha = 0 }
        }) { _ in
            self.successImage.isHidden = false
            UIView.animate(withDuration: 0.25) {
                self.successImage.alpha = 1
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        states.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        states[row]
    }
}

// MARK: - UITextField Padding Extension
private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height)
        )
        leftView = paddingView
        leftViewMode = .always
    }
}
