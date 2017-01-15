//
//  SmartCarOAuthPickerGenerator.swift
//  SmartCarOAuthSDK
//
//  Created by Ziyu Zhang on 1/14/17.
//  Copyright © 2017 Ziyu Zhang. All rights reserved.
//

import UIKit

// An array of all currently supported OEMs as OEM objects
let defaultOEM = [OEM(oemName: OEMName.acura), OEM(oemName: OEMName.audi), OEM(oemName: OEMName.bmw),
                  OEM(oemName: OEMName.bmwConnected), OEM(oemName: OEMName.buick), OEM(oemName: OEMName.cadillac),
                  OEM(oemName: OEMName.chevrolet), OEM(oemName: OEMName.chrysler), OEM(oemName: OEMName.dodge),
                  OEM(oemName: OEMName.fiat), OEM(oemName: OEMName.ford), OEM(oemName: OEMName.gmc),
                  OEM(oemName: OEMName.hyundai), OEM(oemName: OEMName.infiniti), OEM(oemName: OEMName.jeep),
                  OEM(oemName: OEMName.kia), OEM(oemName: OEMName.landrover), OEM(oemName: OEMName.lexus),
                  OEM(oemName: OEMName.mercedes), OEM(oemName: OEMName.nissan), OEM(oemName: OEMName.nissanev),
                  OEM(oemName: OEMName.ram), OEM(oemName: OEMName.tesla), OEM(oemName: OEMName.volkswagen),
                  OEM(oemName: OEMName.volvo)]

/**
    Class to generate pickers to automatically initialize authentication flow for multiple OEMs
 */

class SmartCarOAuthPickerGenerator: SmartCarOAuthUIGenerator, UIPickerViewDelegate, UIPickerViewDataSource {
    // List of OEMs within the picker. Defaults to a list of all OEMs
    var oemList = defaultOEM
    // UIPickerView object
    var picker = UIPickerView()
    // UIToolbar object that resides above the picker
    var toolBar = UIToolbar()
    // Invisible button to signal that outside the picker has been clicked
    var invisButton = UIButton()
    
    init(sdk: SmartCarOAuthSDK, viewController: UIViewController, oemList: [OEM] = defaultOEM) {
        super.init(sdk: sdk, viewController: viewController)
        self.oemList = oemList
    }
    
    /**
        Generates and displays the initial button which displays the UIPickerView when pressed
     
        - parameters:
            - for: list of OEMs generated by the picker. defaults to the list all OEMs
            - in: UIView object that the initial button will reside and fill
            - with: color of the initial button. Defaults to black
     */
    
    func generatePicker(in view: UIView, with color: UIColor = .black) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        button.backgroundColor = color
        button.setTitle("CONNECT A VEHICLE", for: .normal)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(pickerButtonPressed), for: .touchUpInside)
        
        view.addSubview(button)
        return button
    }
    
    /**
        Action methods for the pressing of the initial picker button. Formats and sisplays the UIPickerView, UIToolbar, and the invisible button
    */
    @objc private func pickerButtonPressed() {
        self.picker = UIPickerView()
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        self.picker.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        self.toolBar = UIToolbar()
        self.toolBar.backgroundColor = UIColor(white: 1, alpha: 1)
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        self.toolBar.setItems([spaceButton, doneButton], animated: false)
        self.toolBar.isUserInteractionEnabled = true
        
        self.invisButton = UIButton()
        self.invisButton.backgroundColor = UIColor(white: 0, alpha: 0)
        self.invisButton.addTarget(self, action: #selector(hidePickerView), for: .touchUpInside)
        self.invisButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewController.view.addSubview(self.picker)
        self.viewController.view.addSubview(self.toolBar)
        self.viewController.view.addSubview(self.invisButton)
        
        //Format constraints for autolayout
        let pickerPinBottom = NSLayoutConstraint(item: self.picker, attribute: .bottom, relatedBy: .equal, toItem: self.viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pickerHeight = NSLayoutConstraint(item: self.picker, attribute: .height, relatedBy: .equal, toItem: self.viewController.view, attribute: .height, multiplier: 0.33, constant: 0)
        let pickerWidth = NSLayoutConstraint(item: self.picker, attribute: .width, relatedBy: .equal, toItem: self.viewController.view, attribute: .width, multiplier: 1, constant: 0)
        let toolbarPinToPicker = NSLayoutConstraint(item: self.toolBar, attribute: .bottom, relatedBy: .equal, toItem: self.picker, attribute: .top, multiplier: 1.0, constant: 0)
        let toolbarWidth = NSLayoutConstraint(item: self.toolBar, attribute: .width, relatedBy: .equal, toItem: self.viewController.view, attribute: .width, multiplier: 1, constant: 0)
        let invisButtonPinTop = NSLayoutConstraint(item: self.invisButton, attribute: .top, relatedBy: .equal, toItem: self.viewController.view, attribute: .top, multiplier: 1.0, constant: 0)
        let invisButtonPinBottom = NSLayoutConstraint(item: self.invisButton, attribute: .bottom, relatedBy: .equal, toItem: self.toolBar, attribute: .top, multiplier: 1, constant: 0)
        let invisButtonWidth = NSLayoutConstraint(item: self.invisButton, attribute: .width, relatedBy: .equal, toItem: self.viewController.view, attribute: .width, multiplier: 1, constant: 0)
        
        self.viewController.view.addConstraints([pickerPinBottom, pickerHeight, pickerWidth, toolbarPinToPicker, toolbarWidth,invisButtonPinTop, invisButtonWidth, invisButtonPinBottom])
    }
    
    /**
        Initializes the authentication flow with the selected picker value
    */
    @objc private func donePicker() {
        hidePickerView()
        let val = self.oemList[picker.selectedRow(inComponent: 0)]
        let name = val.oemName.rawValue
        
        self.sdk.initializeAuthorizationRequest(for: OEM(oemName: OEMName(rawValue: name.lowercased())!), viewController: self.viewController)
    }
    
    /**
        Hides the picker, invisButton, and toolBar
    */
    @objc private func hidePickerView() {
        picker.isHidden = true
        invisButton.isHidden = true
        toolBar.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.oemList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.oemList[row].oemName.rawValue.uppercased()
    }
}
