//
//  FullScreenDropDown.swift
//  MaterialUI
//
//  Created by Prashant Shrestha on 5/22/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit

public typealias ReloadActionClosure = () -> Void
public typealias SearchActionClosure = (_ searchText: String) -> Void
typealias SearchConditionClosure = (_ searchText: String, _ data: String) -> Bool

/// A Material Design drop down in replacement for `UIPickerView`.
public final class FullScreenDropDown: UIView {

    //MARK: - Properties

    /// The current visible drop down. There can be only one visible drop down at a time.
    public static weak var VisibleDropDown: FullScreenDropDown?
    var isDisplayed: Bool {
        return !(self == FullScreenDropDown.VisibleDropDown && FullScreenDropDown.VisibleDropDown?.isHidden == false)
    }

    //MARK: UI
    fileprivate let viewContainer = UIView()
    fileprivate lazy var topBarSeparator: UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var topBar: UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var backButton: UIButton = {
        let image = UIImage(podImageName: "icn_back_arrow")?.scaled(to: CGSize(width: 22, height: 22))
        let view = UIButton()
        view.setImage(image, for: .normal)
        view.addTarget(self, action: #selector(dismissableViewTapped), for: .touchUpInside)
        return view
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    lazy var trailingProcessingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.tintColor = textColor
        view.hidesWhenStopped = true
        return view
    }()
    lazy var trailingReloadButton: UIButton = {
        let image = UIImage(podImageName: "icn_reload")?.scaled(to: CGSize(width: 22, height: 22))
        let view = UIButton()
        view.setImage(image, for: .normal)
        view.addTarget(self, action: #selector(reloadButtonAction), for: .touchUpInside)
        return view
    }()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.showsCancelButton = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    fileprivate let tableViewContainer = UIView()
    fileprivate let tableView = UITableView()
    fileprivate var templateCell: DropDownCell!

    //MARK: Constraints
    fileprivate var heightConstraint: NSLayoutConstraint!
    fileprivate var widthConstraint: NSLayoutConstraint!
    fileprivate var xConstraint: NSLayoutConstraint!
    fileprivate var yConstraint: NSLayoutConstraint!

    //MARK: Appearance
    @objc public dynamic var cellHeight = DPDConstant.UI.RowHeight {
        willSet { tableView.rowHeight = newValue }
        didSet { reloadAllComponents() }
    }

    @objc fileprivate dynamic var tableViewBackgroundColor = DPDConstant.UI.BackgroundColor {
        willSet {
            tableView.backgroundColor = newValue
        }
    }

    public override var backgroundColor: UIColor? {
        get { return tableViewBackgroundColor }
        set { tableViewBackgroundColor = newValue! }
    }
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    /**
    The background color of the selected cell in the drop down.

    Changing the background color automatically reloads the drop down.
    */
    @objc public dynamic var selectionBackgroundColor = DPDConstant.UI.SelectionBackgroundColor

    /**
    The separator color between cells.

    Changing the separator color automatically reloads the drop down.
    */
    @objc public dynamic var separatorColor = DPDConstant.UI.SeparatorColor {
        willSet { tableView.separatorColor = newValue }
        didSet { reloadAllComponents() }
    }

    /**
    The corner radius of DropDown.

    Changing the corner radius automatically reloads the drop down.
    */
    @objc public dynamic var cornerRadius = DPDConstant.UI.CornerRadius {
        willSet {
            tableViewContainer.layer.cornerRadius = newValue
            tableView.layer.cornerRadius = newValue
        }
        didSet { reloadAllComponents() }
    }

    /**
    Alias method for `cornerRadius` variable to avoid ambiguity.
    */
    @objc public dynamic func setupCornerRadius(_ radius: CGFloat) {
        tableViewContainer.layer.cornerRadius = radius
        tableView.layer.cornerRadius = radius
        reloadAllComponents()
    }

    /**
    The masked corners of DropDown.

    Changing the masked corners automatically reloads the drop down.
    */
    @available(iOS 11.0, *)
    @objc public dynamic func setupMaskedCorners(_ cornerMask: CACornerMask) {
        tableViewContainer.layer.maskedCorners = cornerMask
        tableView.layer.maskedCorners = cornerMask
        reloadAllComponents()
    }

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
        willSet { tableViewContainer.transform = newValue }
    }

    /**
    The color of the text for each cells of the drop down.

    Changing the text color automatically reloads the drop down.
    */
    @objc public dynamic var textColor = DPDConstant.UI.TextColor {
        didSet { reloadAllComponents() }
    }

    /**
     The color of the text for selected cells of the drop down.
     
     Changing the text color automatically reloads the drop down.
     */
    @objc public dynamic var selectedTextColor = DPDConstant.UI.SelectedTextColor {
        didSet { reloadAllComponents() }
    }
    
    /**
    The font of the text for each cells of the drop down.

    Changing the text font automatically reloads the drop down.
    */
    @objc public dynamic var textFont = DPDConstant.UI.TextFont {
        didSet {
            self.titleLabel.font = textFont.withSize(16)
            reloadAllComponents()
        }
    }
    
    /**
     The NIB to use for DropDownCells
     
     Changing the cell nib automatically reloads the drop down.
     */
    public var cellNib = UINib(podNibName: "DropDownCell") {
        didSet {
            tableView.register(cellNib, forCellReuseIdentifier: DPDConstant.ReusableIdentifier.DropDownCell)
            templateCell = nil
            reloadAllComponents()
        }
    }
    
    //MARK: Content

    /**
    The data source for the drop down.

    Changing the data source automatically reloads the drop down.
    */
    public var dataSource = [String]() {
        didSet {
            deselectRows(at: selectedRowIndices)
            filteredDataSource = dataSource
        }
    }
    fileprivate var filteredDataSource = [String]() {
        didSet {
            reloadAllComponents()
        }
    }

    /// The indicies that have been selected
    internal var selectedRowIndices = Set<Index>()

    /**
    The format for the cells' text.

    By default, the cell's text takes the plain `dataSource` value.
    Changing `cellConfiguration` automatically reloads the drop down.
    */
    public var cellConfiguration: ConfigurationClosure? {
        didSet { reloadAllComponents() }
    }
    
    /**
     A advanced formatter for the cells. Allows customization when custom cells are used
     
     Changing `customCellConfiguration` automatically reloads the drop down.
     */
    public var customCellConfiguration: CellConfigurationClosure? {
        didSet { reloadAllComponents() }
    }
    
    public var reloadAction: ReloadActionClosure? { didSet { self.setNeedsUpdateConstraints() } }
    public var searchAction: SearchActionClosure?
    var searchCondition: SearchConditionClosure = { searchText, data in
        return data.contains(searchText)
    }

    /// The action to execute when the user selects a cell.
    public var selectionAction: SelectionClosure?
    
    /**
    The action to execute when the user selects multiple cells.
    
    Providing an action will turn on multiselection mode.
    The single selection action will still be called if provided.
    */
    public var multiSelectionAction: MultiSelectionClosure?

    /// The action to execute when the drop down will show.
    public var willShowAction: Closure?

    /// The action to execute when the user cancels/hides the drop down.
    public var cancelAction: Closure?

    fileprivate var minHeight: CGFloat {
        return tableView.rowHeight
    }

    fileprivate var didSetupConstraints = false

    //MARK: - Init's

    deinit {
        stopListeningToNotifications()
    }

    /**
    Creates a new instance of a drop down.
    Don't forget to setup the `dataSource`,
    the `anchorView` and the `selectionAction`
    at least before calling `show()`.
    */
    public convenience init() {
        self.init(frame: .zero)
    }

    /**
    Creates a new instance of a drop down.

    - parameter selectionAction:   The action to execute when the user selects a cell.
    - parameter dataSource:        The data source for the drop down.
    - parameter cellConfiguration: The format for the cells' text.
    - parameter cancelAction:      The action to execute when the user cancels/hides the drop down.

    - returns: A new instance of a drop down customized with the above parameters.
    */
    public convenience init(selectionAction: SelectionClosure? = nil, dataSource: [String] = [], cellConfiguration: ConfigurationClosure? = nil, cancelAction: Closure? = nil) {
        self.init(frame: .zero)
        
        self.selectionAction = selectionAction
        self.dataSource = dataSource
        self.cellConfiguration = cellConfiguration
        self.cancelAction = cancelAction
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

}

//MARK: - Setup

private extension FullScreenDropDown {

    func setup() {
        tableView.register(cellNib, forCellReuseIdentifier: DPDConstant.ReusableIdentifier.DropDownCell)

        DispatchQueue.main.async {
            //HACK: If not done in dispatch_async on main queue `setupUI` will have no effect
            self.updateConstraintsIfNeeded()
            self.setupUI()
        }

        tableView.rowHeight = cellHeight
        setHiddentState()
        isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        
        startListeningToKeyboard()

        accessibilityIdentifier = "drop_down"
        
        
        self.searchAction = { searchText in
            self.filteredDataSource = self.dataSource.filter({
                self.searchCondition(searchText.lowercased(), $0.lowercased()) || searchText == ""
            })
            
            self.selectRows(at: self.selectedRowIndices)
        }
        
    }

    func setupUI() {
        
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.backgroundColor = UIColor.clear.cgColor
        viewContainer.backgroundColor = UIColor.clear
        
        viewContainer.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        viewContainer.layer.shadowOpacity = 0.0
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: -4.0)
        viewContainer.layer.shadowRadius = 3.0

        tableViewContainer.layer.masksToBounds = true
        tableViewContainer.layer.cornerRadius = cornerRadius
        tableViewContainer.backgroundColor = tableViewBackgroundColor

        tableView.backgroundColor = tableViewBackgroundColor
        tableView.separatorColor = separatorColor
        tableView.layer.masksToBounds = true
        
        topBarSeparator.backgroundColor = UIColor.black.withAlphaComponent(0.16)
        
    }

}

//MARK: - UI

extension FullScreenDropDown {

