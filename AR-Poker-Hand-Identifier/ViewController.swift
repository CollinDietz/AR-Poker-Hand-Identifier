//
//  ViewController.swift
//  AR-Poker-Hand-Identifier
//
//  Created by Collin Dietz on 1/28/19.
//  Copyright © 2019 SDLC. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        let loc_x = 0.0
        let loc_y = 0.02
        let loc_z = -0.1
        let label = "QC"
        placeLabel( loc_x: Float(loc_x), loc_y: Float(loc_y), loc_z: Float(loc_z), label: label)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
//      Function for adding QH object?
//    func addQH(x: Float = 0, y: Float = 0, z: Float = -0.5) {
//        guard let QHScene = SCNScene(named: "QH.dae"), let QHNode = QHScene.rootNode.childNode(withName: "QH", recursively: true) else { return }
//        QHNode.position = SCNVector3(x, y, z)
//        sceneView.scene.rootNode.addChildNode(QHNode)
//    }
//
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func placeLabel( loc_x: Float, loc_y: Float, loc_z: Float, label: String) {
        let start = label.index(label.startIndex, offsetBy: 1)
        let end = label.index(label.endIndex, offsetBy: 0)
        let range = start..<end
        
        let suit = label[range]  //sets suit to second character in label string and from there finds correct unicode symbol for suit
        let start2 = label.index(label.startIndex, offsetBy: 0)
        let end2 = label.index(label.endIndex, offsetBy: -1)
        let range2 = start2..<end2
        
        var value = label[range2]//stores value of label
        
        //checks lettering of suit and matches with unicode symbol
        var suitUnicode = ""
        if suit == "H" {
            suitUnicode = "♥"
        }
        if suit == "C"{
            suitUnicode = "♣"
        }
        if suit == "S"{
            suitUnicode = "♠"
        }
        if suit == "D"{
            suitUnicode = "♦"
        }
        
        value += suitUnicode //creates string for label to placed in object
        let Qhtext = SCNText(string: value, extrusionDepth: 1) //Text object and extrusion depth
        
        //Creates material to wrap around my text object and it colors it red if Heart or Diamond and black if CLub or Spade
        let material = SCNMaterial()
        if suit == "H" || suit == "D" {
            material.diffuse.contents = UIColor.red
        }
        if suit == "C" || suit == "S" {
            material.diffuse.contents = UIColor.black
        }
        Qhtext.materials = [material]
        
        //set position in line 2 and size in line 3
        let node = SCNNode()
        node.position = SCNVector3(x: loc_x, y: loc_y, z: loc_z)
        node.scale = SCNVector3(x: 0.01, y:0.01, z:0.01)
        node.geometry = Qhtext
        
        //adds node with text object to scene view
        sceneView.scene.rootNode.addChildNode(node)
        
        //adds default lighting for shadows
        sceneView.autoenablesDefaultLighting = true
    }
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
