import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


                if let view = self.view as! SKView? {
                    if let scene = SKScene(fileNamed: "MainMenu") {
                        scene.scaleMode = .aspectFill

                        // Present the scene
                        view.presentScene(scene)
                    }

                    view.ignoresSiblingOrder = true
                }
            }

      override var shouldAutorotate: Bool {
                    return true
                }

                override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        return .landscape
                    } else {
                        return .all
                    }
                }

                override var prefersStatusBarHidden: Bool {
                    return true
                }
            }
