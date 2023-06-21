//
//  GameScene.swift
//  TasteOfIndonesia
//
//  Created by Theresa Tiffany on 06/04/23.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene ,SKPhysicsContactDelegate{
    
    let scoreLabel = SKLabelNode(fontNamed: "Copperplate")
    
    var levelNumber = 0
    
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "Copperplate")
    
    let player = SKSpriteNode(imageNamed: "player")
    
    let tapToStartLabel = SKLabelNode(fontNamed: "Copperplate")
    
    enum gameState {
        case beforeGame // Game State before the game starts
        case duringGame // Game State during the game
        case afterGame // Game State after the game over
    }
    
    var currentGameState = gameState.beforeGame
           
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //artinya binary 1
        static let Sambal : UInt32 = 0b10 //2
        static let Soto : UInt32 = 0b100 //4
        static let Sate : UInt32 = 0b1000
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min:CGFloat, max:CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    func random1() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFF10)
    }
    func random1(min:CGFloat, max:CGFloat) -> CGFloat {
        return random1() * (max-min) + min
    }
    
    func random2() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFF0030)
    }
    func random2(min:CGFloat, max:CGFloat) -> CGFloat {
        return random2() * (max-min) + min
    }
    
    var gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/11.5
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode (imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(0.55)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height*0.02)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width/8, height: player.size.height/8))
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Soto
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Sambal
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Sate
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 80
        scoreLabel.fontColor = SKColor.black
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 80
        livesLabel.fontColor = SKColor.black
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.86, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.black
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
    }
    
    
    func startGame(){
        currentGameState = gameState.duringGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let movePlayerOntoScreenAction = SKAction.moveTo(y: self.size.height*0.07, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([movePlayerOntoScreenAction,startLevelAction])
        player.run(startGameSequence)
    }
    
    func loseALife() {
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0{
            runGameOver()
        }
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            startNewLevel()
        }
        
    }
    
    func runGameOver(){
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Soto") {
            soto, stop in
            soto.removeAllActions()}
        
        self.enumerateChildNodes(withName: "Sambal") {
            sambal, stop in
            sambal.removeAllActions()}
        
        self.enumerateChildNodes(withName: "Sate") {
            sate, stop in
            sate.removeAllActions()}
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Sambal{
            // If Player has eat the Sambal
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Soto{
            // If Player has eat the Soto
            
            addScore()
            
            if body2.node != nil {
                spawnSotoSplash(spawnPosition: body2.node!.position)
            }
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Sate{
            // If Player has eat the Cireng
            
            addScore()
            
            if body2.node != nil {
                spawnSateSplash(spawnPosition: body2.node!.position)
            }
            body2.node?.removeFromParent()
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 0.5, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    
    func spawnSotoSplash(spawnPosition: CGPoint){
        let sotoSplash = SKSpriteNode(imageNamed: "sotoSplash")
        sotoSplash.position = spawnPosition
        sotoSplash.zPosition = 3
        sotoSplash.setScale(0)
        self.addChild(sotoSplash)
        
        let scaleIn = SKAction.scale(to: 0.15, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        sotoSplash.run(explosionSequence)
    }
    
    func spawnSateSplash(spawnPosition: CGPoint){
        let sateSplash = SKSpriteNode(imageNamed: "sateSplash")
        sateSplash.position = spawnPosition
        sateSplash.zPosition = 3
        sateSplash.setScale(0)
        self.addChild(sateSplash)
        
        let scaleIn = SKAction.scale(to: 0.15, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        sateSplash.run(explosionSequence)
    }
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if (self.action(forKey: "spawningSoto") != nil) {
            self.removeAction(forKey: "spawningSoto")
        }
        
        if (self.action(forKey: "spawningSambal") != nil) {
            self.removeAction(forKey: "spawningSambal")
        }
        
        if (self.action(forKey: "spawningSate") != nil) {
            self.removeAction(forKey: "spawningSate")
        }
        
        var levelDuration = NSTimeIntervalSince1970
        
        switch levelNumber {
        case 1: levelDuration = 2.6
        case 2: levelDuration = 2.2
        case 3: levelDuration = 1.2
        case 4: levelDuration = 0.5
        default:
            print("Cannot find")
        }
        
        let spawn = SKAction.run(spawnSoto)
        let waitToSpawnSoto = SKAction.wait(forDuration: levelDuration)
        let spawnSotoSequence = SKAction.sequence([waitToSpawnSoto, spawn])
        let spawnSotoForever = SKAction.repeatForever(spawnSotoSequence)
        self.run(spawnSotoForever, withKey: "spawningSoto")
        
        let spawn2 = SKAction.run(spawnSambal)
        let waitToSpawnSambal = SKAction.wait(forDuration: levelDuration + 3.8)
        let spawnSambalSequence = SKAction.sequence([waitToSpawnSambal, spawn2])
        let spawnSambalForever = SKAction.repeatForever(spawnSambalSequence)
        self.run(spawnSambalForever, withKey: "spawningSambal")
        
        let spawn3 = SKAction.run(spawnSate)
        let waitToSpawnSate = SKAction.wait(forDuration: levelDuration + 0.5)
        let spawnSateSequence = SKAction.sequence([waitToSpawnSate, spawn3])
        let spawnSateForever = SKAction.repeatForever(spawnSateSequence)
        self.run(spawnSateForever, withKey: "spawningSate")
        
    }
    
    func spawnSoto(){
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let soto = SKSpriteNode(imageNamed: "sotoAyam")
        soto.name = "Soto"
        soto.setScale(0.18)
        soto.position = startPoint
        soto.zPosition = 2
        soto.physicsBody = SKPhysicsBody(rectangleOf: soto.size)
        soto.physicsBody!.affectedByGravity = false
        soto.physicsBody!.categoryBitMask = PhysicsCategories.Soto
        soto.physicsBody!.collisionBitMask = PhysicsCategories.None
        soto.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Sambal | PhysicsCategories.Sate
        self.addChild(soto)
        
        let moveSoto = SKAction.move(to: endPoint, duration: 2)
        let deleteSoto = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let sotoSequence = SKAction.sequence([moveSoto, deleteSoto, loseALifeAction])
        
        if currentGameState == gameState.duringGame {
            soto.run(sotoSequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        soto.zRotation = amountToRotate
    }
    
    func spawnSate(){
        let randomXStart = random1(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random1(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let sate = SKSpriteNode(imageNamed: "Sate")
        sate.name = "Sate"
        sate.setScale(0.16)
        sate.position = startPoint
        sate.zPosition = 2
        sate.physicsBody = SKPhysicsBody(rectangleOf: sate.size)
        sate.physicsBody!.affectedByGravity = false
        sate.physicsBody!.categoryBitMask = PhysicsCategories.Sate
        sate.physicsBody!.collisionBitMask = PhysicsCategories.None
        sate.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Soto | PhysicsCategories.Sambal
        self.addChild(sate)
        
        let moveSate = SKAction.move(to: endPoint, duration: 2)
        let deleteSate = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let sateSequence = SKAction.sequence([moveSate, deleteSate, loseALifeAction])
        
        if currentGameState == gameState.duringGame {
            sate.run(sateSequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        sate.zRotation = amountToRotate
    }
    
    func spawnSambal(){
        let randomXStart = random2(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random2(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let sambal = SKSpriteNode(imageNamed: "Sambal")
        sambal.name = "Sambal"
        sambal.setScale(0.14)
        sambal.position = startPoint
        sambal.zPosition = 2
        sambal.physicsBody = SKPhysicsBody(rectangleOf: sambal.size)
        sambal.physicsBody!.affectedByGravity = false
        sambal.physicsBody!.categoryBitMask = PhysicsCategories.Sambal
        sambal.physicsBody!.collisionBitMask = PhysicsCategories.None
        sambal.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Soto | PhysicsCategories.Sate
        self.addChild(sambal)
        
        let moveSambal = SKAction.move(to: endPoint, duration: 2)
        let deleteSambal = SKAction.removeFromParent()
        let sambalSequence = SKAction.sequence([moveSambal, deleteSambal])
        
        if currentGameState == gameState.duringGame{
            sambal.run(sambalSequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        sambal.zRotation = amountToRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.beforeGame{
            startGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.duringGame {
                player.position.x += amountDragged
            }
            
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/9{
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/9
            }
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/5.5{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/5.5
            }
        }
    }
    
    
}

