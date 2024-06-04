import SwiftUI

struct SettingsGameView: View {
    
    @Environment(\.presentationMode) var preMo
    
    @State private var soundSettings = UserDefaults.standard.bool(forKey: "sound_settings") {
        didSet {
            UserDefaults.standard.set(soundSettings, forKey: "sound_settings")
        }
    }
    @State private var musicSettings = UserDefaults.standard.bool(forKey: "musicSettings") {
        didSet {
            UserDefaults.standard.set(musicSettings, forKey: "musicSettings")
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("INFO")
                .font(.custom("RammettoOne-Regular", size: 42))
                .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
            Spacer()
            
            ZStack {
                Image("sound_settings")
                    .resizable()
                    .frame(width: 300, height: 90)
                HStack {
                    Spacer()
                    Toggle(isOn: $soundSettings, label: {
                        EmptyView()
                    })
                    Spacer().frame(width: 32)
                }
                .frame(width: 300)
            }
            
            ZStack {
                Image("music_settings")
                    .resizable()
                    .frame(width: 300, height: 90)
                HStack {
                    Spacer()
                    Toggle(isOn: $musicSettings, label: {
                        EmptyView()
                    })
                    Spacer().frame(width: 32)
                }
                .frame(width: 300)
            }
            
            Spacer()
            
            Button {
                 preMo.wrappedValue.dismiss()
             } label: {
                 Image("back_btn")
                     .resizable()
                     .frame(width: 200, height: 70)
             }
            
            Spacer().frame(height: 32)
        }
        .background(
            Image("main_content_bg_2")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30)
        )
    }
}

#Preview {
    SettingsGameView()
}
