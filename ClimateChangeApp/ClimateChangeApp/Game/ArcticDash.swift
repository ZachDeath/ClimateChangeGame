import GameplayKit
import SpriteKit

class ArcticDash: SKScene, SKPhysicsContactDelegate {
  
 //nodes
var gameNode: SKNode!
var groundNode: SKNode!
var backgroundNode: SKNode!
var obstacleNode: SKNode!
var mainPenguinNode: SKNode!
var penguinsNode: SKNode!
  
 //score
var scoreNode: SKLabelNode!
var score = 0 as Int
  
 //sprites
var mainPenguinSprite: SKSpriteNode!
  
 //spawning vars
var spawnRate = 1.5 as Double
var timeSinceLastSpawn = 0.0 as Double
  
 //generic vars
var groundHeight: CGFloat?
var penguinYPosition: CGFloat?
var groundSpeed = 500 as CGFloat
  
 //consts
let penguinJumpForce = 870 as Int
let cloudSpeed = 50 as CGFloat
  
 let background = 0 as CGFloat
let foreground = 1 as CGFloat
  
 //collision categories
let groundCategory = 1 << 0 as UInt32
let mainPenguinCategory = 1 << 1 as UInt32
let obstacleCategory = 1 << 2 as UInt32
let penguinsCategory = 1 << 3 as UInt32
  
 override func didMove(to view: SKView) {
  
 self.physicsWorld.contactDelegate = self
self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -8)
  
 //ground
groundNode = SKNode()
groundNode.zPosition = background
createAndMoveGround()
addCollisionToGround()
  
 //clouds and background
backgroundNode = SKNode()
backgroundNode.zPosition = background
createClouds()
  
 //Main Penguin
mainPenguinNode = SKNode()
mainPenguinNode.zPosition = foreground
createMainPenguin()
  
 //obstacle
obstacleNode = SKNode()
obstacleNode.zPosition = foreground
  
 //penguins
penguinsNode = SKNode()
penguinsNode.zPosition = foreground
  
 //score
score = 0
scoreNode = SKLabelNode(fontNamed: "Fat Pixels")
scoreNode.fontSize = 40
scoreNode.zPosition = foreground
scoreNode.text = "Score: 0"
scoreNode.fontColor = SKColor.white
scoreNode.position = CGPoint(x: 150, y: 100)
  
