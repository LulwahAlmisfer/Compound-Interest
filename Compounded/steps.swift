import SwiftUI

struct steps: View {
    var imageName :String
    var str : String
    @Binding var shouldshowonb : Bool
    
    var body: some View {
        
        ZStack {
        
            Color("main").ignoresSafeArea(.all)
            if imageName != "4.circle" {
            VStack{
                HStack{
                    Spacer()
                ZStack {
                    Circle().frame(width: 90, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                        .opacity(0.4)
                    
                    Text( "skip" ).foregroundColor(.white).onTapGesture {
                        shouldshowonb.toggle()
                    }
                }
                }
                Spacer()
            }
            .padding(.top , 10)
            }
            
            VStack(alignment : .leading, spacing:10) {
                
         
                HStack( spacing: 15) {
                    Text("Step").foregroundColor(.white).font(Font.system(size: 80))
                    Image(systemName: imageName).resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.yellow) }
              
   
   
               
                Text(LocalizedStringKey(str)).foregroundColor(.white).font(Font.system(size: 30))
             
         
            }  .padding(.leading ,7)
            
            if imageName == "4.circle" {
                VStack{
                    Spacer()
                ZStack {
                    Rectangle().frame(width: 130, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                        .opacity(0.4).shadow(radius: 10).cornerRadius(30)
                    
                    Text("START!").foregroundColor(.white).onTapGesture {
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
        steps(imageName: "4.circle",str: "Add the length of time, in years, that you .", shouldshowonb: .constant(true))
    }
}
