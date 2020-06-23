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
        view.style = .common
        view.controller?.isFloatingEnabled = false
        view.textAlignment = .left
        view.textContentType = UITextContentType.countryName
        view.keyboardType = .default
        view.autocorrectionType = .no
        view.placeholder = "Placeholder"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 67).isActive = true
        return view
    }()
    lazy var textField2: TextField = {
        let view = TextField()
        view.style = .common
        view.controller?.isFloatingEnabled = false
        view.textAlignment = .left
        view.textContentType = UITextContentType.countryName
        view.keyboardType = .default
        view.autocorrectionType = .no
        view.placeholder = "Placeholder2"
        return view
    }()
    lazy var stackView: UIStackView = {
        let subViews = [textField, textField2]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = .vertical
        return view
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
    }


}

