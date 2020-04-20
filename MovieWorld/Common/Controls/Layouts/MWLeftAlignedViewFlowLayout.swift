//
//  MWLeftAlignedViewFlowLayout.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 20.04.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWLeftAlignedViewFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: UICollectionViewDelegateFlowLayout?
    
    private let numberOfRows = 2
    private let cellPadding: CGFloat = 8
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentWidth: CGFloat = 0
    
    private var contentHeight: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        let insets = collectionView.contentInset
        
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        let paddingHeight = CGFloat(self.numberOfRows - 1) * self.cellPadding
        let rowHeight = (self.contentHeight - paddingHeight) / CGFloat(self.numberOfRows)
        var yOffset: [CGFloat] = []
        for row in 0..<self.numberOfRows {
            let topMargin = row == 0 ? self.sectionInset.top : self.cellPadding
            yOffset.append(CGFloat(row) * rowHeight + topMargin)
        }
        
        var xOffset: [CGFloat] = .init(repeating: 0, count: self.numberOfRows)
        var row = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            row = item % 2 == 0 ? 0 : 1
            
            let indexPath = IndexPath(item: item, section: 0)

            let size: CGSize = self.delegate?.collectionView?(
                collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
                        
            let frame = CGRect(x: xOffset[row],
                               y: yOffset[row],
                               width: size.width,
                               height: size.height)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)

            self.contentWidth = max(self.contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + size.width + self.cellPadding
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
}
