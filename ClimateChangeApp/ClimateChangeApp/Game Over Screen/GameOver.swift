

import SpriteKit
import GameplayKit
import UIKit

extension UIColor {
convenience init(red: Int, green: Int, blue: Int) {
assert(red >= 0 && red <= 255, "Invalid red component")
assert(green >= 0 && green <= 255, "Invalid green component")
assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)

}

convenience init(rgb: Int) {
self.init(
red: (rgb >> 16) & 0xFF,
green: (rgb >> 8) & 0xFF,
blue: rgb & 0xFF
)
}
}

class GameOver: SKScene {
  


    var tipNode = UILabel.self

    let background = 0 as CGFloat
    let foreground = 1 as CGFloat


    func loadArcticDash() {
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        guard let scene = ArcticDash(fileNamed:"ArcticDash") else {
            print("Error")
            return
        }

        scene.scaleMode = .aspectFill
        let reveal = SKTransition.fade(withDuration: 1)
        skView.presentScene(scene, transition: reveal)
    }

    func loadMainMenu() {
        guard let skView = self.view as SKView? else {
            print("Could not get Skview")
            return
        }

        guard let scene = MainMenu(fileNamed:"MainMenu") else {
            print("Error")
            return
        }

        scene.scaleMode = .aspectFill
        let reveal = SKTransition.fade(withDuration: 1)
        skView.presentScene(scene, transition: reveal)
    }

    /* UI Connections */
    var buttonOne: ButtonNode!
    var buttonTwo: ButtonNode!
    var tip: SKLabelNode!

        override func didMove(to view: SKView) {
            /* Setup your scene here */
            buttonOne = self.childNode(withName: "buttonOne") as? ButtonNode
            buttonOne.selectedHandler = {
                self.loadArcticDash()
            }

                spawnTip()

            buttonTwo = self.childNode(withName: "buttonTwo") as? ButtonNode
            buttonTwo.selectedHandler = {
                self.loadMainMenu()
            }

    }

    func spawnTip(){
        let tip = ["Recycling can help fight climate change!",
                   "Turning off your electrical items when you finish with them is good for the environment!",
                   "Planting trees can help with climate change!",
                   "2019 was the warmest year on record ever",
                   "Average sea levels have raised 3 inches in the last 25 years",
                   "Penguins are expert swimmers!" ,
                   " 10% of the world’s land is covered in ice!" ,
                   "The 20 warmest years on record have been in the past 22 years",
                   "There are 8.7 million species on earth; we have to protect them!" ,
                   "139 acres of trees are cut down per minute. We need to save them!",
                   "Recycling 1 tonne of paper can save 17 trees!",
                   "It takes 5 litres of water to make one piece of paper, so recycle!",
                   "If we all help fight climate change we can make a difference!"]

                  
        let randomTip = tip.randomElement()!
        let tipNode = SKLabelNode(fontNamed: "Fat Pixels")

        tipNode.text = "Did you know: " + randomTip
        tipNode.fontSize = 30
        tipNode.zPosition = foreground
        tipNode.fontColor = UIColor(rgb: 0x082071)
        tipNode.position = CGPoint(x: 0, y: 0)
        tipNode.numberOfLines = 2
        tipNode.preferredMaxLayoutWidth = 1200
        addChild(tipNode)

    }

}
