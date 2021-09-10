import SwiftUI

var c  =  Color.init(red: 0.134, green: 0.17, blue: 0.3)
var c2  =  Color.init(red: 0.85, green: 0.928, blue: 1)

struct ContentView: View {
    var arr = ["١","٢","٣","٤","٥","٦","٧","٨","٩","٠"]
    
    @State var totalAmount = 0
    @State var principalAmout = ""
    @State var yearlyCont = ""
    @State var rate = 0.05
    @State var years = ""
    @State var langE: Bool = true
    @AppStorage("key0")  var shouldshowonb = true
    var a  : Bool {
        
        for i in arr {
            if principalAmout.contains(i) || yearlyCont.contains(i) || years.contains(i)  {
                return true
            }
        }
        return false
    }
    @State var alert = false
    var l :Bool {
        if Locale.preferredLanguages.first! == "ar-SA" {
            return false
        }
        return true
    }
    
    //var preferredLanguage: String = Locale.preferredLanguages.first!
    
    var body: some View {
        
      NavigationView{
        
           
            ZStack {
                
                Color(hex: "206A5D").ignoresSafeArea(.all)   .onTapGesture {
                    hideKeyboard()
                }
//
//                LinearGradient(gradient: Gradient(colors: [ Color(hex: "206A5D"), Color.white]), startPoint: .top, endPoint: .bottom)
//                    .ignoresSafeArea(.all)
//
//

                ScrollView {
                   
                    
                    Text(langE ? "Compound Interest" : "العائد المركب").bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            hideKeyboard()
                        }
                    ZStack{
                        GeometryReader { proxy in
                            ZStack{
//                                Rectangle().opacity(0.2).cornerRadius(65.0).frame(width: proxy.size.width , height: proxy.size.height + 20, alignment: .center)
//
                                BlurView(style: .dark).frame(width: proxy.size.width , height: proxy.size.height + 20, alignment: .top).clipShape(RoundedRectangle(cornerRadius: 25))
                                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 1.4).foregroundColor(.gray))
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 0.0 )
                                



                            }
                        }.padding(30)
                        
                        
                VStack{
                    
                    Group{
                        
                        VStack{
                            if langE {
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                            HStack { Text("   Initial deposit :")
                                TextField(" Amount", text: $principalAmout  ).keyboardType(.asciiCapableNumberPad)
                            }
                        }.padding(.vertical)
                        .onTapGesture {
                            hideKeyboard()
                        }
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                                    HStack {
                                        Spacer()
                                        TextField("المبلغ                                  `", text: $principalAmout  ).keyboardType(.asciiCapableNumberPad)
                                        Text("  الوديعة الأولية :")
                                        
                                    }
                                }.padding(.vertical)
                                .onTapGesture {
                                    hideKeyboard()
                                }
                            }
                            
                            //
                            if langE{
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: .leading).shadow(radius: 100)
                            HStack{ Text("  yearly contribution :")
                                TextField("Amount", text: $yearlyCont ).keyboardType(.asciiCapableNumberPad)
                            }
                        }.padding(.vertical)
                        .onTapGesture {
                            hideKeyboard()
                        }
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: .leading).shadow(radius: 100)
                                    HStack{
                                        Spacer()
                                        TextField("المبلغ                              `", text: $yearlyCont ).keyboardType(.asciiCapableNumberPad)
                                        Text("  الإضافات السنوية :")
                                    }
                                }.padding(.vertical)
                                .onTapGesture {
                                    hideKeyboard()
                                }
                            }
                            if langE{
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                            HStack{  Stepper(value: $rate , step : 0.01 ){
                                Text("rate \( 100 * rate , specifier: "%g")%" )
                                    .padding(.horizontal)
                                    
                            }
                            Spacer()
                           
                            }
                            
                        }.padding(.vertical)
                       Spacer(minLength: 25)
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                                    HStack{
                                       
                                        Stepper(value: $rate , step : 0.01 ){
                                       
                                         
                                    }
                                        
                                        Text("النسبة :   %\( 100 * rate , specifier: "%g") ")
                                    Spacer()
                                        
                                    }
                                    
                                }.padding(.vertical)
                               Spacer(minLength: 25)
                                  
                            }
                            if langE {
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                            HStack{ Text("    years :")
                                TextField("Amount " , text: $years).keyboardType(.asciiCapableNumberPad)
                                }
                            }  .onTapGesture {
                                hideKeyboard()
                            }
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                                    HStack{
                                        Spacer()
                                        TextField("المدة                                           ' " , text: $years).keyboardType(.asciiCapableNumberPad)
                                        Text("   السنوات :")
                                        }
                                    
                                    }  .onTapGesture {
                                        hideKeyboard()
                                    }

                            }
                        
                        }
                    }.padding(45).padding(.vertical)
                    
                   
                    ZStack{
                        Rectangle().frame(width: 130, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(hex: "206A5D"))
                            .opacity(0.4).shadow(radius: 10).cornerRadius(30)
                        if principalAmout.isEmpty || yearlyCont.isEmpty || years.isEmpty || a{
                            Text((langE ? "calculate" : "احسب")).onTapGesture {
                                alert.toggle()
                            }
                        } else  {
                        
                            
                            NavigationLink((langE ? "calculate" : "احسب"), destination: lo(totalAmountnew: 0, principalAmoutnew: principalAmout, yearlyContnew: yearlyCont, ratenew: rate,  yearsnew: years , lang: langE)
                                    
                        )

                        }
                    }.padding(.vertical)

                    Spacer()
                }
                
                    }
                }
            
            }
