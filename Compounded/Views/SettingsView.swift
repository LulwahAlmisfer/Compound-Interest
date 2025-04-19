//
//  SettingsView.swift
//  Compounded
//
//  Created by lulwah on 30/12/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {

                Section(header: Text("Team Members") .textCase(nil)) {
                    MemberView(name: "Hailah", link: "https://www.linkedin.com/in/hailah-almudayfir-40981b21b", role: "UI/UX Designer")
                        .frame(height: 80)
                    MemberView(name: "Lulu", link: "https://www.linkedin.com/in/lulwahalmisfer", role: "iOS Developer")
                        .frame(height: 80)
                }


                Section(header: Text("Information")
                    .textCase(nil)) {
                    VStack(alignment: .leading) {
                        Text("What is compound interest ?")
                            .font(.headline)
                            .foregroundStyle(Color.accentColor)
                        Text("DEF")
                            .font(.subheadline)
                    }
                }


                Section(header: Text("Other")
                    .textCase(nil)) {
                    Link("Rate Us ⭐️", destination: URL(string: "https://apps.apple.com/app/id1580068094?action=write-review")!)
                    
                    Button("Change language") {
                        Helper.goToAppSetting()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Settings")
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
