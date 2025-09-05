//
//  FavoriteCompany.swift
//  Compounded
//
//  Created by Lulwah almisfer on 05/09/2025.
//

import SwiftData

@Model
class FavoriteCompany {
    @Attribute(.unique) var id: String
    var nameAr: String
    var nameEn: String
    
    init(id: String, nameAr: String, nameEn: String) {
        self.id = id
        self.nameAr = nameAr
        self.nameEn = nameEn
    }
}
