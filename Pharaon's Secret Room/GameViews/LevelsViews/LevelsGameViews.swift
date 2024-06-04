import SwiftUI

struct LevelsGameViews: View {
    
    @Environment(\.presentationMode) var preMo
    
    @State private var availableLevels: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("LEVELS")
                   .font(.custom("RammettoOne-Regular", size: 42))
                   .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                   .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
                Spacer().frame(height: 12)
                
                LazyVGrid(columns: [
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80))
                ]) {
                    ForEach(levels, id: \.self) { level in
                        if availableLevels.contains(level) {
                            let gameData = levelMaps[level]!
                            NavigationLink(destination: MainGameView(gameData: gameData, level: level)
                                .navigationBarBackButtonHidden(true)) {
                                ZStack {
                                    Image("lvl_bg")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                    let levelNum = level.components(separatedBy: "_")[1]
                                    Text("\(levelNum)")
                                        .font(.custom("RammettoOne-Regular", size: 24))
                                        .foregroundColor(Color.init(red: 111/255, green: 46/255, blue: 7/255))
                                }
                                .padding()
                            }
                        } else {
                            Image("lock")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .padding(4)
                        }
                    }
                }
                
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
            .onAppear {
                setUpAvailableLevels()
            }
            .background(
                Image("main_content_bg_2")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func setUpAvailableLevels() {
        for level in levels {
            if UserDefaults.standard.bool(forKey: "\(level)_available_level") {
                availableLevels.append(level)
            }
        }
        if availableLevels.isEmpty {
            UserDefaults.standard.set(true, forKey: "level_1_available_level")
            availableLevels.append("level_1_available_level")
        }
    }
    
}

#Preview {
    LevelsGameViews()
}
