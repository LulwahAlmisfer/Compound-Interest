//
//  MainView.swift
//  Compounded
//
//  Created by lulwah on 30/12/2023.
//

import SwiftUI
import Charts
struct MainView: View {
    
    @State var initialDeposit = ""
    @State var years = ""
    @State var selected = 0
    @State var contribution = ""
    @State var rate = 5.0
    @State var show = false
    @State private var goToSettings = false
    @State private var showingAlert = false
    @FocusState private var fieldIsFocused: Bool

    @State var AllData = [Object]()
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing:10) {
                ScrollView{
                    ScrollViewReader{ proxy in
                    HStack{
                        Spacer()
                        Button("Clear") {
                            initialDeposit = ""
                            years = ""
                            selected = 0
                            contribution = ""
                            rate = 5.0
                            show = false
                        }
                        
                    }
                    HStack {
                        Text("Initail deposit: ").foregroundColor(.primary)
                        
                        TextField("Amount", text: $initialDeposit)
                            .focused($fieldIsFocused)
                            .keyboardType(.asciiCapableNumberPad)
                            .textFieldStyle(.roundedBorder)
                        
                    }.padding()
                    
                    Picker(selection: $selected, label: Text("Picker")) {
                        Text("monthly").tag(0)
                        Text("yearly").tag(1)
                    }.pickerStyle(.segmented)
                        .padding()
                    
                    HStack {
                        Text("Contributions: ").foregroundColor(.primary)
                        TextField("Amount", text: $contribution)
                            .focused($fieldIsFocused)
                            .keyboardType(.asciiCapableNumberPad)
                            .textFieldStyle(.roundedBorder)
                    }.padding()
                    
                    HStack {
                        Text("Rate: ").foregroundColor(.primary)
                        TextFieldStepper(value: $rate)
                        
                    }.padding()
                    
                    HStack {
                        Text("Years: ").foregroundColor(.primary)
                        
                        TextField("Length of time", text: $years)
                            .padding()
                            .focused($fieldIsFocused)
                            .keyboardType(.asciiCapableNumberPad)
                            .textFieldStyle(.roundedBorder)
                    }.padding()
                    
                    Button("Calculate") {
                        withAnimation(.default) {
                            if let initialDeposit = initialDeposit.toDouble() ,
                               let contribution = contribution.toDouble() ,
                               let years = years.toInt()
                            {
                                AllData =  self.calc(initialDeposit : initialDeposit, yearlyCont :  selected == 0 ? 12*contribution:contribution, rate :rate / 100 ,years : years)
                                show = true
                                fieldIsFocused = false
                                proxy.scrollTo(0,anchor: .bottom)

                            } else {
                                showingAlert.toggle()
                            }
                        }
                    }
                    .padding(.bottom)
                    .buttonStyle(BorderedButtonStyle())
                    
                    if show {
                        Chart {
                            ForEach(AllData) { obj in
                                ForEach(obj.DataByYear, id: \.month) { Data in
                                    BarMark(
                                        x: .value("years", Data.0),
                                        y: .value("amount", Data.amount)
                                    )
                                    .position(by: .value("Product", obj.name))
                                    .foregroundStyle(by: .value("Product", obj.name))
                                }
                            }
                        }.chartForegroundStyleScale(
                            range: Gradient (
                                colors: [
                                    .green,
                                    .accentColor
                                ]
                            )
                        )
                        .frame(height:400)
                    }
                    
                    if show {
                        ListView(AllData: $AllData)
                    }
                }
                }//scroll end
            }.padding(.horizontal)
                .sheet(isPresented: $goToSettings) {
                    SettingsView()
                        .presentationDetents([.large])
                }
                .toolbar {
                    Button(role: .destructive, action: {
                        goToSettings = true
                    }) {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                }
                .alert("Check all the fields", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            
                .navigationTitle(Text("Compounded"))
        }
        .onAppear{ PickerStyle() }
        .padding(.top)
    }
    
    func calc(initialDeposit : Double, yearlyCont : Double,rate : Double ,years : Int) -> [Object] {
        
        var without = Object(name: "Total Contributions", Data: [])
        var with    = Object(name: "Future Value"  ,  Data: [])
        
        for i in 0...years{
            if i == 0 {
                without.Data.append(initialDeposit)
            } else {
                without.Data.append(without.Data.last! + yearlyCont)
            }
        }
        for i in 0...years {
            if i == 0 {
                with.Data.append(initialDeposit.englishFormatted())
            } else {
                with.Data.append((with.Data.last!*(1+rate)+yearlyCont
                                 ).englishFormatted())
            }
        }
        return [without , with]
    }
    
}

#Preview {
    MainView()
}
