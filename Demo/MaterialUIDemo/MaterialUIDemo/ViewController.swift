//
//  ViewController.swift
//  MaterialUIDemo
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import MaterialUI
import MaterialComponents

class ViewController: UIViewController {
    
    lazy var textField: TextField = {
        let view = TextField()
        view.style = .underlined
        view.controller?.isFloatingEnabled = false
        view.textAlignment = .left
        view.textContentType = UITextContentType.countryName
        view.keyboardType = .default
        view.autocorrectionType = .no
        view.placeholder = "Placeholder"
        return view
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.systemTeal
        
        self.view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
    }


}

