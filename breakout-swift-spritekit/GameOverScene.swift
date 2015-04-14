//
//  GameOverScene.swift
//  breakout-swift-spritekit
//
//  Created by giaunv on 4/14/15.
//  Copyright (c) 2015 366. All rights reserved.
//

import SpriteKit

let GameOverLabelCategoryName = "gameOverLabel"

class GameOverScene: SKScene {
    var gameWon : Bool = false {
        didSet {
            let gameOverLabel = childNodeWithName(GameOverLabelCategoryName) as SKLabelNode!
            gameOverLabel.text = gameWon ? "Game Won" : "Game Over"
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let view = view {
            let gameScene = GameScene.unarchiveFromFile("GameScene") as GameScene!
            view.presentScene(gameScene)
        }
    }
}
