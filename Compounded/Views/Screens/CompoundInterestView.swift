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
    @State private var selectedResult: CompoundInterestResult? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information").textCase(nil)) {
                    TextField("Initial Deposit", value: $viewModel.initialDeposit, formatter: NumberFormatter.latinDigitsFormatter)
                        .keyboardType(.asciiCapableNumberPad)
                        .focused($focusedField, equals: .initialDeposit)
                        .submitLabel(.next)
                        .multilineTextAlignment(strategy: .layoutBased)
                        .onSubmit { focusedField = .contribution }

                    Picker("Contribution Frequency", selection: $viewModel.isMonthly) {
                        Text("Monthly").tag(true)
                        Text("Yearly").tag(false)
                    }
                    .pickerStyle(.segmented)

                    TextField("Contribution Amount", value: $viewModel.contribution, formatter: NumberFormatter.latinDigitsFormatter)
                        .keyboardType(.asciiCapableNumberPad)
                        .focused($focusedField, equals: .contribution)
                        .submitLabel(.next)
                        .multilineTextAlignment(strategy: .layoutBased)
                        .onSubmit { focusedField = .years }

                    Stepper(value: $viewModel.interestRate, in: 0.25...100, step: 0.25) {
                        let formatted = NumberFormatter.latinDigitsFormatter.string(from: NSNumber(value: viewModel.interestRate)) ?? ""
                        Text("Interest Rate \(formatted)%")
                    }

                    TextField("Years", value: $viewModel.years, formatter: NumberFormatter.latinDigitsFormatter)
                        .keyboardType(.asciiCapableNumberPad)
                        .focused($focusedField, equals: .years)
                        .submitLabel(.done)
                        .multilineTextAlignment(strategy: .layoutBased)
                        .onSubmit { focusedField = nil }
                }

                Button {
                    withAnimation {
                        focusedField = nil
                        viewModel.calculate()
                    }
                } label: {
                    Text("Calculate")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }

                if !viewModel.results.isEmpty {
                    if let last = viewModel.results.last {
                        Section(header: Text("Summary").textCase(nil)) {
                            SummaryCard(result: last)
                        }
                    }

                    Section(header: Text("Chart").textCase(nil)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tap a bar to see year details")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)

                            ScrollView(.horizontal, showsIndicators: false) {
                                Chart {
                                    ForEach(viewModel.chartData) { entry in
                                        BarMark(
                                            x: .value("Year", String(entry.year)),
                                            y: .value("Value", entry.value)
                                        )
                                        .position(by: .value("Type", entry.type))
                                        .cornerRadius(3)
                                        .foregroundStyle(
                                            entry.type == "Non-Compounded" ? Color.green : Color.blue
                                        )
                                    }
                                }
                                .chartLegend(position: .top, alignment: .center)
                                .chartForegroundStyleScale([
                                    "Non-Compounded": Color.green,
                                    "Compounded": Color.blue
                                ])
                                .chartYAxis {
                                    AxisMarks { value in
                                        AxisGridLine()
                                        AxisTick()
                                        AxisValueLabel {
                                            if let doubleVal = value.as(Double.self) {
                                                Text(abbreviatedNumber(doubleVal))
                                                    .font(.caption2)
                                            }
                                        }
                                    }
                                }
                                .chartOverlay { proxy in
                                    GeometryReader { _ in
                                        Rectangle()
                                            .fill(.clear)
                                            .contentShape(Rectangle())
                                            .onTapGesture { location in
                                                if let yearStr: String = proxy.value(atX: location.x),
                                                   let yearInt = Int(yearStr) {
                                                    selectedResult = viewModel.results.first { $0.year == yearInt }
                                                }
                                            }
                                    }
                                }
                                .environment(\.locale, .init(identifier: "en"))
                                .frame(height: 320)
                                .frame(minWidth: CGFloat(viewModel.results.count) * 55)
                            }
                            .padding(.vertical, 8)
                        }
                    }

                    Section(header: Text("Details").textCase(nil)) {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Year")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 4)
                                Text("Invested")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text("Compounded")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 4)
                            }
                            .fontWeight(.bold)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.blue)
                            .padding(.vertical, 8)

                            ForEach(viewModel.results) { result in
                                Divider()
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
                                .padding(.vertical, 6)
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
            .sheet(item: $selectedResult) { result in
                YearDetailSheet(result: result)
            }
        }
    }

    private func abbreviatedNumber(_ value: Double) -> String {
        switch value {
        case 1_000_000_000...:
            return String(format: "%.1fB", value / 1_000_000_000)
        case 1_000_000...:
            return String(format: "%.1fM", value / 1_000_000)
        case 1_000...:
            return String(format: "%.0fK", value / 1_000)
        default:
            return String(format: "%.0f", value)
        }
    }
}

// MARK: - Year Detail Sheet

struct YearDetailSheet: View {
    let result: CompoundInterestResult
    @Environment(\.dismiss) private var dismiss

    private var gain: Double { result.futureValue - result.nonCompounded }
    private var gainPercent: Double {
        guard result.nonCompounded > 0 else { return 0 }
        return (gain / result.nonCompounded) * 100
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Year")
                        Spacer()
                        Text("\(result.year)")
                            .fontWeight(.semibold)
                    }
                }

                Section(header: Text("Invested").textCase(nil)) {
                    HStack {
                        Text("Total Invested")
                        Spacer()
                        Text(Formatter.withCommas.string(for: result.nonCompounded) ?? "")
                            .foregroundStyle(.green)
                            .fontWeight(.medium)
                    }
                }

                Section(header: Text("Compounded").textCase(nil)) {
                    HStack {
                        Text("Final Value")
                        Spacer()
                        Text(Formatter.withCommas.string(for: result.futureValue) ?? "")
                            .foregroundStyle(.blue)
                            .fontWeight(.medium)
                    }
                    HStack {
                        Text("Total Gain")
                        Spacer()
                        Text(Formatter.withCommas.string(for: gain) ?? "")
                            .foregroundStyle(.blue)
                            .fontWeight(.medium)
                    }
                    HStack {
                        Text("Return")
                        Spacer()
                        Text("+\(String(format: "%.1f", gainPercent))%")
                            .foregroundStyle(.blue)
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle(Text("Year \(result.year)"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Summary Card

struct SummaryCard: View {
    let result: CompoundInterestResult

    private var gain: Double { result.futureValue - result.nonCompounded }
    private var gainPercent: Double {
        guard result.nonCompounded > 0 else { return 0 }
        return (gain / result.nonCompounded) * 100
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                summaryItem(title: "Total Invested", value: result.nonCompounded, color: .green)
                Divider().frame(height: 44)
                summaryItem(title: "Final Value", value: result.futureValue, color: .blue)
            }
            Divider()
            HStack(spacing: 0) {
                summaryItem(title: "Total Gain", value: gain, color: .blue)
                Divider().frame(height: 44)
                VStack(spacing: 4) {
                    Text("Return")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("+\(String(format: "%.1f", gainPercent))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func summaryItem(title: String, value: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(Formatter.withCommas.string(for: value) ?? "\(value)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CompoundInterestView()
}