//            .onTapGesture {
//                hideKeyboard()
//            }

            .navigationBarItems(leading: Button(action: {shouldshowonb.toggle()}, label: {
                Image(systemName: "questionmark.circle").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            })
                                
                                
                                , trailing: Button( langE ? "عربي" : "Eng") {
                                withAnimation(.easeOut(duration: 0.2)){
                                    langE.toggle()
                                }
                            })
           

            .alert(isPresented: $alert, content: {
                Alert(title: Text((langE ? "problem!" : "حدث خطأ!")), message: Text((langE ?  "Please fill in all the fields" : " تأكد من الفراغات ")), dismissButton: .default(Text((langE ? "ok" : "حسناً"))))
            })
      }.foregroundColor(.white)

      
      .onAppear{
        if l == false {
            langE.toggle()
        }
      }
      .fullScreenCover(isPresented: $shouldshowonb ){
        tab(langE: $langE, shouldshowonb: $shouldshowonb)
      }.ignoresSafeArea(.all)
    }
    

}
struct tab : View{
  @Binding  var langE : Bool
    @Binding var shouldshowonb :Bool
    var body: some View {
        
        ZStack{
            Color(hex: "206A5D").ignoresSafeArea(.all)
        TabView{
           
            onBoardingView(langE: langE , shouldshowonb: $shouldshowonb)
            steps(langE: $langE, imageName: "1.circle" , str: langE ? "Add your inital deposit : \nAmount of money that you have available to invest initially." : "أضف الوديعة الأولية ، وهي رأس المال الذي سوف تبدأ فيه.", shouldshowonb: $shouldshowonb )
            
            steps(langE: $langE, imageName: "2.circle" ,str: langE ? "Add the amount that you plan to add to the principal every year." :"حدد المبلغ الذي تريد إضافته لرأس المال سنويا.", shouldshowonb: $shouldshowonb)
            steps(langE: $langE, imageName: "3.circle" , str: langE ? "Add your estimated annual interest rate." : "أضف نسبة العائد السنوي المتوقع .", shouldshowonb: $shouldshowonb)
            steps(langE: $langE, imageName: "4.circle",str: langE ?"Add the length of time, in years, that you plan to save.":"حدد مدة الخطة الإستثمارية الخاصة بك بالسنوات. ", shouldshowonb: $shouldshowonb)
                        
        }.tabViewStyle(PageTabViewStyle())
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
   
            
        }
    }
}


struct lo : View{
    var totalAmountnew :Int
    var principalAmoutnew :String?
    var yearlyContnew  : String?
    var ratenew :Double
    var yearsnew :String
    static  var  PreviousAmount = 0.0
    var lang : Bool
    var body :some View {
      
        ZStack{
            
            Color(hex: "206A5D").ignoresSafeArea(.all)
            ScrollView{
            VStack{
                if lang{
            HStack{
                
                Text("  year  ")
                Spacer()
                Text("compounded   ")
                Spacer()

            }
                } else {
                    HStack {
                        Spacer()
                    Text("العائد     ")
                    Spacer()
                      Text("السنه")
                    Spacer()
                    }
                }
                Text(" ")
                
                ForEach(1..<Int(yearsnew)!  + 1){i in
                
                
                let f: Double = calc(principalAmout: principalAmoutnew ?? "0", yearlyCont: yearlyContnew ?? "0", rate: ratenew , year: "\(i)")
                let str = String(format: "%.1f", f)
                
                    if lang {
                HStack{
                    
                    Text("   \(i)")
                    Spacer()
                    Text(lang ?"\(str) $" : "           \(str)   " )
                    Spacer()
                
                }
                    } else{
                        Spacer()
                        HStack{
                            Text(lang ?"\(str) $" : "                   \(str) " )
                            Spacer()
                            Text("   \(i)")
                            Spacer()
                        
                        }
                    }
                Text(" ")
               
                
            }}}
        }.onDisappear(perform: onDisappear)
    }
    

    func onDisappear()  {
        lo.PreviousAmount = 0
    }
    
    func calc( principalAmout : String , yearlyCont : String , rate : Double  ,year : String ) -> Double {
        if lo.PreviousAmount.self == 0.0 {
            let  totalAmountnew = ( Double(principalAmout)! * pow((1.0 + Double(rate)), Double(year)!) ) +  Double(yearlyCont)!
            
            lo.PreviousAmount.self = totalAmountnew
        return totalAmountnew
        }
        let  totalAmountnew = ( (lo.PreviousAmount.self ) * pow((1.0 + Double(rate)), Double(year)! - (Double(year)! - 1.0) ) )  + Double(yearlyCont)!
           
        
        lo.PreviousAmount.self = totalAmountnew
        return totalAmountnew
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
