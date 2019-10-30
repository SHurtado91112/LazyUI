//
//  LUICollectionViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 10/30/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

class LUICollectionViewController: UICollectionViewController, LUIViewControllerProtocol {
    // MARK: - Public variables
    open var sectionData: [Any] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    open var sectionItemData: [[Any]]  = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    open var itemData: [Any] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Private variables
    private var _navigation: LUINavigationViewController?
    private let ESTIMATE_ROW_HEIGHT: CGFloat = 48.0
    
    private var itemIdentifier = ""
    private var itemType = LUICollectionCell.self
    
    private var sectionIdentifier = ""
    private var sectionType = LUICollectionHeaderView.self
    
    public required init(itemType: LUICollectionCell.Type, itemIdentifier: String, layout: UICollectionViewLayout, sectionType: LUICollectionHeaderView.Type? = nil, sectionIdentifier: String? = nil) {
        super.init(collectionViewLayout: layout)
        self.itemIdentifier = itemIdentifier
        self.itemType = itemType
        
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
        
        if let selectedItems = self.collectionView.indexPathsForSelectedItems {
            
            for item in selectedItems {
                self.collectionView.deselectItem(at: item, animated: true)
            }
            
        }
    }
    
    open func setUpViews() {
        self.collectionView.register(self.itemType, forCellWithReuseIdentifier: self.itemIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.definesPresentationContext = true
    }
    
    open func resetCells(for type: LUICollectionCell.Type, cellIdentifier: String) {
        self.itemIdentifier = cellIdentifier
        self.itemType = type
        self.collectionView.register(self.itemType, forCellWithReuseIdentifier: self.itemIdentifier)
    }

    private var hasSections: Bool {
        return self.sectionItemData.count > 0
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  self.hasSections ? self.sectionItemData.count : 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hasSections ? self.sectionItemData[section].count : self.itemData.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier, for: indexPath) as? LUICollectionCell else {
            return LUICollectionCell()
        }
        
        let data = self.hasSections ? self.sectionItemData[indexPath.section][indexPath.row] : self.itemData[indexPath.row]
        if let cell = cell as? LUICellData {
            cell.formatCell(for: data)
        } else {
            fatalError("Cell subclass must conform to LUICellData")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: self.sectionIdentifier,
              for: indexPath) as? LUICollectionHeaderView
         
            let data = self.sectionData[indexPath.section]
            if let headerView = headerView as? LUICellData {
                headerView.formatCell(for: data)
            } else {
                fatalError("Header view subclass must conform to LUICellData")
            }
            
            return headerView ?? LUICollectionHeaderView()
        }
        
        return LUICollectionHeaderView()
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
    
}

extension LUICollectionViewController: LUINavigation {
    
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