    public override func updateConstraints() {
        if !didSetupConstraints {
            setupConstraints()
        }

        didSetupConstraints = true

        let layout = computeLayout()

        if !layout.canBeDisplayed {
            super.updateConstraints()
            hide()

            return
        }

        xConstraint.constant = layout.x
        yConstraint.constant = layout.y
        widthConstraint.constant = layout.width
        heightConstraint.constant = layout.visibleHeight
        

        topBar.leftAnchor.constraint(equalTo: tableViewContainer.leftAnchor, constant: 6.0).isActive = true
        topBar.rightAnchor.constraint(equalTo: tableViewContainer.rightAnchor, constant: -6.0).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        trailingProcessingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        topBarSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        if reloadAction != nil {
            trailingReloadButton.removeFromSuperview()
            topBar.insertSubview(trailingReloadButton, aboveSubview: trailingProcessingView)
            trailingReloadButton.translatesAutoresizingMaskIntoConstraints = false
            let trailingReloadButtonConstraints = [
                trailingReloadButton.topAnchor.constraint(equalTo: trailingProcessingView.topAnchor),
                trailingReloadButton.bottomAnchor.constraint(equalTo: trailingProcessingView.bottomAnchor),
                trailingReloadButton.leftAnchor.constraint(equalTo: trailingProcessingView.leftAnchor),
                trailingReloadButton.rightAnchor.constraint(equalTo: trailingProcessingView.rightAnchor)
            ]
            NSLayoutConstraint.activate(trailingReloadButtonConstraints)
        } else {
            trailingReloadButton.removeFromSuperview()
        }
        
//        tableView.isScrollEnabled = layout.offscreenHeight >= 0

        DispatchQueue.main.async { [weak self] in
            self?.tableView.flashScrollIndicators()
        }

        super.updateConstraints()
    }

