//
//  MWLeftAlignedViewFlowLayout.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 20.04.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

class MWLeftAlignedViewFlowLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let original = super.layoutAttributesForElements(in: rect) else { return nil }
        
        let attributes = original.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        for (_, rowAttributes) in Dictionary(grouping: attributes, by: { ($0.center.y) }) {
            for (index, attribute) in rowAttributes.enumerated() {
                if index == 0 {
                    attribute.frame.origin.x = self.sectionInset.left
                } else {
                    let previous = rowAttributes[index - 1].frame
                    attribute.frame.origin.x =
                        previous.minX + previous.width + self.minimumInteritemSpacing
                }
            }
        }
        return attributes
    }
}
