//
//  String+Ex.swift
//  MovieWorld
//
//  Created by Анастасия Корнеева on 2/27/20.
//  Copyright © 2020 Clevertec. All rights reserved.
//

import Foundation

extension String {
    subscript(integerRange: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: integerRange.lowerBound)
        let end = index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return String(self[range])
    }
    
    subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        return withVaList(args) {
            return NSString(format: localized, arguments: $0) as String
        }
    }
}
