import SwiftUI
import SpriteKit

extension Notification.Name {
    static let allObjectsFound = Notification.Name("allObjectsFound")
    static let notFoundAll = Notification.Name("notFoundAll")
    static let homeAction = Notification.Name("homeAction")
    static let detailsObjects = Notification.Name("detailsObjects")
}

class MainGameScene: SKScene {
    
    var gameData: (String, [String])
    
    private var scrollableBack: SKSpriteNode!
    
    private var scrollableBackPosition: CGPoint! {
        didSet {
            scrollableBack.run(SKAction.move(to: scrollableBackPosition, duration: 0.5))
        }
    }
    
    private var scrollBackLeft: SKSpriteNode!
    private var scrollBackRight: SKSpriteNode!
    private var subjectsBack: SKSpriteNode!
    private var attemptsBack: SKSpriteNode!
    private var homeBtn: SKSpriteNode!
    
    private var elements: [Element] = []
    private var foundItems: [Element] = []
    private var subjects: Int = 0 {
        didSet {
            subjectsLabel.text = "\(subjects)/\(elements.count)"
        }
    }
    private var attempts: Int = 0 {
        didSet {
            attemptsaLabel.text = "\(attempts)/3"
            if attempts == 3 {
                gameOver()
            }
        }
    }
    private var attemptsaLabel: SKLabelNode!
    private var subjectsLabel: SKLabelNode!
    
    let spawnZoneWidth: CGFloat = 1500
    
    init(gameData: (String, [String])) {
        self.gameData = gameData
        super.init(size: CGSize(width: 750, height: 1335))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restartScene() -> MainGameScene {
        let mainGameScene = MainGameScene(gameData: gameData)
        view?.presentScene(mainGameScene)
        return mainGameScene
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 900, height: 1335)
        createScrollableBackground()
        spawnElements()
        createGameUIElements()
    }
    
    private func createGameUIElements() {
        homeBtn = SKSpriteNode(imageNamed: "home_button")
        homeBtn.position = CGPoint(x: size.width / 2 - 280, y: size.height - 200)
        homeBtn.size = CGSize(width: 250, height: 80)
        addChild(homeBtn)
        
        subjectsBack = SKSpriteNode(imageNamed: "subjects")
        subjectsBack.position = CGPoint(x: size.width / 2, y: size.height - 200)
        subjectsBack.size = CGSize(width: 250, height: 80)
        addChild(subjectsBack)
        
        subjectsLabel = SKLabelNode(text: "0/\(elements.count)")
        subjectsLabel.fontName = "RammettoOne-Regular"
        subjectsLabel.fontSize = 24
        subjectsLabel.fontColor = UIColor.init(red: 111/255, green: 46/255, blue: 7/255, alpha: 1)
        subjectsLabel.position = CGPoint(x: size.width / 2, y: size.height - 220)
        addChild(subjectsLabel)
        
        attemptsBack = SKSpriteNode(imageNamed: "attempts_title")
        attemptsBack.position = CGPoint(x: size.width / 2 + 280, y: size.height - 200)
        attemptsBack.size = CGSize(width: 250, height: 80)
        addChild(attemptsBack)
        
        attemptsaLabel = SKLabelNode(text: "0/3")
        attemptsaLabel.fontName = "RammettoOne-Regular"
        attemptsaLabel.fontSize = 24
        attemptsaLabel.fontColor = UIColor.init(red: 111/255, green: 46/255, blue: 7/255, alpha: 1)
        attemptsaLabel.position = CGPoint(x: size.width / 2 + 280, y: size.height - 220)
        addChild(attemptsaLabel)
    }
    
    private func createScrollableBackground() {
        scrollableBack = SKSpriteNode(imageNamed: gameData.0)
        scrollableBack.size = CGSize(width: 3400, height: size.height)
        scrollableBack.blendMode = .replace
        scrollableBackPosition = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(scrollableBack)
        createScrollButtons()
    }
    
    private func createScrollButtons() {
        scrollBackLeft = SKSpriteNode(imageNamed: "scroll_fon_back")
        scrollBackLeft.position = CGPoint(x: size.width / 2 - 100, y: 100)
        scrollBackLeft.size = CGSize(width: 150, height: 130)
        scrollBackLeft.zPosition = 10
        addChild(scrollBackLeft)
        
        scrollBackRight = SKSpriteNode(imageNamed: "scroll_fon_forward")
        scrollBackRight.position = CGPoint(x: size.width / 2 + 100, y: 100)
        scrollBackRight.size = CGSize(width: 150, height: 130)
        scrollBackRight.zPosition = 10
        addChild(scrollBackRight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchDetected = touches.first
        if touchDetected == nil {
            return
        }
        let nodesP = nodes(at: touchDetected!.location(in: self))
        for node in nodesP {
            if node.name?.contains("object") == true {
                objectFound(object: node)
                return
            }
        }
        
        if nodesP.contains(homeBtn) {
            NotificationCenter.default.post(name: .homeAction, object: nil, userInfo: nil)
            return
        }
        
        if nodesP.contains(subjectsBack) {
            NotificationCenter.default.post(name: .detailsObjects, object: nil, userInfo: [
                "found": foundItems.map { $0.id }
            ])
            return
        }
        
        if nodesP.contains(scrollBackLeft) {
            if scrollableBackPosition.x + 100 < 1700 {
                scrollableBackPosition = CGPoint(x: scrollableBackPosition.x + 100, y: scrollableBackPosition.y)
            }
            return
        }
        
        if nodesP.contains(scrollBackRight) {
            if scrollableBackPosition.x - 100 > -800 {
                scrollableBackPosition = CGPoint(x: scrollableBackPosition.x - 100, y: scrollableBackPosition.y)
            }
            return
        }
        
        attempts += 1
    }
    
    private func objectFound(object: SKNode) {
        let element = elements.filter { $0.id == object.name }[0]
        foundItems.append(element)
        if foundItems.count == elements.count {
            allObjectsFound()
        }
        object.removeFromParent()
        subjects += 1
    }
    
    private func allObjectsFound() {
        NotificationCenter.default.post(name: .allObjectsFound, object: nil, userInfo: nil)
    }
    
    private func gameOver() {
        NotificationCenter.default.post(name: .notFoundAll, object: nil, userInfo: [
            "foundObjects": foundItems.map { $0.id }
        ])
    }
    
    func spawnElements() {
        for object in gameData.1 {
            let objectPoint = generatePointForObject()
            elements.append(Element(id: object, pos: objectPoint))
            let objectNode = SKSpriteNode(imageNamed: object)
            let originalWidth = objectNode.size.width
            let originalHeight = objectNode.size.height
            objectNode.size = CGSize(width: originalWidth / 2, height: originalHeight / 2)
            objectNode.position = objectPoint
            objectNode.name = object
            objectNode.zPosition = 8
            scrollableBack.addChild(objectNode)
        }
    }
    
    private func generatePointForObject() -> CGPoint {
        let x: CGFloat = CGFloat.random(in: 0..<2000)
        let y: CGFloat = CGFloat.random(in: 0..<450)
        return CGPoint(x: x, y: y)
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: MainGameScene(gameData: ("bg_game_1", ["object_1", "object_2", "object_3", "object_4"])))
            .ignoresSafeArea()
    }
}
