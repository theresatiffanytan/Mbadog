//
//  GameViewController.swift
//  TasteOfIndonesia
//
//  Created by Theresa Tiffany on 06/04/23.
//

import UIKit
import SpriteKit
import GameplayKit
import SwiftUI
import Subsonic

struct ContentView: View {
    
    var scene: SKScene {
        
        play(sound: "Spring Thaw - Asher Fulero.mp3", volume: 1, repeatCount: -1)
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        scene.scaleMode = .aspectFill
        return scene
        
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            .previewInterfaceOrientation(.portrait)
    }
}

