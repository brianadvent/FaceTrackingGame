//
//  GameScene.swift
//  FaceRun
//
//  Created by Brian Advent on 21.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var playerNode:Player?
    var moving:Bool = false
    
    var generator:UIImpactFeedbackGenerator!
    
    override func didMove(to view: SKView) {
        playerNode = self.childNode(withName: "player") as? Player
       
        generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
    }
    
    
    func updatePlayer (state:PlayerState) {
        if !moving {
            movePlayer(state: state)
        }

    }
    
    func movePlayer (state:PlayerState) {
        if let player = playerNode {
            player.texture = SKTexture(imageNamed: state.rawValue)
            
            var direction:CGFloat = 0
            
            switch state {
            case .up:
                direction = 116
            case .down:
                direction = -116
            case .neutral:
                direction = 0
            }
            
            if Int(player.position.y) + Int(direction) >= -232 && Int(player.position.y) + Int(direction) <= 232 {
                
                moving = true
                
                let moveAction = SKAction.moveBy(x: 0, y: direction, duration: 0.3)
                
                let moveEndedAction = SKAction.run {
                    self.moving = false
                    if direction != 0 {
                        self.generator.impactOccurred()
                    }
                }
                
                let moveSequence = SKAction.sequence([moveAction, moveEndedAction])
                
                player.run(moveSequence)
                
                
            }
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       
    }
}
