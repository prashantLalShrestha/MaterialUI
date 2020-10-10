//
//  DateDropDown.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import Foundation
import UIKit

private extension Selector {
    static let buttonTapped = #selector(DatePickerDialog.buttonTapped)
    static let deviceOrientationDidChange = #selector(DatePickerDialog.deviceOrientationDidChange)
}

open class DatePickerDialog: UIView {
    public typealias DatePickerCallback = ( Date? ) -> Void

    // MARK: - Constants
    private let kDefaultButtonHeight: CGFloat = 50
    private let kDefaultButtonSpacerHeight: CGFloat = 1
    private let kCornerRadius: CGFloat = 8
    private let kDoneButtonTag: Int = 1
    
    @objc public dynamic var shadowColor = DPDConstant.UI.Shadow.Color
    @objc public dynamic var shadowOffset = DPDConstant.UI.Shadow.Offset
    @objc public dynamic var shadowOpacity = DPDConstant.UI.Shadow.Opacity
    @objc public dynamic var shadowRadius = DPDConstant.UI.Shadow.Radius
    /**
    The duration of the show/hide animation.
    */
    @objc public dynamic var animationduration = DPDConstant.Animation.Duration

    /**
    The option of the show animation. Global change.
    */
    public static var animationEntranceOptions = DPDConstant.Animation.EntranceOptions
    
    /**
    The option of the hide animation. Global change.
    */
    public static var animationExitOptions = DPDConstant.Animation.ExitOptions
    
    /**
    The option of the show animation. Only change the caller. To change all drop down's use the static var.
    */
    public var animationEntranceOptions: UIView.AnimationOptions = DropDown.animationEntranceOptions
    
    /**
    The option of the hide animation. Only change the caller. To change all drop down's use the static var.
    */
    public var animationExitOptions: UIView.AnimationOptions = DropDown.animationExitOptions

    /**
    The downScale transformation of the tableview when the DropDown is appearing
    */
    public var downScaleTransform = DPDConstant.Animation.DownScaleTransform {
        willSet { dialogView.transform = newValue }
    }

    // MARK: - Views
    private var dialogView: UIView!
    private var titleLabel: UILabel!
    open var datePicker: UIDatePicker!
    private var cancelButton: UIButton!
    private var doneButton: UIButton!

    // MARK: - Variables
    private var defaultDate: Date?
    private var datePickerMode: UIDatePicker.Mode?
    private var callback: DatePickerCallback?
    var showCancelButton: Bool = false
    var locale: Locale?

    private var textColor: UIColor!
    private var buttonColor: UIColor!
    private var font: UIFont!

    // MARK: - Dialog initialization
    @objc public init(textColor: UIColor = UIColor.black,
                buttonColor: UIColor = UIColor.black,
                font: UIFont = .boldSystemFont(ofSize: 15),
                locale: Locale? = nil,
                showCancelButton: Bool = true) {
        let size = UIScreen.main.bounds.size
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.font = font
        self.showCancelButton = showCancelButton
        self.locale = locale
        setupView()
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        dialogView = createContainerView()

        dialogView?.layer.shouldRasterize = true
        dialogView?.layer.rasterizationScale = UIScreen.main.scale

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        dialogView?.layer.opacity = 1.0

        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        if let dialogView = dialogView {
            addSubview(dialogView)
        }
    }

    /// Handle device orientation changes
    @objc func deviceOrientationDidChange(_ notification: Notification) {
        self.frame = UIScreen.main.bounds
        let dialogSize = CGSize(width: 320, height: 230 + kDefaultButtonHeight + kDefaultButtonSpacerHeight)
        dialogView.frame = CGRect(
            x: (UIScreen.main.bounds.size.width - dialogSize.width) / 2,
            y: (UIScreen.main.bounds.size.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
        )
    }

    /// Create the dialog view, and animate opening the dialog
    open func show(
        _ title: String,
        doneButtonTitle: String = "Done",
        cancelButtonTitle: String = "Cancel",
        defaultDate: Date = Date(),
        minimumDate: Date? = nil, maximumDate: Date? = nil,
        datePickerMode: UIDatePicker.Mode = .dateAndTime,
        callback: @escaping DatePickerCallback
    ) {
        self.titleLabel.text = title
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        if showCancelButton { self.cancelButton.setTitle(cancelButtonTitle, for: .normal) }
        self.datePickerMode = datePickerMode
        self.callback = callback
        self.defaultDate = defaultDate
        self.datePicker.datePickerMode = self.datePickerMode ?? UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        self.datePicker.date = self.defaultDate ?? Date()
        self.datePicker.maximumDate = maximumDate
        self.datePicker.minimumDate = minimumDate
        if let locale = self.locale { self.datePicker.locale = locale }

        /* Add dialog to main window */
        guard let window = UIApplication.shared.keyWindow else { fatalError() }
        window.addSubview(self)
        window.bringSubviewToFront(self)
        window.endEditing(true)

        NotificationCenter.default.addObserver(
            self,
            selector: .deviceOrientationDidChange,
            name: UIDevice.orientationDidChangeNotification, object: nil
        )

        /* Anim */
        dialogView.transform = downScaleTransform

        layoutIfNeeded()

        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationEntranceOptions,
            animations: { [weak self] in
                self?.setShowedState()
            },
            completion: nil)
    }

