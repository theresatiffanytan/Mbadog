//
//  MainMenuScene.swift
//  TasteOfIndonesia
//
//  Created by Theresa Tiffany on 17/04/23.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "backgroundStart")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameName = SKLabelNode(fontNamed: "Copperplate")
        gameName.text = "Mbadog"
        gameName.fontSize = 180
        gameName.fontColor = SKColor.black
        gameName.position = CGPoint(x: self.size.width*0.29, y: self.size.height*0.78)
        gameName.zPosition = 1
        self.addChild(gameName)
        
        let instruction1 = SKLabelNode(fontNamed: "Copperplate")
        instruction1.text = "Eat the Soto and Sate"
        instruction1.fontSize = 70
        instruction1.fontColor = SKColor.black
        instruction1.position = CGPoint(x: self.size.width*0.65, y: self.size.height*0.6)
        instruction1.zPosition = 1
        self.addChild(instruction1)
        
        let instruction2 = SKLabelNode(fontNamed: "Copperplate")
        instruction2.text = "before they pass the screen!"
        instruction2.fontSize = 60
        instruction2.fontColor = SKColor.black
        instruction2.position = CGPoint(x: self.size.width*0.663, y: self.size.height*0.55)
        instruction2.zPosition = 1
        self.addChild(instruction2)
        
        let instruction3 = SKLabelNode(fontNamed: "Copperplate")
        instruction3.text = "Remember to avoid the SAMBAL"
        instruction3.fontSize = 70
        instruction3.fontColor = SKColor.black
        instruction3.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.40)
        instruction3.zPosition = 1
        self.addChild(instruction3)
        
        let instruction4 = SKLabelNode(fontNamed: "Copperplate")
        instruction4.text = "before the spiciness haunt you"
        instruction4.fontSize = 60
        instruction4.fontColor = SKColor.black
        instruction4.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.35)
        instruction4.zPosition = 1
        self.addChild(instruction4)
        
        let start = SKLabelNode(fontNamed: "Copperplate")
        start.text = "Start"
        start.fontSize = 180
        start.fontColor = SKColor.black
        start.zPosition = 1
        start.position = CGPoint(x: self.size.width*0.74, y: self.size.height*0.2)
        start.name = "startButton"
        self.addChild(start)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            for nodeTapped in self.nodes(at: pointOfTouch){
                
                if nodeTapped.name == "startButton"{
                    let sceneToMoveTo = GameScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
            }
            
        }
    }
    
}

