//
//  UICollectionView+Ex.swift
//  MovieWorld
//
//  Created by Aleh Huzanau on 16.05.2020.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import UIKit

extension UICollectionView {
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = self.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}
