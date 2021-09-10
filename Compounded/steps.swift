//
//  steps.swift
//  Compounded
//
//  Created by Lulu Khalid on 03/09/2021.
//

import SwiftUI

struct steps: View {
 @Binding  var langE :Bool
    var imageName :String
    var str : String
    @Binding var shouldshowonb : Bool
    
    var body: some View {
        
        ZStack {
        
            Color(hex: "206A5D").ignoresSafeArea(.all)
            if imageName != "4.circle" {
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
            }
            VStack(alignment : .leading, spacing:10) {
                
                if langE {
                HStack( spacing: 15) {
                    Text("Step ").foregroundColor(.white).font(Font.system(size: 80))
                    Image(systemName: imageName).resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.yellow) }
                .padding(.leading , 10)
                } else {
                    HStack( spacing: 15) {
                       
                        Image(systemName: imageName).resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.yellow)
                        Text("الخطوة ").foregroundColor(.white).font(Font.system(size: 80))
                    }
                    .padding(.leading , 10)
                }
                
            
                if langE {
                Text(str).foregroundColor(.white).font(Font.system(size: 30)).padding(.leading , 10)
                } else {
                    Text(str).foregroundColor(.white).font(Font.system(size: 29)).padding(.trailing , 10).frame(width: 340, height: 200, alignment: .trailing)
                }
         
            }
            if imageName == "4.circle" {
                VStack{
                    Spacer()
                ZStack {
                    Rectangle().frame(width: 130, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                        .opacity(0.4).shadow(radius: 10).cornerRadius(30)
                    
                    Text(langE ? "START!" : "إبدأ!").onTapGesture {
                        shouldshowonb.toggle()
                    }
                }
                }.padding(.bottom , 150)
            }
        }
        
    }
}

struct steps_Previews: PreviewProvider {
    static var previews: some View {
        steps(langE: .constant(true), imageName: "3.circle",str: "Add the length of time, in years, that you plan to save.", shouldshowonb: .constant(true))
    }
}
