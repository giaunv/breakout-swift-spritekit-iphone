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

let BallCategory: UInt32 = 0x1 << 0 // 00000000000000000000000000000001
let BottomCategory: UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let BlockCategory: UInt32 = 0x1 << 2 // 00000000000000000000000000000100
let PaddleCategory: UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isFingerOnPaddle = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view);
        
        // Create a physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
        // Set the friction of that physicsBody to 0
        borderBody.friction = 0
        // Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        
        // Forever bouncing
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName(BallCategoryName) as SKSpriteNode!
        ball.physicsBody!.applyImpulse(CGVectorMake(10, -10))
        
        // Create an edge-based body that covers the bottom of the screen
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        // Set up the categoryBitMasks
        let paddle = childNodeWithName(PaddleCategoryName) as SKSpriteNode!
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        // Set up the contactTestBitMask
        ball.physicsBody!.contactTestBitMask = BottomCategory
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Create local variables for two physic bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Assign two physic bodies so that the one with the lower category is always stored in fristBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // React to the contact between ball and bottom
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            // TODO: Replace the log statement with display of Game Over Scene
            println("Hit bottom. First contact has been made.")
        }
    }
}