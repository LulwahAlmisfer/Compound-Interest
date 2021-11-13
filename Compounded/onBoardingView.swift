//
//  onBoardingView.swift
//  Compounded
//
//  Created by Lulu Khalid on 01/09/2021.
//

import SwiftUI

struct onBoardingView: View {

    @Binding var shouldshowonb : Bool
    
    var body: some View {
        
        
        ZStack{
            Color("main").ignoresSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
                ZStack {
                    Circle().frame(width: 90, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                        .opacity(0.4)
                    
                    Text("skip").foregroundColor(.white).onTapGesture {
                        shouldshowonb.toggle()
                    }
                }
                }
                Spacer()
            }
            .padding(.top , 10)
            VStack(alignment: .leading){
         
                        Text("What is compound interest ?").foregroundColor(.white).font(.title).padding()
                
                
                    Text("Definition").foregroundColor(.white).padding().font(.body)
              
                LottieView(filename: "8943-money-greenbg")
            }.frame( height: 550, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
        
    }
}

struct onBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingView(shouldshowonb: .constant(true))
    }
}
