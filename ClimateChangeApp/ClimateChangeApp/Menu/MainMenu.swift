import SpriteKit
import GameplayKit
import UIKit

class MainMenu: SKScene {
  
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


    //UI Connections
    var buttonOne: ButtonNode!


        override func didMove(to view: SKView) {
           
            buttonOne = self.childNode(withName: "buttonOne") as? ButtonNode
            buttonOne.selectedHandler = {
                self.loadArcticDash()
            }

           
            
        }
    }
