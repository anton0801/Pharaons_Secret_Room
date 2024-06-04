import SwiftUI

struct InfoRulesGameView: View {
    
    @Environment(\.presentationMode) var preMo
    
    var body: some View {
        VStack {
            Spacer()
            Text("INFO")
                .font(.custom("RammettoOne-Regular", size: 42))
                .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
            
            Spacer().frame(height: 12)
            
            Text("Find all the items, be careful not to click into the void!")
                .font(.custom("RammettoOne-Regular", size: 32))
                .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
                .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                preMo.wrappedValue.dismiss()
            } label: {
                Image("back_btn")
                    .resizable()
                    .frame(width: 200, height: 70)
            }
            Spacer().frame(height: 24)
        }
        .background(
            Image("main_content_bg_2")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30)
        )
    }
}

#Preview {
    InfoRulesGameView()
}
