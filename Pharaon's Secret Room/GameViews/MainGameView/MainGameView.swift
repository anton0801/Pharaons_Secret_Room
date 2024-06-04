import SwiftUI
import SpriteKit
import Combine

struct MainGameView: View {
    
    @Environment(\.presentationMode) var preMode
    
    var gameData: [String: [String]]
    var level: String
    
    @State private var offset: CGFloat = 0
    let imageWidth: CGFloat = 3500
    let spawnZoneWidth: CGFloat = 3350
    let spawnZoneHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    @State private var elements: [Element] = []
    
    @State private var mainGameScene: MainGameScene?
    
    @State var foundItems: [String] = []
    
    @State var detailsObjectsShow = false
    @State var allFoundVisible = false
    @State var notFoundAllVisible = false

    @State var timePasssed = 0
    @State private var timerSubscription: Cancellable? = nil
    
    func startTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                timePasssed += 1
            }
    }
    
    func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
    
    func secsToMS(s seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    var body: some View {
        ZStack {
            if mainGameScene != nil {
                SpriteView(scene: mainGameScene!)
                    .ignoresSafeArea()
            }
            if detailsObjectsShow {
                detailsObjectShow
            }
            if allFoundVisible {
                allFoundView
            }
            if notFoundAllVisible {
                notFoundAllView
            }
        }
        .frame(width: screenWidth, height: screenHeight)
        .onAppear {
            let data: (String, [String]) = (gameData.first!.key, gameData.first!.value)
            mainGameScene = MainGameScene(gameData: data)
            spawnElements()
            startTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .detailsObjects)) { notification in
            guard let info = notification.userInfo, let found = info["found"] as? [String] else { return }
            foundItems = found
            withAnimation {
                detailsObjectsShow = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .homeAction)) { _ in
            preMode.wrappedValue.dismiss()
            UserDefaults.standard.set(level, forKey: "last_level_passed")
        }
        .onReceive(NotificationCenter.default.publisher(for: .notFoundAll)) { _ in
            stopTimer()
            UserDefaults.standard.set(level, forKey: "last_level_passed")
            withAnimation {
                 notFoundAllVisible = true
             }
        }
        .onReceive(NotificationCenter.default.publisher(for: .allObjectsFound)) { _ in
            stopTimer()
            let prevRecord = UserDefaults.standard.integer(forKey: "\(level)_record")
            if timePasssed < prevRecord || prevRecord == 0 {
                UserDefaults.standard.set(timePasssed, forKey: "\(level)_record")
            }
            UserDefaults.standard.set(level, forKey: "last_level_passed")
            withAnimation {
                allFoundVisible = true
            }
        }
    }
    
    func spawnElements() {
        if let (key, value) = gameData.first {
            let data: (String, [String]) = (key, value)
            for object in data.1 {
                elements.append(Element(id: object, pos: generatePointForObject()))
            }
        }
    }
    
    private func generatePointForObject() -> CGPoint {
        let x: CGFloat = CGFloat.random(in: 200..<spawnZoneWidth)
        let y: CGFloat = CGFloat.random(in: 50..<spawnZoneHeight)
        return CGPoint(x: x, y: y)
    }
    
    private var detailsObjectShow: some View {
        VStack {
            Spacer()
            
            Text("SUBJECTS")
                .font(.custom("RammettoOne-Regular", size: 42))
                .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
            
            ForEach(gameData.first!.value, id: \.self) { item in
                HStack {
                    Image(item)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer().frame(width: 32)
                    if foundItems.contains(item) {
                        Text("Found")
                            .font(.custom("RammettoOne-Regular", size: 24))
                            .foregroundColor(Color.init(red: 111/255, green: 46/255, blue: 7/255))
                            .shadow(color: Color.init(red: 245/255, green: 203/255, blue: 82/255), radius: 2)
                    } else {
                        Text("Not found")
                            .font(.custom("RammettoOne-Regular", size: 24))
                            .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                            .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
                    }
                }
            }
            
            Spacer()
            Button {
                withAnimation {
                    self.detailsObjectsShow = false
                }
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
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var allFoundView: some View {
        VStack {
            VStack {
                Image("win_title")
                    .resizable()
                    .frame(width: 200, height: 60)
                
                Text("time - \(secsToMS(s:timePasssed))")
                     .font(.custom("RammettoOne-Regular", size: 24))
                     .foregroundColor(Color.init(red: 111/255, green: 46/255, blue: 7/255))
                
                HStack {
                    Button {
                        mainGameScene = mainGameScene?.restartScene()
                        withAnimation {
                            allFoundVisible = false
                        }
                    } label: {
                        Image("restart")
                            .resizable()
                            .frame(width: 120, height: 50)
                    }
                    Button {
                        preMode.wrappedValue.dismiss()
                    } label: {
                        Image("home")
                            .resizable()
                            .frame(width: 120, height: 50)
                    }
                }
            }
            .background(
                Image("game_result_bg")
                    .resizable()
                    .frame(width: 300, height: 350)
            )
        }
        .background(
            Image("main_content_bg_2")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
    private var notFoundAllView: some View {
        VStack {
            VStack {
                Text("GAME OVER")
                          .font(.custom("RammettoOne-Regular", size: 34))
                          .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                          .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
                
                Spacer().frame(height: 42)
                
                Text("We're done\ntrying")
                    .multilineTextAlignment(.center)
                     .font(.custom("RammettoOne-Regular", size: 24))
                     .foregroundColor(Color.init(red: 111/255, green: 46/255, blue: 7/255))
                
                Spacer().frame(height: 62)
                
                HStack {
                    Button {
                        mainGameScene = mainGameScene?.restartScene()
                        withAnimation {
                            notFoundAllVisible = false
                        }
                    } label: {
                        Image("restart")
                            .resizable()
                            .frame(width: 120, height: 50)
                    }
                    Button {
                        preMode.wrappedValue.dismiss()
                    } label: {
                        Image("home")
                            .resizable()
                            .frame(width: 120, height: 50)
                    }
                }
            }
            .background(
                Image("game_result_bg")
                    .resizable()
                    .frame(width: 300, height: 350)
            )
        }
        .background(
            Image("main_content_bg_2")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
}

struct Element: Identifiable {
    let id: String
    let pos: CGPoint
}

#Preview {
    MainGameView(gameData: levelMaps["level_1"]!, level: "level_1")
}
