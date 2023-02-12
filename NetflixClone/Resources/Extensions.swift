//
//  Extensions.swift
//  NetflixClone
//
//  Created by Lore P on 11/02/2023.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
