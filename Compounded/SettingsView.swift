//
//  SettingsView.swift
//  Compounded
//
//  Created by lulwah on 30/12/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        List {
            
            MemberView(name: "Hailah",link: "https://www.linkedin.com/in/hailah-almudayfir-40981b21b",role: "UI/UX Designer")
            .frame(height: 80)
                MemberView(name: "Lulu",link: "https://www.linkedin.com/in/lulwahalmisfer",role: "iOS Developer")
                .frame(height: 80)
             
            
            VStack(alignment: .leading){
                Text("What is compound interest ?").font(.headline).foregroundStyle(Color("AccentColor"))
                Text("It is the interest on a loan or deposit calculated based on both the initial principal and the accumulated interest from previous periods. basically when you earn interest on both the money you've saved and the interest you earn.").font(.subheadline)
            }
            
            Link("Rate Us ⭐️", destination: URL(string: "https://apps.apple.com/app/id1580068094?action=write-review")!)
            
            Button("Change language") {
                Helper.goToAppSetting()
            }
            
        }
    }
}

#Preview {
    SettingsView()
}
#Preview("arabic") {
    SettingsView()
        .environment(\.locale,Locale(identifier: "AR"))
}

struct MemberView: View {
    var name = ""
    var link = ""
    var role = ""
    var body: some View {
        HStack{
            Image(name).resizable().scaledToFit()
            VStack(alignment:.leading){
                Text(LocalizedStringKey(name)).font(.headline)
                Link("LinkedIn", destination: URL(string:link)!).font(.headline)
                Text(LocalizedStringKey(role))
            }
        }
    }
}