    fileprivate func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(viewContainer)
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        let viewContainerConstraints = [
            viewContainer.topAnchor.constraint(equalTo: topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        NSLayoutConstraint.activate(viewContainerConstraints)

        // Table view container
        viewContainer.addSubview(tableViewContainer)
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false

        xConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .leading,
            relatedBy: .equal,
            toItem: viewContainer,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        addConstraint(xConstraint)

        yConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .top,
            relatedBy: .equal,
            toItem: viewContainer,
            attribute: .top,
            multiplier: 1,
            constant: 0)
        addConstraint(yConstraint)

        widthConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0)
        tableViewContainer.addConstraint(widthConstraint)

        heightConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0)
        tableViewContainer.addConstraint(heightConstraint)

        // Table view
        
        
        tableViewContainer.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        let topBarConstraints = [
            topBar.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
        ]
        NSLayoutConstraint.activate(topBarConstraints)
        
        topBar.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: topBar.topAnchor),
            backButton.leftAnchor.constraint(equalTo: topBar.leftAnchor),
            backButton.bottomAnchor.constraint(equalTo: topBar.bottomAnchor),
        ]
        NSLayoutConstraint.activate(backButtonConstraints)
        
        topBar.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: topBar.bottomAnchor),
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        topBar.addSubview(trailingProcessingView)
        trailingProcessingView.translatesAutoresizingMaskIntoConstraints = false
        let trailingProcessingViewConstraints = [
            trailingProcessingView.topAnchor.constraint(equalTo: topBar.topAnchor),
            trailingProcessingView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor),
            trailingProcessingView.rightAnchor.constraint(equalTo: topBar.rightAnchor),
            trailingProcessingView.bottomAnchor.constraint(equalTo: topBar.bottomAnchor),
        ]
        NSLayoutConstraint.activate(trailingProcessingViewConstraints)
        
        tableViewContainer.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            searchBar.leftAnchor.constraint(equalTo: topBar.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: topBar.rightAnchor),
        ]
        NSLayoutConstraint.activate(searchBarConstraints)
        
        tableViewContainer.addSubview(topBarSeparator)
        topBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        let topBarSeparatorConstraints = [
            topBarSeparator.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            topBarSeparator.leftAnchor.constraint(equalTo: tableViewContainer.leftAnchor),
            topBarSeparator.rightAnchor.constraint(equalTo: tableViewContainer.rightAnchor),
        ]
        NSLayoutConstraint.activate(topBarSeparatorConstraints)
        
        
        tableViewContainer.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: topBarSeparator.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: tableViewContainer.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: tableViewContainer.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
        
        
        self.bringSubviewToFront(topBarSeparator)
        self.bringSubviewToFront(searchBar)
        self.bringSubviewToFront(topBar)

    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // When orientation changes, layoutSubviews is called
        // We update the constraint to update the position
        setNeedsUpdateConstraints()

        let shadowPath = UIBezierPath(roundedRect: tableViewContainer.bounds, cornerRadius: cornerRadius)
        tableViewContainer.layer.shadowPath = shadowPath.cgPath
    }

    fileprivate func computeLayout() -> (x: CGFloat, y: CGFloat, width: CGFloat, offscreenHeight: CGFloat, visibleHeight: CGFloat, canBeDisplayed: Bool) {
        var layout: ComputeLayoutTuple = (0, 0, 0, 0)

        guard let window = UIWindow.visibleWindow() else { return (0, 0, 0, 0, 0, false) }
        
        layout = computeLayoutBottomDisplay(window: window)
        
        constraintWidthToFittingSizeIfNecessary(layout: &layout)
        constraintWidthToBoundsIfNecessary(layout: &layout, in: window)
        
        let visibleHeight = tableHeight - layout.offscreenHeight
        let canBeDisplayed = visibleHeight >= minHeight

        return (layout.x, layout.y, layout.width, layout.offscreenHeight, visibleHeight, canBeDisplayed)
    }

    fileprivate func computeLayoutBottomDisplay(window: UIWindow) -> ComputeLayoutTuple {
        var offscreenHeight: CGFloat = 0
        
        let width = fittingWidth()
        
        let anchorViewX = window.frame.midX - (width / 2)
        let anchorViewY = window.frame.midY - (tableHeight / 2)
        
        let x = anchorViewX
        let y = anchorViewY + UIApplication.shared.statusBarFrame.height - 10
        
        let maxY = y + tableHeight
        let windowMaxY = window.bounds.maxY
        
        let keyboardListener = KeyboardListener.sharedInstance
        let keyboardMinY = keyboardListener.keyboardFrame.minY
        
        if keyboardListener.isVisible && maxY > keyboardMinY {
            offscreenHeight = abs(maxY - keyboardMinY)
        } else if maxY > windowMaxY {
            offscreenHeight = abs(maxY - windowMaxY)
        }
        
        return (x, y, width, offscreenHeight)
    }
    
    fileprivate func fittingWidth() -> CGFloat {
        if templateCell == nil {
            templateCell = (cellNib?.instantiate(withOwner: nil, options: nil)[0] as! DropDownCell)
        }
        
        var maxWidth: CGFloat = 0
        
        maxWidth = UIScreen.main.bounds.width
        
        return maxWidth
    }
    
    fileprivate func constraintWidthToBoundsIfNecessary(layout: inout ComputeLayoutTuple, in window: UIWindow) {
        let windowMaxX = window.bounds.maxX
        let maxX = layout.x + layout.width
        
        if maxX > windowMaxX {
            let delta = maxX - windowMaxX
            let newOrigin = layout.x - delta
            
            if newOrigin > 0 {
                layout.x = newOrigin
            } else {
                layout.x = 0
                layout.width += newOrigin // newOrigin is negative, so this operation is a substraction
            }
        }
    }
    
    fileprivate func constraintWidthToFittingSizeIfNecessary(layout: inout ComputeLayoutTuple) {
        
        if layout.width < fittingWidth() {
            layout.width = fittingWidth()
        }
    }
    
}

