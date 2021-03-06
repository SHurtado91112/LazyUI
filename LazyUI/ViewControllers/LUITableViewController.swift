//
//  LUITableViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 7/14/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

public protocol LUISearchTableDelegate {
    func selectedScopeDidChange(index: Int)
}

public typealias LUISearchTableQuery = (_ item: Any, _ text: String, _ scope: Int)->Bool

open class LUITableViewController: UITableViewController, LUIViewControllerProtocol {
    
    // MARK: - Public variables
    open var sectionHeaderData: [LUIHeaderData] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    open var sectionCellData: [[Any]]  = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    open var rowData: [Any] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    open var scopeData: [String] = [] {
        didSet {
            self.searchController.searchBar.scopeButtonTitles = self.scopeData
            self.searchController.searchBar.showsScopeBar = true
            self.searchController.searchBar.delegate = self
            
            let keyboardToolbar = LUIKeyboardToolBar()
            keyboardToolbar.keyboardDelegate = self
            
            self.searchController.searchBar.inputAccessoryView = keyboardToolbar
        }
    }
    
    open var delegate: LUISearchTableDelegate?
    
    // MARK: - Private variables
    private var _navigation: LUINavigationViewController?
    private var selectedScopeIndex : Int = 0
    private let ESTIMATE_ROW_HEIGHT: CGFloat = 48.0

    private lazy var searchController: LUISearchController = {
        let controller = LUISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        
        controller.definesPresentationContext = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        
        return controller
    } ()
    
    private var searchCriteria: LUISearchTableQuery? = nil
    
    private var filteredRowData: [Any] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var searchBarIsEmpty: Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return self.searchController.isActive && !self.searchBarIsEmpty
    }
    
    private var cellIdentifier = ""
    private var cellType = LUITableCellClass.self
    
    private var sectionIdentifier = ""
    private var sectionType = LUITableHeaderViewClass.self
    
    public required init(cellType: LUITableCellClass.Type, cellIdentifier: String, sectionType: LUITableHeaderViewClass.Type? = nil, sectionIdentifier: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.cellIdentifier = cellIdentifier
        self.cellType = cellType
        
        if let sectionType = sectionType, let sectionIdentifier = sectionIdentifier {
            self.sectionIdentifier = sectionIdentifier
            self.sectionType = sectionType
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public functions
    
    override open func viewDidLoad() {
        self.setUpViews()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedRows = self.tableView.indexPathsForSelectedRows {
            
            for row in selectedRows {
                self.tableView.deselectRow(at: row, animated: true)
            }
        }
        
        self.registerForThemeObserver()
    }
    
    deinit {
        self.unregisterForThemeObserver()
    }
    
    open func setUpViews() {
        self.tableView.register(self.cellType, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = self.ESTIMATE_ROW_HEIGHT
        self.tableView.rowHeight = UITableView.automaticDimension

        self.tableView.separatorColor = UIColor.color(for: .border)
        self.definesPresentationContext = true
    }
    
    open func resetCells(for type: LUITableCellClass.Type, cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        self.cellType = type
        self.tableView.register(self.cellType, forCellReuseIdentifier: self.cellIdentifier)
    }

    private var hasSections: Bool {
        return self.sectionCellData.count > 0
    }
    
    // MARK: - Table view data source
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return self.hasSections ? self.sectionCellData.count : 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasSections {
            return self.sectionCellData[section].count
        } else {
            // search and filtering not available for multiple sections
            return self.isFiltering ? self.filteredRowData.count : self.rowData.count
        }
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? LUITableCell else {
            return LUITableCellClass()
        }
        
        var data: Any
        if self.hasSections {
            data = self.sectionCellData[indexPath.section][indexPath.row]
        } else {
            data = self.isFiltering ? self.filteredRowData[indexPath.row] : self.rowData[indexPath.row]
        }
        
        cell.formatCell(for: data)
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = self.sectionType.init() as? LUITableHeaderView else {
            return LUITableHeaderViewClass()
        }
        
        let data = self.sectionHeaderData[section]
        headerView.formatCell(for: data)
        
        return headerView
    }
    
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.hasSections {
            let height = self.sectionHeaderData[section].headerHeight
            let hasCells = self.sectionCellData[section].count > 0
            return hasCells ? height : .zero
        }
        return 0.0
    }
    
    override open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    open func setUpForSearch(with criteria: LUISearchTableQuery? = nil) {
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchCriteria = criteria
    }
    
    // MARK: - Adding Views and Constraints
    
    public func addView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    public func centerX(_ view: UIView) {
        self.view.centerX(view)
    }
    
    public func centerY(_ view: UIView) {
        self.view.centerY(view)
    }
    
    public func center(_ view: UIView) {
        self.view.center(view)
    }
    
    public func fill(_ view: UIView, padding: LUIPaddingType = .none) {
        self.view.fill(view, padding: padding)
    }
    
    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        childController.didMove(toParent: self)
    }
    
    // MARK: - Private functions
    
    private func filterSearch(for text: String) {
        guard let query = self.searchCriteria else { return }
        
        self.filteredRowData = rowData.filter { (item) -> Bool in
            return query(item, text, self.selectedScopeIndex)
        }
    }
}

