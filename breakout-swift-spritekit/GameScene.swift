//
//  GameScene.swift
//  breakout-swift-spritekit
//
//  Created by giaunv on 4/11/15.
//  Copyright (c) 2015 366. All rights reserved.
//

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let BlockNodeCategoryName = "blockNode"

class GameScene: SKScene {
    var isFingerOnPaddle = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view);
        
        // Create a physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
        // Set the friction of that physicsBody to 0
        borderBody.friction = 0
        // Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        let ball = childNodeWithName(BallCategoryName) as SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -10))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch = touches.anyObject() as UITouch!
        var touchLocation = touch.locationInNode(self);
        
        if let body = physicsWorld.bodyAtPoint(touchLocation){
            if body.node!.name == PaddleCategoryName{
                println("Began touch on paddle")
                isFingerOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        // Check whether user touched the paddle
        if isFingerOnPaddle {
            // Get touch location
            var touch = touches.anyObject() as UITouch!
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            // Get node for paddle
            var paddle = childNodeWithName(PaddleCategoryName) as SKSpriteNode!
            
            // Calculate new position along x for paddle
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            // Limit x so that paddle won't leave screen to left or right
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            // Update paddle position
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }
}