    /// Dialog close animation then cleaning and removing the view from the parent
    private func close() {

        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationExitOptions,
            animations: { [weak self] in
                self?.setHiddentState()
            },
            completion: { [weak self] finished in
                guard let `self` = self else { return }

                self.isHidden = true
                self.removeFromSuperview()
                UIAccessibility.post(notification: .screenChanged, argument: nil)
        })
    }

    /// Creates the container view here: create the dialog, then add the custom content and buttons
    private func createContainerView() -> UIView {
        let screenSize = UIScreen.main.bounds.size
        let dialogSize = CGSize(width: 320, height: 230 + kDefaultButtonHeight + kDefaultButtonSpacerHeight)

        // For the black background
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

        // This is the dialog's container; we attach the custom content and the buttons to this one
        let container = UIView(frame: CGRect(
            x: (screenSize.width - dialogSize.width) / 2,
            y: (screenSize.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
        ))

        // First, we style the dialog to match the iOS8 UIAlertView >>>
        let cornerRadius = kCornerRadius
        container.backgroundColor = UIColor.white

        container.layer.cornerRadius = cornerRadius
        container.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        container.layer.borderWidth = 0
        container.layer.shadowRadius = shadowRadius
        container.layer.shadowOpacity = shadowOpacity
        container.layer.shadowOffset = shadowOffset
        container.layer.shadowColor = shadowColor.cgColor
        container.layer.shadowPath = UIBezierPath(
            roundedRect: container.bounds,
            cornerRadius: container.layer.cornerRadius
        ).cgPath

        // There is a line above the button
        let yPosition = container.bounds.size.height - kDefaultButtonHeight - kDefaultButtonSpacerHeight
        let lineView = UIView(frame: CGRect(
            x: 0,
            y: yPosition,
            width: container.bounds.size.width,
            height: kDefaultButtonSpacerHeight
        ))

        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        container.addSubview(lineView)

        //Title
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 30))
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = self.textColor
        self.titleLabel.font = self.font.withSize(17)
        container.addSubview(self.titleLabel)

        self.datePicker = configuredDatePicker()
        container.addSubview(self.datePicker)

        // Add the buttons
        addButtonsToView(container: container)

        return container
    }

    fileprivate func configuredDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: 0, height: 0))
        datePicker.setValue(self.textColor, forKeyPath: "textColor")
        datePicker.autoresizingMask = .flexibleRightMargin
        datePicker.frame.size.width = 300
        datePicker.frame.size.height = 216
        return datePicker
    }

    /// Add buttons to container
    private func addButtonsToView(container: UIView) {
        var buttonWidth = container.bounds.size.width / 2

        var leftButtonFrame = CGRect(
            x: 0,
            y: container.bounds.size.height - kDefaultButtonHeight,
            width: buttonWidth,
            height: kDefaultButtonHeight
        )
        var rightButtonFrame = CGRect(
            x: buttonWidth,
            y: container.bounds.size.height - kDefaultButtonHeight,
            width: buttonWidth,
            height: kDefaultButtonHeight
        )
        if showCancelButton == false {
            buttonWidth = container.bounds.size.width
            leftButtonFrame = CGRect()
            rightButtonFrame = CGRect(
                x: 0,
                y: container.bounds.size.height - kDefaultButtonHeight,
                width: buttonWidth,
                height: kDefaultButtonHeight
            )
        }
        let interfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
        let isLeftToRightDirection = interfaceLayoutDirection == .leftToRight

        if showCancelButton {
            self.cancelButton = UIButton(type: .custom) as UIButton
            self.cancelButton.frame = isLeftToRightDirection ? leftButtonFrame : rightButtonFrame
            self.cancelButton.setTitleColor(self.buttonColor, for: .normal)
            self.cancelButton.setTitleColor(self.buttonColor, for: .highlighted)
            self.cancelButton.titleLabel?.font = self.font.withSize(14)
            self.cancelButton.layer.cornerRadius = kCornerRadius
            self.cancelButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
            container.addSubview(self.cancelButton)
        }

        self.doneButton = UIButton(type: .custom) as UIButton
        self.doneButton.frame = isLeftToRightDirection ? rightButtonFrame : leftButtonFrame
        self.doneButton.tag = kDoneButtonTag
        self.doneButton.setTitleColor(self.buttonColor, for: .normal)
        self.doneButton.setTitleColor(self.buttonColor, for: .highlighted)
        self.doneButton.titleLabel?.font = self.font.withSize(14)
        self.doneButton.layer.cornerRadius = kCornerRadius
        self.doneButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
        container.addSubview(self.doneButton)
    }

    @objc func buttonTapped(sender: UIButton) {
        if sender.tag == kDoneButtonTag {
            self.callback?(self.datePicker.date)
        } else {
            self.callback?(nil)
        }

        close()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

    fileprivate func setHiddentState() {
        alpha = 0
    }

    fileprivate func setShowedState() {
        alpha = 1
        dialogView.transform = CGAffineTransform.identity
    }
}
