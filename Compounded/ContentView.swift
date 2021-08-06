
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
    @State var langE = true
    var a  : Bool {
        
        for i in arr {
            if principalAmout.contains(i) || yearlyCont.contains(i) || years.contains(i)  {
                return true
            }
        }
        return false
    }
    @State var alert = false
    
    var body: some View {
        
      NavigationView{
           
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [c, c2]), startPoint: .top, endPoint: .bottomTrailing).ignoresSafeArea()
                ScrollView{
                    ZStack{
                        GeometryReader { proxy in
                            ZStack{
                                Rectangle().opacity(0.2).cornerRadius(65.0).frame(width: proxy.size.width , height: proxy.size.height + 20, alignment: .center)
                                
                            }
                        }.padding(30)
                VStack{
                    
                    Group{
                        
                        VStack{
                            if langE {
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                            HStack { Text("     Initail deposit :")
                                TextField(" Amount", text: $principalAmout  ).keyboardType(.numberPad)
                            }
                        }.padding(.vertical)
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                                    HStack {
                                        Spacer()
                                        TextField("الكمية                              `", text: $principalAmout  ).keyboardType(.numberPad)
                                        Text("   الوديعة الأولية :")
                                        
                                    }
                                }.padding(.vertical)
                            }
                            
                            //
                            if langE{
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: .leading).shadow(radius: 100)
                            HStack{ Text("  yearly contribution :")
                                TextField("Amount", text: $yearlyCont ).keyboardType(.numberPad)
                            }
                        }.padding(.vertical)
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: .leading).shadow(radius: 100)
                                    HStack{
                                        Spacer()
                                        TextField("الكمية                              `", text: $yearlyCont ).keyboardType(.numberPad)
                                        Text(" الإضافات السنوية :")
                                    }
                                }.padding(.vertical)
                            }
                            if langE{
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                            HStack{  Stepper(value: $rate , step : 0.01 ){
                                Text("  rate \( 100*rate , specifier: "%g")%" )
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
                                        
                                        Text(" النسبة :   %\( 100*rate , specifier: "%g") ")
                                    Spacer()
                                        
                                    }
                                    
                                }.padding(.vertical)
                               Spacer(minLength: 25)
                                  
                            }
                            if langE {
                        ZStack{
                            Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                            HStack{ Text("       years :")
                                TextField("Amount " , text: $years).keyboardType(.numberPad)
                                }
                            }
                            } else {
                                ZStack{
                                    Rectangle().opacity(0.3).cornerRadius(30.0).frame(width: 330, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).shadow(radius: 100)
                                    HStack{
                                        Spacer()
                                        TextField("الكمية                                             ' " , text: $years).keyboardType(.numberPad)
                                        Text("   السنين :")
                                        }
                                    
                                    }

                            }
                        
                        }
                    }.padding(45).padding(.vertical)
                    
                   
                    ZStack{
                        Rectangle().frame(width: 130, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).opacity(0.4).shadow(radius: 10).cornerRadius(30)
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
            .navigationBarItems(trailing: Button( langE ? "عربي" : "Eng") {
                langE.toggle()
            })
            .navigationTitle((langE ? "Compounded" : "العائد المركب"))
            .alert(isPresented: $alert, content: {
                Alert(title: Text((langE ? "problem!" : "حدث خطأ!")), message: Text((langE ?  "make sure to fill all the fields" : " تأكد من الفراغات واستخدام هذة الأرقام 123456789")), dismissButton: .default(Text((langE ? "ok" : "حسناً"))))
            })
      }.foregroundColor(.white)
        
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
            
            LinearGradient(gradient: Gradient(colors: [c, c2]), startPoint: .top, endPoint: .bottomTrailing).ignoresSafeArea()
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
                    HStack{
                        Spacer()
                    Text("العائد          ")
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
                    Text(lang ?"\(str) $" : "\(str) " )
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

