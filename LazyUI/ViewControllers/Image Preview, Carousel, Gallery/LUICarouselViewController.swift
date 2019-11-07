//
//  LUICarouselViewController.swift
//  LazyUI
//
//  Created by Steven Hurtado on 11/6/19.
//  Copyright © 2019 Steven Hurtado. All rights reserved.
//

import UIKit

open class LUICarouselViewController: LUICollectionViewController {
    
    public enum PagePosition {
        case aboveBaseline
        case belowBaseline
    }
    
    open var photos : [UIImage] = [] {
        didSet {
            self.imagePreviewManager.previewContent = self.photos
            self.pageControl.numberOfPages = self.photos.count
            self.itemData = self.photos
        }
    }
    
    open private(set) var pagePosition: PagePosition = .aboveBaseline
    private lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        return pageControl
    } ()
    
    private lazy var imagePreviewManager : LUIPreviewManagerViewController = {
        let ipM = LUIPreviewManagerViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        ipM.previewDelegate = self
        return ipM
    } ()
    
    public convenience init(itemSize: CGSize, pagePosition: PagePosition = .aboveBaseline) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = itemSize
        
        self.init(itemType: LUICarouselCell.self, itemIdentifier: LUICarouselCell.identifier, layout: flowLayout)
    }
    
    override open func setUpViews() {
        super.setUpViews()
        
        self.addView(self.pageControl)
        self.collectionView.centerX(self.pageControl)
        self.collectionView.bottom(self.pageControl, fromTop: self.pagePosition == .belowBaseline, paddingType: .small, withSafety: false)
                
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
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

extension LUICarouselViewController: LUIPreviewDelegate {
    
    public func pageChanged() {
        self.pageControl.currentPage = self.imagePreviewManager.currentPage
        
        self.collectionView.setContentOffset(CGPoint(x: self.collectionView.frame.width * CGFloat(self.pageControl.currentPage), y: 0.0), animated: true)
    }
    
    public func dismissedPreview() {
        // do nothing
    }
     
}

extension LUICarouselViewController: LUICarouselCellDelegate {
    func previewRequested(for image: UIImage) {
        self.imagePreviewManager.currentPage = self.pageControl.currentPage
        self.imagePreviewManager.setController()
        self.navigation?.present(self.imagePreviewManager.dissmissableNavigation())
    }
}