//MARK: - Actions

extension FullScreenDropDown {
    
    /**
     An Objective-C alias for the show() method which converts the returned tuple into an NSDictionary.
     
     - returns: An NSDictionary with a value for the "canBeDisplayed" Bool, and possibly for the "offScreenHeight" Optional(CGFloat).
     */
    @objc(show)
    public func objc_show() -> NSDictionary {
        let (canBeDisplayed, offScreenHeight) = show()
        
        var info = [AnyHashable: Any]()
        info["canBeDisplayed"] = canBeDisplayed
        if let offScreenHeight = offScreenHeight {
            info["offScreenHeight"] = offScreenHeight
        }
        
        return NSDictionary(dictionary: info)
    }
    
    /**
    Shows the drop down if enough height.

    - returns: Wether it succeed and how much height is needed to display all cells at once.
    */
    @discardableResult
    public func show(onTopOf window: UIWindow? = nil, beforeTransform transform: CGAffineTransform? = nil, anchorPoint: CGPoint? = nil) -> (canBeDisplayed: Bool, offscreenHeight: CGFloat?) {
        if self == FullScreenDropDown.VisibleDropDown && FullScreenDropDown.VisibleDropDown?.isHidden == false { // added condition - DropDown.VisibleDropDown?.isHidden == false -> to resolve forever hiding dropdown issue when continuous taping on button - Kartik Patel - 2016-12-29
            return (true, 0)
        }

        if let visibleDropDown = FullScreenDropDown.VisibleDropDown {
            visibleDropDown.cancel()
        }

        willShowAction?()

        FullScreenDropDown.VisibleDropDown = self

        setNeedsUpdateConstraints()

        let visibleWindow = window != nil ? window : UIWindow.visibleWindow()
        visibleWindow?.addSubview(self)
        visibleWindow?.bringSubviewToFront(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])

