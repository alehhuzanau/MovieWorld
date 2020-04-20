//
//  MWLeftAlignedViewFlowLayout.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 20.04.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

protocol MWLeftAlignedDelegateViewFlowLayout: AnyObject {
    var numberOfRows: Int { get }
    var cellPadding: CGFloat { get }
    
    func collectionView(_ collectionView: UICollectionView,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
}

class MWLeftAlignedViewFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: MWLeftAlignedDelegateViewFlowLayout?
        
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
        guard cache.isEmpty == true, let collectionView = collectionView,
            let numberOfRows = self.delegate?.numberOfRows,
            let cellPadding = self.delegate?.cellPadding else { return }
        
        let paddingHeight = CGFloat(numberOfRows - 1) * cellPadding
        let rowHeight = (self.contentHeight - paddingHeight) / CGFloat(numberOfRows)
        var yOffset: [CGFloat] = []
        for row in 0..<numberOfRows {
            let topMargin = row == 0 ? 0 : CGFloat(row) * cellPadding
            yOffset.append(CGFloat(row) * rowHeight + topMargin)
        }
        var xOffset: [CGFloat] = .init(repeating: 0, count: numberOfRows)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            guard let min = xOffset.min(), let row = xOffset.firstIndex(of: min),
                let size: CGSize = self.delegate?.collectionView(
                    collectionView, sizeForItemAt: indexPath) else { return }
            
            let frame = CGRect(x: xOffset[row],
                               y: yOffset[row],
                               width: size.width,
                               height: rowHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            
            self.contentWidth = max(self.contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + size.width + cellPadding
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
