//
//  OEMConfig.swift
//  SmartcarAuth
//
//  Created by Jeremy Zhang on 1/6/17.
//  Copyright © 2017 Smartcar Inc. All rights reserved.
//

/**
    Class to store OEM specific configurations.
 */

import UIKit

public class OEMConfig {
    // The default color of the OEM in Hex
    let color: UIColor
    // name to be displayed for the OEM
    let displayName: String
    
    init(color: String, displayName: String) {
        self.color = hexStringToUIColor(hex: color)
        self.displayName = displayName
    }
}
