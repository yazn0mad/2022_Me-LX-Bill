//
//  CalculatorView.swift
//  Me LX Bill
//
//  Created by Yazz Tanaka on 29/12/2022.
//

import SwiftUI

struct CalculatorView: View {
    
    @State private var kwhInput: Int = 0
    
    // EditorView setup
    @State var editorRates = EditorRates(editorBR: 0.0, editorL1: 0.0, editorL2: 0.0, editorR1: 0.0, editorR2: 0.0, editorR3: 0.0, editorFee: 0.0, editorLevy: 0.0)
    @State var editorStatus = EditorStatus(isEdited: false)
    
    // ConverterView setup
    @State var showConverter: Bool = false

    // Load new data passed from EditorView
    private var editedRates: Int {
        Calculate(basicRate: editorRates.editorBR,
                  limit_1: editorRates.editorL1,
                  limit_2: editorRates.editorL2,
                  rate_1: editorRates.editorR1,
                  rate_2: editorRates.editorR2,
                  rate_3: editorRates.editorR3,
                  fee: editorRates.editorFee,
                  levy: editorRates.editorLevy,
                  kwh: Double(kwhInput))
    }
    
    // Load old data from UserDefaults
    private var savedRates: Int {
        Calculate(basicRate: UserDefaults.standard.double(forKey: "basicRate"),
                  limit_1: UserDefaults.standard.double(forKey: "limit_1"),
                  limit_2: UserDefaults.standard.double(forKey: "limit_2"),
                  rate_1: UserDefaults.standard.double(forKey: "rate_1"),
                  rate_2: UserDefaults.standard.double(forKey: "rate_2"),
                  rate_3: UserDefaults.standard.double(forKey: "rate_3"),
                  fee: UserDefaults.standard.double(forKey: "fee"),
                  levy: UserDefaults.standard.double(forKey: "levy"),
                  kwh: Double(kwhInput))
    }
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(AppColor._CY))
                VStack {
                    HStack {
                        Text("Meter-Rate Lighting")
                            .foregroundColor(AppColor._Black)
                            .font(.title)
                            .opacity(0.8)
                            .padding(.leading)
                        Spacer()
                        
                        NavigationLink(destination: EditorView(editorRates: $editorRates, editorStatus: $editorStatus)) {
                            Image(systemName: "doc.badge.gearshape")
                                .imageScale(.small)
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                                .padding(.trailing)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        Text("How much?")
                            .font(.headline)
                            .opacity(0.8)
                            .padding(.leading)
                            .padding(.trailing)
                        
                        if UserDefaults.standard.bool(forKey: "isSaved") {
                            Text("¥" + "\(savedRates)")
                                .font(.title)
                                .padding()
                            
                        } else {
                            Text("¥" + "\(editedRates)")
                                .font(.title)
                                .padding()
                        }
                        
                        HStack {
                            Text("✎")
                            TextField("", value: $kwhInput, formatter: Self.formatter)
                                .foregroundColor(AppColor._Black)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                
                            Text("kWh")
                            Button {
                                hideKeyboard()
                                kwhInput = 0
                                self.kwhInput = 0
                            } label: {
                                Image(systemName: "arrow.down")
                                    .imageScale(.medium)
                                    .font(.title2)
                                    .padding(.trailing)
                            }
                            .disabled(disableButton)
                            .padding(.trailing, 20)
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    hideKeyboard()
                                    self.showConverter.toggle()
                                }
                            }) {
                                Image(systemName: "w.circle")
                                    .imageScale(.medium)
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                            }
                        }
                    }
                    .padding()
                    .background(.cyan .opacity(0.8))
                }
                
                if showConverter {
                    ConverterView(showConverter: $showConverter)
                        .transition(AnyTransition.move(edge: .bottom))
                }
                
            } // end of ZStack
            .edgesIgnoringSafeArea(.all)
            .onDisappear() {
                kwhInput = 0
            }
        }
    }
    
    var disableButton: Bool {
        kwhInput == 0
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
