//
//  GameViewController.swift
//  FaceRun
//
//  Created by Brian Advent on 21.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class GameViewController: UIViewController, ARSessionDelegate {

    var gameScene:GameScene!
    var session:ARSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                gameScene = scene
                // Set the scale mode to scale to fit the window
                gameScene.scaleMode = .aspectFill
            
                // Present the scene
                view.presentScene(gameScene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            session = ARSession()
            session.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {print("iPhone X required"); return}
        
        let configuration = ARFaceTrackingConfiguration()
        
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: ARSession Delegate
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first as? ARFaceAnchor {
            update(withFaceAnchor: faceAnchor)
        }
    }
    
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        var bledShapes:[ARFaceAnchor.BlendShapeLocation:Any] = faceAnchor.blendShapes
        
        guard let browInnerUp = bledShapes[.browInnerUp] as? Float else {return}
        print(browInnerUp)
        
        if browInnerUp > 0.5 {
            gameScene.updatePlayer(state: .up)
        }else if browInnerUp < 0.025 {
            gameScene.updatePlayer(state: .down)
        }else {
            gameScene.updatePlayer(state: .neutral)
        }
        
    }
}
