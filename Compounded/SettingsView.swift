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
                Text("What is compound intrest?").font(.headline).foregroundStyle(Color("AccentColor"))
                Text("In simple terms, compound interest can be defined as interest you earn on interest. With a savings account that earns compound interest, you earn interest on the principal (the initial amount deposited) plus on the interest that accumulates over time.").font(.subheadline)
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

struct MemberView: View {
    var name = ""
    var link = ""
    var role = ""
    var body: some View {
        HStack{
            Image(name).resizable().scaledToFit()
            VStack(alignment:.leading){
                Text(name).font(.headline)
                Link("LinkedIn", destination: URL(string:link)!).font(.headline)
                Text(role)
            }
        }
    }
}
