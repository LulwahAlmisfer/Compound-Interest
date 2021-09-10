//
//  onBoardingView.swift
//  Compounded
//
//  Created by Lulu Khalid on 01/09/2021.
//

import SwiftUI

struct onBoardingView: View {
    var langE :Bool
    @Binding var shouldshowonb : Bool
    
    var body: some View {
        
        
        ZStack{
            Color(hex: "206A5D").ignoresSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
                ZStack {
                    Circle().frame(width: 90, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                        .opacity(0.4).shadow(radius: 10).cornerRadius(30)
                    
                    Text(langE ? "skip" : "تخطي").onTapGesture {
                        shouldshowonb.toggle()
                    }
                }
                }
                Spacer()
            }
            .padding(.top , 10)
            VStack(alignment: .leading){
                HStack{
                    if langE {
                        Text("What is compound interest ?").foregroundColor(.white).font(.title).padding(.leading , 10)
                      //   Text("\(Locale.preferredLanguages.first!)")
                    } else {
                        Text("ماهو العائد المركب؟").frame(width: 350, height: 40, alignment: .trailing).foregroundColor(.white).font(.title).padding(.trailing , 10)
                    }
                }
                if langE {
                    Text("It is the interest on a loan or deposit calculated based on both the initial principal and the accumulated interest from previous periods. \n \nbasically when you earn interest on both the money you've saved and the interest you earn.").foregroundColor(.white).padding().font(.body)
                } else {
                    Text("الفكرة من العائد المركب هو انك تحقق ربح اضافي عن طريق استثمار ارباحك السابقة بالاضافة الى ربحك من استثمار رأس المال .").frame(width: 350, height: 120, alignment: .trailing).foregroundColor(.white).padding().font(.body)
                    Text(" ببساطة انك تقوم بأعادة استثمار ارباحك حتى تحقق عوائد عليها ايضا و تكرر ذلك كل سنة حتى تتراكم الارباح.").frame(width: 350, height: 80, alignment: .trailing).foregroundColor(.white).padding().font(.body)
                    
                    
                }
                LottieView(filename: "8943-money-greenbg")
            }.frame( height: 550, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
        
    }
}

struct onBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingView(langE: true,shouldshowonb: .constant(true))
    }
}
