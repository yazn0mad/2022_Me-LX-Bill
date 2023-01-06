//
//  GuideView.swift
//  Me LX Bill
//
//  Created by Yazz Tanaka on 31/12/2022.
//

import SwiftUI

struct GuideView: View {
    
    var subviews = [
        UIHostingController(rootView: Subview(imageTitle: "welcome")),
        UIHostingController(rootView: Subview(imageTitle: "guide_editor")),
        UIHostingController(rootView: Subview(imageTitle: "guide_converter"))
        ]
    
    var subviewsJP = [
        UIHostingController(rootView: Subview(imageTitle: "welcome_jp")),
        UIHostingController(rootView: Subview(imageTitle: "guide_editor_jp")),
        UIHostingController(rootView: Subview(imageTitle: "guide_converter_jp"))
        ]
    
    var titles = [
        "Welcome to Me LX Bill",
        "Customise rates",
        "W - kWh Converter"
    ]
    var titlesJP = [
        "ミーの従量電灯について",
        "設定値の編集",
        "W - kWh 変換機"
    ]
    
    var text_welcome = Text("This app is fine-tuned for 'Meter-Rate Lighting' contracts offered in Japan. Please refer to your contract and past bills to find your rates.")
    
    var text_editor = Text("Tap ") + (Text(Image(systemName: "doc.badge.gearshape"))).foregroundColor(.cyan) + (Text(" to open the editor to customise your rates. Refer to your bills or your service provider's website to find out your 'Fuel Cost Adjustment Fee' and 'Renewable Energy Generation Levy'."))
    
    var text_converter = Text("Tap ") + (Text(Image(systemName: "w.circle"))).foregroundColor(.cyan) + (Text(" to open the converter and calculate kWh from watts."))
    
    var textStrings = [Text]()
    
    let localeString = Locale.current.language.languageCode?.identifier
    
    init() {
        textStrings = [text_welcome, text_editor, text_converter]
    }
        
    @State var currentPageIndex = 0
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                if localeString != "ja" {
                    Text(titles[currentPageIndex])
                        .font(.title)
                        .padding(.leading)
                        .foregroundColor(AppColor._Black)
                        .padding(.top)
                    
                } else {
                    Text(titlesJP[currentPageIndex])
                        .font(.title)
                        .padding(.leading)
                        .foregroundColor(AppColor._Black)
                        .padding(.top)
                }
                   

                textStrings[currentPageIndex]
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 150, alignment: .leading)
                    .padding(.leading)
                    .lineLimit(nil)
                
                // Subview
                VStack {
                    if localeString != "ja" {
                        PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                    } else {
                        PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviewsJP)
                    }
                }
                .frame(height: 300)
                .padding(.leading)
                .padding(.trailing)
                
                
                VStack {
                    PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                        .disabled(true)
                    
                    HStack {
                        // CHECK CURRENT INDEX AND DISABLE/HIDE BUTTONES
                        Button(action: {
                            if self.currentPageIndex > 0 {
                                self.currentPageIndex -= 1
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(disableBackward ? .gray : .blue).opacity(disableBackward ? 0.5 : 0.8)
                                .cornerRadius(30)
                        }
                        .padding()
                        .disabled(disableBackward)
                        
                        Button(action: {
                            // DISMISS GUIDE AND LOAD CAL
                            UserDefaults.standard.set(false, forKey: "isFirstTime")
                        }) {
                            Text("Got it!")
                                .frame(width: 60, height: 20)
                                .padding()
                                .foregroundColor(disableDone ? . clear : .white)
                                .background(disableDone ? .clear : .orange).opacity(0.8)
                                .cornerRadius(20)
                        }
                        .padding()
                        .disabled(disableDone)

                        
                        Button(action: {
                            if self.currentPageIndex + 1 < self.subviews.count {
                                self.currentPageIndex += 1
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(disableForward ? .gray : .blue).opacity(disableForward ? 0.5 : 0.8)
                                .cornerRadius(30)
                        }
                        .padding()
                        .disabled(disableForward)
                    }   
                }
            }
        }
    }
    
    var disableForward: Bool {
        self.currentPageIndex + 1 == self.subviews.count
    }
    
    var disableBackward: Bool {
        self.currentPageIndex == 0
    }
    
    var disableDone: Bool {
        self.currentPageIndex + 1 != self.subviews.count
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}