        let layout = computeLayout()

        if !layout.canBeDisplayed {
            hide()
            return (layout.canBeDisplayed, layout.offscreenHeight)
        }

        isHidden = false
        
        if anchorPoint != nil {
            tableViewContainer.layer.anchorPoint = anchorPoint!
        }
        
        if transform != nil {
            tableViewContainer.transform = transform!
        } else {
            tableViewContainer.transform = downScaleTransform
        }

        layoutIfNeeded()

        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationEntranceOptions,
            animations: { [weak self] in
                self?.setShowedState()
            },
            completion: nil)

        accessibilityViewIsModal = true
        UIAccessibility.post(notification: .screenChanged, argument: self)

        searchBar.text = nil
        searchBar(searchBar, textDidChange: "")
        //deselectRows(at: selectedRowIndices)
        selectRows(at: selectedRowIndices)

        return (layout.canBeDisplayed, layout.offscreenHeight)
    }

    /// Hides the drop down.
    public func hide() {
        if self == DropDown.VisibleDropDown {
            /*
            If one drop down is showed and another one is not
            but we call `hide()` on the hidden one:
            we don't want it to set the `VisibleDropDown` to nil.
            */
            DropDown.VisibleDropDown = nil
        }

        if isHidden {
            return
        }

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

    fileprivate func cancel() {
        hide()
        cancelAction?()
    }

    fileprivate func setHiddentState() {
        alpha = 0
    }

    fileprivate func setShowedState() {
        alpha = 1
        tableViewContainer.transform = CGAffineTransform.identity
    }

}