 //parent game node
gameNode = SKNode()
gameNode.addChild(groundNode)
gameNode.addChild(backgroundNode)
gameNode.addChild(mainPenguinNode)
gameNode.addChild(obstacleNode)
gameNode.addChild(penguinsNode)
gameNode.addChild(scoreNode)
self.addChild(gameNode)
}
  
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
if(gameNode.speed < 1.0){
return
}
  
 for _ in touches {

                if let groundPosition = penguinYPosition {
                    if mainPenguinSprite.position.y <= (groundPosition + 10) && gameNode.speed > 0 {
                        mainPenguinSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: penguinJumpForce))
                    }
                }
            }
        }


        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
            if(gameNode.speed > 0){
                groundSpeed += 0.2

                score += 1
                scoreNode.text = "Score: \(score/5)"

                if(currentTime - timeSinceLastSpawn > spawnRate){
                    timeSinceLastSpawn = currentTime
                    spawnRate = Double.random(in: 1.0 ..< 3.5)

                    if(Int.random(in: 0...10) < 8){
                        spawnObstacle()
                    } else {
                        spawnPenguins()
                    }
                }
            }
        }



        func didBegin(_ contact: SKPhysicsContact) {
            if(hitObstacle(contact) || hitPenguins(contact)){
                loadGameOver()
            }
        }

        func hitObstacle(_ contact: SKPhysicsContact) -> Bool {
            return contact.bodyA.categoryBitMask & obstacleCategory == obstacleCategory ||
                contact.bodyB.categoryBitMask & obstacleCategory == obstacleCategory
        }

        func hitPenguins(_ contact: SKPhysicsContact) -> Bool {
            return contact.bodyA.categoryBitMask & penguinsCategory == penguinsCategory ||
                    contact.bodyB.categoryBitMask & penguinsCategory == penguinsCategory
        }


    func loadGameOver() {
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        guard let scene = ArcticDash(fileNamed:"GameOver") else {
            print("Error")
            return
        }

        scene.scaleMode = .aspectFill
        let reveal = SKTransition.fade(withDuration: 1)
        skView.presentScene(scene, transition: reveal)
    }

        func createAndMoveGround() {
            let screenWidth = self.frame.size.width

            //ground texture
            let groundTexture = SKTexture(imageNamed: "Ice")
            groundTexture.filteringMode = .nearest

            let homeButtonPadding = 50.0 as CGFloat
            groundHeight = groundTexture.size().height + homeButtonPadding

            //ground actions
            let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width,
                                                 y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
            let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0.0, duration: 0.0)
            let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])

            //ground nodes
            let numberOfGroundNodes = 1 + Int(ceil(screenWidth / groundTexture.size().width))

            for i in 0 ..< numberOfGroundNodes {
                let node = SKSpriteNode(texture: groundTexture)
                node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                node.position = CGPoint(x: CGFloat(i) * groundTexture.size().width, y: groundHeight!)
                groundNode.addChild(node)
                node.run(SKAction.repeatForever(groundLoop))
            }
        }

        func addCollisionToGround() {
            let groundContactNode = SKNode()
            groundContactNode.position = CGPoint(x: 0, y: groundHeight! - 30)
            groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 3,
                                                                              height: groundHeight!))
            groundContactNode.physicsBody?.friction = 0.0
            groundContactNode.physicsBody?.isDynamic = false
            groundContactNode.physicsBody?.categoryBitMask = groundCategory

            groundNode.addChild(groundContactNode)
        }

        func createClouds() {
            //texture
            let cloudTexture = SKTexture(imageNamed: "CloudOne")
            let cloudScale = 0.8 as CGFloat
            cloudTexture.filteringMode = .nearest

            //clouds
            let numClouds = 3
            for i in 0 ..< numClouds {
                //create sprite
                let cloudSprite = SKSpriteNode(texture: cloudTexture)
                cloudSprite.setScale(cloudScale)
                //add to scene
                backgroundNode.addChild(cloudSprite)

                //animate the cloud
                animateCloud(cloudSprite, cloudIndex: i, textureWidth: cloudTexture.size().width * cloudScale)
            }
        }

        func animateCloud(_ sprite: SKSpriteNode, cloudIndex i: Int, textureWidth: CGFloat) {
            let screenWidth = self.frame.size.width
            let screenHeight = self.frame.size.height

            let cloudOffscreenDistance = (screenWidth / 3.0) * CGFloat(i) + 100 as CGFloat
            let cloudYPadding = 50 as CGFloat
            let cloudYPosition = screenHeight - (CGFloat(i) * cloudYPadding) - 200

            let distanceToMove = screenWidth + cloudOffscreenDistance + textureWidth

            //actions
            let moveCloud = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(distanceToMove / cloudSpeed))
            let resetCloud = SKAction.moveBy(x: distanceToMove, y: 0.0, duration: 0.0)
            let cloudLoop = SKAction.sequence([moveCloud, resetCloud])

            sprite.position = CGPoint(x: screenWidth + cloudOffscreenDistance, y: cloudYPosition)
            sprite.run(SKAction.repeatForever(cloudLoop))
        }

        func createMainPenguin() {
            let screenWidth = self.frame.size.width
            let penguinScale = 0.2 as CGFloat

            //texture
            let PenguinTexture1 = SKTexture(imageNamed: "Penguin 3")
            PenguinTexture1.filteringMode = .nearest


            mainPenguinSprite = SKSpriteNode()
           mainPenguinSprite.size = PenguinTexture1.size()
            mainPenguinSprite.setScale(penguinScale)
            mainPenguinNode.addChild(mainPenguinSprite)

            let physicsBox = CGSize(width: PenguinTexture1.size().width * penguinScale,
                                    height: PenguinTexture1.size().height * penguinScale)



          mainPenguinSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
            mainPenguinSprite.physicsBody?.isDynamic = true
            mainPenguinSprite.physicsBody?.mass = 1
           mainPenguinSprite.physicsBody?.categoryBitMask = mainPenguinCategory
          mainPenguinSprite.physicsBody?.contactTestBitMask = penguinsCategory | obstacleCategory
          mainPenguinSprite.physicsBody?.collisionBitMask = groundCategory

            penguinYPosition = getGroundHeight() + PenguinTexture1.size().height * penguinScale
           mainPenguinSprite.position = CGPoint(x: screenWidth * 0.15, y: penguinYPosition!)
            mainPenguinSprite.texture = PenguinTexture1
        }

        func spawnObstacle() {
            let obstacleTextures = ["ObstacleOne", "ObstacleTwo", "ObstacleThree", "ObstacleFour"]
            let obstacleScale = 1.1 as CGFloat

            //texture
            let obstacleTexture = SKTexture(imageNamed: "Obstacles/" + obstacleTextures.randomElement()!)
           obstacleTexture.filteringMode = .nearest

            //sprite
            let obstacleSprite = SKSpriteNode(texture: obstacleTexture)
            obstacleSprite.setScale(obstacleScale)

            //physics
            let contactBox = CGSize(width: obstacleTexture.size().width * obstacleScale,
                                    height: obstacleTexture.size().height * obstacleScale)
           obstacleSprite.physicsBody = SKPhysicsBody(rectangleOf: contactBox)
             obstacleSprite.physicsBody?.isDynamic = true
             obstacleSprite.physicsBody?.mass = 1.0
             obstacleSprite.physicsBody?.categoryBitMask = obstacleCategory
              obstacleSprite.physicsBody?.contactTestBitMask = penguinsCategory
             obstacleSprite.physicsBody?.collisionBitMask = groundCategory

            //add to scene
          obstacleNode.addChild(obstacleSprite)
            //animate
            animateObstacle(sprite: obstacleSprite, texture: obstacleTexture)
        }

        func animateObstacle(sprite: SKSpriteNode, texture: SKTexture) {
            let screenWidth = self.frame.size.width
            let distanceOffscreen = 50.0 as CGFloat
            let distanceToMove = screenWidth + distanceOffscreen + texture.size().width

            //actions
            let moveObstacle = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
            let removeObstacle = SKAction.removeFromParent()
            let moveAndRemove = SKAction.sequence([moveObstacle, removeObstacle])

            sprite.position = CGPoint(x: distanceToMove, y: getGroundHeight() + texture.size().height)
            sprite.run(moveAndRemove)
        }

        func spawnPenguins() {
            //textures
            let penguinsTexture1 = SKTexture(imageNamed: "PenguinOne")
            let penguinsTexture2 = SKTexture(imageNamed: "PenguinTwo")
            let penguinsScale = 0.8 as CGFloat
            penguinsTexture1.filteringMode = .nearest
            penguinsTexture2.filteringMode = .nearest

            //animation
            let screenWidth = self.frame.size.width
            let distanceOffscreen = 50.0 as CGFloat
            let distanceToMove = screenWidth + distanceOffscreen + penguinsTexture1.size().width * penguinsScale

            let flapAnimation = SKAction.animate(with: [penguinsTexture1, penguinsTexture2], timePerFrame: 0.2)
            let movePenguins = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
            let removePenguins = SKAction.removeFromParent()
            let moveAndRemove = SKAction.sequence([movePenguins, removePenguins])

            //sprite
            let penguinsSprite = SKSpriteNode()
            penguinsSprite.size = penguinsTexture1.size()
            penguinsSprite.setScale(penguinsScale)

            //physics
            let penguinsContact = CGSize(width: penguinsTexture1.size().width * penguinsScale,
                                     height: penguinsTexture1.size().height * penguinsScale)
            penguinsSprite.physicsBody = SKPhysicsBody(rectangleOf: penguinsContact)
            penguinsSprite.physicsBody?.isDynamic = false
            penguinsSprite.physicsBody?.mass = 1.0
            penguinsSprite.physicsBody?.categoryBitMask = penguinsCategory
            penguinsSprite.physicsBody?.contactTestBitMask = mainPenguinCategory

            penguinsSprite.position = CGPoint(x: distanceToMove,
                                          y: getGroundHeight() + penguinsTexture1.size().height * penguinsScale + 20)
            penguinsSprite.run(SKAction.group([moveAndRemove, SKAction.repeatForever(flapAnimation)]))

            //add to scene
            penguinsNode.addChild(penguinsSprite)
        }

        func getGroundHeight() -> CGFloat {
            if let gHeight = groundHeight {
                return gHeight
            } else {
                print("Ground size wasn't previously calculated")
                exit(0)
            }
        }

    }
