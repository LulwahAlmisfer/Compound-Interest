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
                Section(header: Text("Information") .textCase(nil)) {
                    TextField("Initail deposit", value: $viewModel.initialDeposit,formatter: NumberFormatter.latinDigitsFormatter)
                        .keyboardType(.asciiCapableNumberPad)
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

                    TextField("Contribution Amount", value: $viewModel.contribution, formatter:  NumberFormatter.latinDigitsFormatter)
                        .keyboardType(.asciiCapableNumberPad)
                        .focused($focusedField, equals: .contribution)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .years
                        }

                    Stepper(value: $viewModel.interestRate, in: 0.25...100, step: 0.25) {
                        let formatted = NumberFormatter.latinDigitsFormatter.string(from: NSNumber(value: viewModel.interestRate)) ?? ""
                         Text("Interest Rate \(formatted)%")
                    }

                    TextField("Years", value: $viewModel.years, formatter:  NumberFormatter.latinDigitsFormatter)
                        .keyboardType(.asciiCapableNumberPad)
                        .focused($focusedField, equals: .years)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                }

                Button("Calculate") {
                    withAnimation {
                        DispatchQueue.main.async {
                            focusedField = nil
                            viewModel.calculate()
                        }
                    }
                }

                if !viewModel.results.isEmpty {
                    
                    Section(header: Text("Chart")
                        .textCase(nil)) {
                        VStack {
                            
                            
                            ScrollView(.horizontal) {
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
                                .environment(\.locale, .init(identifier: "en"))
                                .chartLegend(position: .top, alignment: .center)
                                .frame(height: 350)

                                .frame(minWidth: CGFloat(viewModel.chartData.count) * 20)
                            }
                            .padding()


                            
                            
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






                    Section(header: Text("Details")
                        .textCase(nil)) {
                        VStack(spacing: 4) {

                            HStack {
                                Text("Year")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 4)

                                Text("Non-Compounded")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text("Compounded")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 4)
                            }
                            .fontWeight(.bold)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.accentColor)

                            .padding(.bottom,4)


                            ForEach(viewModel.results) { result in
                                HStack {
                                    Text(Formatter.withCommas.string(for: result.year) ?? "\(result.year)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 4)
                                    
                                    Text(Formatter.withCommas.string(for: result.nonCompounded) ?? "\(result.nonCompounded)")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    Text(Formatter.withCommas.string(for: result.futureValue) ?? "\(result.futureValue)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 4)
                                }

                                .font(.callout)
                            }
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Calculator")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", action: viewModel.clear)
                }
            }
        }
    }
}

#Preview {
    CompoundInterestView()
}
