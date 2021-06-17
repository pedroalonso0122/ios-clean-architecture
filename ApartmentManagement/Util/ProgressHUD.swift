//
//  ProgressHUD.swift
//  Apartment Rent Management
//
//  Created by Pedro Alonso on 2020/10/28.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation
import JGProgressHUD

class ProgressHUD: NSObject {

    static let instance = ProgressHUD()

    var hud: JGProgressHUD?
    
    func show(parentView: UIView) {
        hud = JGProgressHUD(style: .dark)
        hud?.textLabel.text = "Loading"
        hud?.show(in: parentView)
    }
    
    func dismiss() {
        hud?.dismiss()
        hud = nil        
    }

}
