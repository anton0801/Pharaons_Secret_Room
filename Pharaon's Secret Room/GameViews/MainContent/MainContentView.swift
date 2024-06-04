import SwiftUI

struct MainContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: LevelsGameViews()
                        .navigationBarBackButtonHidden(true)) {
                        Image("levels_btn")
                            .resizable()
                            .frame(width: 150, height: 60)
                    }
                    NavigationLink(destination: SettingsGameView()
                        .navigationBarBackButtonHidden(true)) {
                        Image("settings_btn")
                            .resizable()
                            .frame(width: 150, height: 60)
                    }
                }
                Spacer().frame(height: 12)
                HStack {
                    NavigationLink(destination: InfoRulesGameView()
                        .navigationBarBackButtonHidden(true)) {
                        Image("info_btn")
                            .resizable()
                            .frame(width: 150, height: 60)
                    }
                    NavigationLink(destination: RecordsOfGamesView()
                        .navigationBarBackButtonHidden(true)) {
                        Image("records_btn")
                            .resizable()
                            .frame(width: 150, height: 60)
                    }
                }
                
                Spacer()
                
                let lastLevelGame = UserDefaults.standard.string(forKey: "last_level_passed") ?? "level_1"
                let lastGameData = levelMaps[lastLevelGame]!
                NavigationLink(destination: MainGameView(gameData: lastGameData, level: lastLevelGame)
                                   .navigationBarBackButtonHidden(true)) {
                    Image("last_level_play_btn")
                        .resizable()
                        .frame(width: 250, height: 100)
                }
                
                Spacer().frame(height: 24)
            }
            .background(
                Image("main_content_bg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30)
            )
        }
    }
}

#Preview {
    MainContentView()
}