//MARK: - UITableView

extension FullScreenDropDown {

    /**
    Reloads all the cells.

    It should not be necessary in most cases because each change to
    `dataSource`, `textColor`, `textFont`, `selectionBackgroundColor`
    and `cellConfiguration` implicitly calls `reloadAllComponents()`.
    */
    public func reloadAllComponents() {
        DispatchQueue.executeOnMainThread {
            self.tableView.reloadData()
            self.setNeedsUpdateConstraints()
        }
    }

    /// (Pre)selects a row at a certain index.
    public func selectRow(at index: Index?, scrollPosition: UITableView.ScrollPosition = .none) {
        if let index = index, let selectedIndex = filteredDataSource.firstIndex(of: dataSource[index]) {
            tableView.selectRow(
                at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: scrollPosition
            )
            selectedRowIndices.insert(index)
        }
//        else {
//            deselectRows(at: selectedRowIndices)
//            selectedRowIndices.removeAll()
//        }
    }
    
    public func selectRows(at indices: Set<Index>?) {
        indices?.forEach {
            selectRow(at: $0)
        }
        
        // if we are in multi selection mode then reload data so that all selections are shown
        if multiSelectionAction != nil {
            tableView.reloadData()
        }
    }

    public func deselectRow(at index: Index?) {
        guard let index = index
            , index >= 0
            else { return }
        
        // remove from indices
        if let selectedRowIndex = selectedRowIndices.firstIndex(where: { $0 == index  }) {
            selectedRowIndices.remove(at: selectedRowIndex)
        }

        
        guard index < dataSource.count, let filteredIndex = filteredDataSource.firstIndex(of: dataSource[index]) else { return }
        tableView.deselectRow(at: IndexPath(row: filteredIndex, section: 0), animated: true)
    }
    
    // de-selects the rows at the indices provided
    public func deselectRows(at indices: Set<Index>?) {
        indices?.forEach {
            deselectRow(at: $0)
        }
    }

