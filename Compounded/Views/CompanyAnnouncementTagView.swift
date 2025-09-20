//
//  CompanyAnnouncementTagView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 20/09/2025.
//
import SwiftUI

struct CompanyAnnouncementTagView: View {
    var type :TypeEnum
    
    var body: some View {
        HStack(spacing: 3){
            Text(.init(type.title))
                .bold()
            Image(systemName: type.imageTitle)
        }
        .font(.system(size: 12))
        .foregroundStyle(.white)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(6)
        .padding(.horizontal,4)
        .background(
            Capsule()
                .fill(Color(type.color))
        )
        
    }
}
