//
//  ViewController.swift
//  MaterialUIDemo
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import SnapKit
import MaterialUI

class ViewController: UIViewController {

    lazy var textField: TextField = {
        let view = TextField()
        view.placeholder = "TextField 1"
        return view
    }()
    lazy var textField2: TextField = {
        let view = TextField()
        view.placeholder = "Secure TextField"
        view.isSecureTextEntry = true
        view.delegate = self
        return view
    }()
    lazy var textField3: TextField = {
        let view = TextField()
        view.placeholder = "Secure TextField Toggle Enabled"
        view.isSecureTextEntry = true
        view.isSecureTextEntryToggleEnabled = true
        view.delegate = self
        return view
    }()
    lazy var textField4: TextField = {
        let view = TextField()
        view.placeholder = "DropDown TextField"
        view.type = .listDropDown
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            view.dataSource = [view.placeholder!, "DataSource1"]
        }
        view.selectionAction = { index, string in
            if index > 0  {
                view.text = string
            } else {
                view.text = nil
                let dataSource = view.dataSource
                view.dataSource = dataSource
            }
        }
        return view
    }()
    lazy var textField5: TextField = {
        let view = TextField()
        view.placeholder = "List TextField"
        view.type = .listPicker
        view.listFetchAction = { _ in
            self.getTextField5DataSource()
        }
        view.selectionAction = { index, string in
            view.text = string
        }
        return view
    }()
    lazy var textField6: TextField = {
        let view = TextField()
        view.placeholder = "List TextField No Reload"
        view.type = .listPicker
        view.selectionAction = { index, string in
            view.text = string
        }
        return view
    }()
    lazy var textField7: TextField = {
        let view = TextField()
        view.placeholder = "Search TextField Default"
        view.type = .searchDefault
        view.listFetchAction = { _ in
            self.getTextField7DataSource()
        }
        view.selectionAction = { index, string in
            view.text = string
        }
        return view
    }()
    lazy var textField8: TextField = {
        let view = TextField()
        view.placeholder = "Search TextField Instant"
        view.type = .searchInstant
        view.listFetchAction = { _ in
            self.getTextField8DataSource()
        }
        view.selectionAction = { index, string in
            view.text = string
        }
        return view
    }()
    lazy var textField9: TextField = {
        let view = TextField()
        view.placeholder = "Date TextField"
        view.type = .date
        return view
    }()

    lazy var stackView: UIStackView = {
        let subViews = [textField, textField2, textField3, textField4, textField5, textField6, textField7, textField8, textField9]
        let view = UIStackView(arrangedSubviews: subViews)
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }()


    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.view.addSubview(view)
        view.snp.makeConstraints { [unowned self] (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                // Fallback on earlier versions
                make.edges.equalTo(self.view)
            }
        }
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        view.isScrollEnabled = true
        return view
    }()

    private lazy var scrollContentView: UIView = {
        let view = UIView()
        scrollView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        })
        return view
    }()

    var textFieldDataSourceCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        scrollContentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(24)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)

        self.getTextField5DataSource()
        self.getTextField6DataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textField4.becomeFirstResponder()
    }


    @objc private func endEditing() {
        self.view.endEditing(true)
    }

    private func getTextField5DataSource() {
        textField5.listReloadState = .processing
        self.textFieldDataSourceCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var dataSource = [String]()
            for i in 0...self.textFieldDataSourceCount {
                dataSource.append("DataSource\(i+1)")
            }
            self.textField5.dataSource = dataSource
            self.textField5.listReloadState = .success
        }
    }
    private func getTextField6DataSource() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var dataSource = [String]()
            for i in 0...50 {
                dataSource.append("DataSource\(i+1)")
            }
            self.textField6.dataSource = dataSource
        }
    }
    private func getTextField7DataSource() {
        textField7.listReloadState = .processing
        self.textFieldDataSourceCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var dataSource = [String]()
            for i in 0...self.textFieldDataSourceCount {
                dataSource.append("DataSource\(i+1)")
            }
            self.textField7.dataSource = dataSource
            self.textField7.listReloadState = .success
        }
    }

    private func getTextField8DataSource() {
        textField8.listReloadState = .processing
        self.textFieldDataSourceCount += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var dataSource = [String]()
            for i in 0...self.textFieldDataSourceCount {
                dataSource.append("DataSource\(i+1)")
            }
            self.textField8.dataSource = dataSource
            self.textField8.listReloadState = .success
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textField2 {
            textField2.checkValidation()
        } else if textField == textField3 {
            textField3.checkValidation()
        } else if textField == textField4 {
            textField4.checkValidation()
        }
    }
}
