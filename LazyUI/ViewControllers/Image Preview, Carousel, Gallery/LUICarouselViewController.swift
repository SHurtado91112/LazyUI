//
//  LUICarouselViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 11/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

fileprivate protocol LUICarouselCollectionViewControllerDelegate {
    func didEndDecelerating(to index: Int)
    func preview(image: UIImage)
}

fileprivate class LUICarouselCollectionViewController: LUICollectionViewController {
    
    var delegate: LUICarouselCollectionViewControllerDelegate?
    
    convenience init(layout: UICollectionViewLayout) {
        self.init(itemType: LUICarouselCell.self, itemIdentifier: LUICarouselCell.identifier, layout: layout)
    }
    
    override open func setUpViews() {
        super.setUpViews()
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.view.clipsToBounds = true
        
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        if let cell = cell as? LUICarouselCell {
            cell.delegate = self
        }
        
        return cell
    }
    
    
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.didEndDecelerating(to: Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))
    }
}

extension LUICarouselCollectionViewController: LUICarouselCellDelegate {
    func previewRequested(for image: UIImage) {
        self.delegate?.preview(image: image)
    }
}

open class LUICarouselViewController: LUIViewController {
    
    public enum PagePosition {
        case aboveBaseline
        case belowBaseline
    }
    
    open var photos : [UIImage] = [] {
        didSet {
            self.imagePreviewManager.previewContent = self.photos
            self.pageControl.numberOfPages = self.photos.count
            self.collectionViewController?.itemData = self.photos
            self.view.isHidden = self.photos.count == 0
        }
    }
    
    open var cornerRadius: CGFloat = .zero {
        didSet {
            self.collectionViewController?.view.roundCorners(to: self.cornerRadius)
        }
    }
    
    open private(set) var pagePosition: PagePosition = .aboveBaseline
    private lazy var pageControl : LUIPageControl = {
        let pageControl = LUIPageControl()
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.delegate = self
        return pageControl
    } ()
    
    open var currentPage: Int {
        get {
            return self.pageControl.currentPage
        }
        set {
            self.pageControl.currentPage = newValue
            self.imagePreviewManager.currentPage = newValue
            self.imagePreviewManager.setController()
        }
    }
    
    fileprivate var collectionViewController: LUICarouselCollectionViewController?
    
    private lazy var imagePreviewManager : LUIPreviewManagerViewController = {
        let ipM = LUIPreviewManagerViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        ipM.previewDelegate = self
        return ipM
    } ()
    
    public convenience init(itemSize: CGSize, pagePosition: PagePosition = .aboveBaseline) {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        self.init(nibName: nil, bundle: nil)
        
        self.pagePosition = pagePosition
        self.collectionViewController = LUICarouselCollectionViewController(layout: flowLayout)
        self.collectionViewController?.delegate = self
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setUpViews() {

        self.addView(self.pageControl)
        
        if let collectionViewController = self.collectionViewController {
            collectionViewController.view.backgroundColor = .color(for: .darkBackground)
            
            self.addChild(collectionViewController)
            self.addView(collectionViewController.view)
            
            self.view.top(collectionViewController.view, fromTop: true, paddingType:
                .none, withSafety: false)
            self.view.bottom(collectionViewController.view, fromTop: false, paddingType: .large, withSafety: false)
            self.view.left(collectionViewController.view, fromLeft: true, paddingType: .none, withSafety: false)
            self.view.right(collectionViewController.view, fromLeft: false, paddingType: .none, withSafety: false)
            
            collectionViewController.collectionView.centerX(self.pageControl)
            collectionViewController.collectionView.bottom(self.pageControl, fromTop: self.pagePosition == .belowBaseline, paddingType: .none, withSafety: false)
        }
        
    }
    
    
}

extension LUICarouselViewController: LUIPreviewDelegate {
    
    public func pageChanged() {
        self.pageControl.currentPage = self.imagePreviewManager.currentPage
        
        // TODO: check content offset
        
        if let collectionView = self.collectionViewController?.collectionView {
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(self.pageControl.currentPage), y: 0.0), animated: true)
        }
    }
    
    public func dismissedPreview() {
        // do nothing
    }
     
}

extension LUICarouselViewController: LUIPageControlDelegate {
    
    public func pageControlUpdated(sender: UIPageControl) {
        let index = sender.currentPage
        self.imagePreviewManager.currentPage = index
        self.imagePreviewManager.setController()
    }
    
}

extension LUICarouselViewController: LUICarouselCollectionViewControllerDelegate {
    func didEndDecelerating(to index: Int) {
        self.pageControl.currentPage = index
    }
    
    func preview(image: UIImage) {
        self.imagePreviewManager.currentPage = self.pageControl.currentPage
        self.imagePreviewManager.setController()
        self.navigation?.present(self.imagePreviewManager.dissmissableNavigation())
    }
}
