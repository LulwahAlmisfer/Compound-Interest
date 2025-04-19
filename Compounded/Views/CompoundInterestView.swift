//
//  CompoundInterestView.swift
//  Compounded
//
//  Created by Lulwah almisfer on 18/04/2025.
//

import SwiftUI
import Charts

struct CompoundInterestView: View {
    @StateObject private var viewModel = CompoundInterestViewModel()

    enum Field: Hashable {
        case initialDeposit, contribution, years
    }

    @FocusState private var focusedField: Field?


    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Inputs")) {
                    TextField("Initial Deposit", value: $viewModel.initialDeposit, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .initialDeposit)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .contribution
                        }

                    Picker("Contribution Frequency", selection: $viewModel.isMonthly) {
                        Text("Monthly").tag(true)
                        Text("Yearly").tag(false)
                    }
                    .pickerStyle(.segmented)

                    TextField("Contribution Amount", value: $viewModel.contribution, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .contribution)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .years
                        }

                    Stepper(value: $viewModel.interestRate, in: 0...100, step: 0.25) {
                        Text("Interest Rate: \(viewModel.interestRate, specifier: "%.2f")%")
                    }

                    TextField("Years", value: $viewModel.years, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .years)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                }

                Button("Calculate") {
                    withAnimation {
                        focusedField = nil 
                        viewModel.calculate()
                    }
                }

                if !viewModel.results.isEmpty {
                    
                    Section(header: Text("Chart")) {
                        VStack {
                            
                            
                            Chart {
                                ForEach(viewModel.chartData) { entry in
                                    BarMark(
                                        x: .value("Year", String(entry.year)),
                                        y: .value("Value", entry.value)
                                    )
                                    .position(by: .value("Type", entry.type))
                                    .foregroundStyle(
                                        entry.type == "Non-Compounded" ? Color.green :
                                            entry.type == "Compounded" ? Color.accentColor : Color.blue
                                    )
                                }
                            }
                            .chartLegend(position: .top, alignment: .center)
                            .frame(height: 300)
                            .padding(.bottom)
                            
                            
                            HStack {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 7, height: 7)
                                Text("Non-Compounded")
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 7, height: 7)
                                Text("Compounded")
                                Spacer()
                            }
                            .font(.caption2)
                        }
                    }






                    Section(header: Text("Details")) {
                        VStack(spacing: 4) {

                            HStack {
                                Text("Year")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                             
                                Text("Non-Compounded")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text("Compounded")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .fontWeight(.bold)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.accentColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom,4)


                            ForEach(viewModel.results) { result in
                                HStack {
                                    Text("\(result.year)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading,4)
                                
                                    Text("\(Int(result.nonCompounded))")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    Text("\(Int(result.futureValue))")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing,4)

                                }
                                .font(.callout)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calculator")
            .onAppear{ PickerStyle() }
            .environment(\.locale, .init(identifier: Locale.current.languageCode ?? "en"))
        }
    }
}

#Preview {
    CompoundInterestView()
}