    /// Returns the index of the selected row.
    public var indexForSelectedRow: Index? {
        return (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
    }

    /// Returns the selected item.
    public var selectedItem: String? {
        guard let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row else { return nil }

        return filteredDataSource[row]
    }

    /// Returns the height needed to display all cells.
    fileprivate var tableHeight: CGFloat {
        return (window?.frame.maxY ?? tableView.rowHeight * CGFloat(dataSource.count)) - UIApplication.shared.statusBarFrame.height
//        return tableView.rowHeight * CGFloat(dataSource.count)
    }

    //MARK: Objective-C methods for converting the Swift type Index
    @objc public func selectRow(_ index: Int, scrollPosition: UITableView.ScrollPosition = .none) {
        self.selectRow(at:Index(index), scrollPosition: scrollPosition)
    }
    
    @objc public func clearSelection() {
        self.selectRow(at:nil)
    }
    
    @objc public func deselectRow(_ index: Int) {
        tableView.deselectRow(at: IndexPath(row: Index(index), section: 0), animated: true)
    }

    @objc public var indexPathForSelectedRow: NSIndexPath? {
        return tableView.indexPathForSelectedRow as NSIndexPath?
    }
}

//MARK: - UITableViewDataSource - UITableViewDelegate

extension FullScreenDropDown: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataSource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DPDConstant.ReusableIdentifier.DropDownCell, for: indexPath) as! DropDownCell
        let index = (indexPath as NSIndexPath).row

        configureCell(cell, at: index)

        return cell
    }
    
    fileprivate func configureCell(_ cell: DropDownCell, at index: Int) {
        
        cell.optionLabel.textColor = textColor
        cell.optionLabel.font = textFont
        cell.selectedBackgroundColor = selectionBackgroundColor
        cell.highlightTextColor = selectedTextColor
        cell.normalTextColor = textColor
        
        if let cellConfiguration = cellConfiguration {
            cell.optionLabel.text = cellConfiguration(index, filteredDataSource[index])
        } else {
            cell.optionLabel.text = filteredDataSource[index]
        }
        
        customCellConfiguration?(index, filteredDataSource[index], cell)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = selectedRowIndices.first{ dataSource[$0] == filteredDataSource[(indexPath as NSIndexPath).row] } != nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRowIndex = dataSource.firstIndex(of: filteredDataSource[(indexPath as NSIndexPath).row]) else { return }
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        // are we in multi-selection mode?
        if let multiSelectionCallback = multiSelectionAction {
            // if already selected then deselect
            if selectedRowIndices.first(where: { $0 == selectedRowIndex}) != nil {
                deselectRow(at: selectedRowIndex)

                let selectedRowIndicesArray = Array(selectedRowIndices)
                let selectedRows = selectedRowIndicesArray.map { dataSource[$0] }
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                return
            }
            else {
                selectedRowIndices.insert(selectedRowIndex)

                let selectedRowIndicesArray = Array(selectedRowIndices)
                let selectedRows = selectedRowIndicesArray.map { dataSource[$0] }
                
                selectionAction?(selectedRowIndex, dataSource[selectedRowIndex])
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                tableView.reloadData()
                return
            }
        }
        
        // Perform single selection logic
        selectedRowIndices.removeAll()
        selectedRowIndices.insert(selectedRowIndex)
        selectionAction?(selectedRowIndex, dataSource[selectedRowIndex])
        hide()
    
    }

    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if searchBar.isFirstResponder {
//            searchBar.resignFirstResponder()
//        }
    }
}

//MARK: - Auto dismiss

extension FullScreenDropDown {

    @objc
    fileprivate func dismissableViewTapped() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        cancel()
    }
    
    @objc
    fileprivate func reloadButtonAction() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        reloadAction?()
    }
    
    public func startLoading() {
        trailingReloadButton.isHidden = true
        trailingProcessingView.startAnimating()
    }
    
    public func stopLoading() {
        trailingReloadButton.isHidden = false
        trailingProcessingView.stopAnimating()
    }

}

//MARK: - Keyboard events

extension FullScreenDropDown {

    /**
    Starts listening to keyboard events.
    Allows the drop down to display correctly when keyboard is showed.
    */
    @objc public static func startListeningToKeyboard() {
        KeyboardListener.sharedInstance.startListeningToKeyboard()
    }

    fileprivate func startListeningToKeyboard() {
        KeyboardListener.sharedInstance.startListeningToKeyboard()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardUpdate),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardUpdate),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    fileprivate func stopListeningToNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    fileprivate func keyboardUpdate() {
        self.setNeedsUpdateConstraints()
    }

}


extension FullScreenDropDown: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
//        search?("")
//        filteredBeneficiaries = beneficiaries
//        tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAction?(searchText)
    }
}