extension LUITableViewController: LUINavigation {
    
    // MARK: - Navigation
    public var navigation: LUINavigationViewController? {
        get {
            if let navController = self.navigationController as? LUINavigationViewController, self._navigation == nil {
                self._navigation = navController
            }
            return self._navigation
        }
        set {
            self._navigation = newValue
        }
    }
    
    public func push(to vc: UIViewController) {
        if let navigation = self.navigation {
            navigation.push(to: vc)
        } else {
            let navigation = LUINavigationViewController(rootVC: vc)
            self.navigation = navigation
            self.present(navigation)
        }
    }
    
    public func pop() {
        if let navigation = self.navigation {
            navigation.popViewController(animated: true)
        }
    }
    
    public func popToRoot() {
        if let navigation = self.navigation {
            navigation.popToRootViewController(animated: true)
        }
    }
    
    public func present(_ vc: UIViewController) {
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    public func presentModally(_ vc: UIViewController) {
        self.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    public func presentNavigation(_ vc: UIViewController) {
        let nav = LUINavigationViewController(rootVC: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    public func popOver(_ vc: UIViewController) {
        let popOver = LUIPopOverViewController(contentVC: vc)
        LUIPopOverViewController.current = popOver
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(popOver.view)
        currentWindow?.fill(popOver.view, padding: .none)
    }
    
    public func dissmissableNavigation() -> LUINavigationViewController {
        return LUINavigationViewController(rootVC: self, largeTitle: false).forDismissal()
    }
}

extension LUITableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.selectedScopeIndex = selectedScope
        self.delegate?.selectedScopeDidChange(index: selectedScope)
        self.filterSearch(for: searchBar.text ?? "")
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.filterSearch(for: searchController.searchBar.text ?? "")
    }
    
}

extension LUITableViewController: LUIKeyboardToolBarDelegate {
    public func dismissRequested() {
        self.searchController.searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    public func canGoToPrevious() -> Bool {
        return false
    }
    
    public func canGoToNext() -> Bool {
        return false
    }
    
    public func previousFieldRequested() {
        //
    }
    
    public func nextFieldRequested() {
        //
    }
}

extension LUITableViewController: LUIThemeProtocol {
    
    @objc func themeUpdated() {
        self.view.backgroundColor = .color(for: .lightBackground)
        self.tableView.backgroundColor = .color(for: .lightBackground)
        self.tableView.reloadData()
    }
    
    func registerForThemeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeUpdated), name: LUIThemeUpdateNotification, object: nil)
    }

    func unregisterForThemeObserver() {
        NotificationCenter.default.removeObserver(self, name: LUIThemeUpdateNotification, object: nil)
    }
}
