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
        let loc_x1 = -0.15
        let loc_y1 = -0.2
        let loc_z1 = -0.4
        let label1 = "AH"
        
        let loc_x2 = -0.06
        let loc_y2 = -0.2
        let loc_z2 = -0.45
        let label2 = "AD"
        
        let loc_x3 = 0.0
        let loc_y3 = -0.2
        let loc_z3 = -0.4
        let label3 = "AC"
        
        let loc_x4 = 0.06
        let loc_y4 = -0.2
        let loc_z4 = -0.45
        let label4 = "2S"
        
        let loc_x5 = 0.15
        let loc_y5 = -0.2
        let loc_z5 = -0.4
        let label5 = "2D"
        //6th card for error testing
//        let loc_x6 = 0.21
//        let loc_y6 = -0.2
//        let loc_z6 = -0.4
//        let label6 = "TD"
        
        //details for hand evaluation to be displayed in scene
        let loc_Handx = -0.3
        let loc_Handy = 0.0
        let loc_Handz = -0.4
        
        //create poker hand artificially  to be evaluated
        var pokerHand: Hand = Hand();
        
        var card1 = Card(1, "hearts");
        pokerHand.addCard(card1);
        card1 = Card(1, "clubs");
        pokerHand.addCard(card1);
        card1 = Card(11, "hearts");
        pokerHand.addCard(card1);
        card1 = Card(11, "clubs");
        pokerHand.addCard(card1);
        card1 = Card(11, "diamonds");
        pokerHand.addCard(card1);
        //6th card for error testing
//        card1 = Card(10, "diamonds");
//        pokerHand.addCard(card1);
        
        //evaluate artifical hand
        let typeOfHand: HandValue = Evaluator(pokerHand);
       
        //create hard coded labels
        placeLabel( loc_x: Float(loc_x1), loc_y: Float(loc_y1), loc_z: Float(loc_z1), label: label1)
        placeLabel( loc_x: Float(loc_x2), loc_y: Float(loc_y2), loc_z: Float(loc_z2), label: label2)
        placeLabel( loc_x: Float(loc_x3), loc_y: Float(loc_y3), loc_z: Float(loc_z3), label: label3)
        placeLabel( loc_x: Float(loc_x4), loc_y: Float(loc_y4), loc_z: Float(loc_z4), label: label4)
        placeLabel( loc_x: Float(loc_x5), loc_y: Float(loc_y5), loc_z: Float(loc_z5), label: label5)
        //6th card for error testing
       // placeLabel( loc_x: Float(loc_x6), loc_y: Float(loc_y6), loc_z: Float(loc_z6), label: label6)
        
        //typeofHand has the results of evaluator() stored in it and that is used to cread 3D object below
        placeHandLabel( loc_x: Float(loc_Handx), loc_y: Float(loc_Handy), loc_z: Float(loc_Handz), label: typeOfHand.rawValue)
      
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
    //fucniton for rotation animation of labels in AR scene
    func addAnimation(node: SCNNode) {
        let rotateOne = SCNAction.rotateBy(x: 0, y: (-CGFloat(Float.pi)), z: 0, duration: 1.0)
        //let hoverUp = SCNAction.moveBy(x: 0, y: 0.01, z: 0, duration: 2)
        //let hoverDown = SCNAction.moveBy(x: 0, y: -0.01, z: 0, duration: 2)
        //let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([rotateOne])
        let repeatForever = SCNAction.repeatForever(rotateAndHover)
        node.runAction(repeatForever)
        }

    // MARK: - ARSCNViewDelegate
    
    //places label for value and suit of individual cards
    func placeLabel( loc_x: Float, loc_y: Float, loc_z: Float, label: String) {
        let start = label.index(label.startIndex, offsetBy: 1)
        let end = label.index(label.endIndex, offsetBy: 0)
        let range = start..<end
        
        let suit = label[range]  //sets suit to second character in label string and from there finds correct unicode symbol for suit
        let start2 = label.index(label.startIndex, offsetBy: 0)
        let end2 = label.index(label.endIndex, offsetBy: -1)
        let range2 = start2..<end2
        
        var value = label[range2]//stores value of label
        if value == "T"{
            value = "10"
        }
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
        node.scale = SCNVector3(x: 0.002, y:0.002, z:0.002)
        node.geometry = Qhtext
        //addAnimation(node:node)
        
        //adds node with text object to scene view
        sceneView.scene.rootNode.addChildNode(node)
        
        //adds default lighting for shadows
        sceneView.autoenablesDefaultLighting = true
    }
    
    //places label for output of evaluator() function or possibly any errors handled by that function
    func placeHandLabel( loc_x: Float, loc_y: Float, loc_z: Float, label: String) {
       let HandValue = SCNText(string: label, extrusionDepth: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        HandValue.materials = [material]
        
        //set position in line 2 and size in line 3
        let node = SCNNode()
        node.position = SCNVector3(x: loc_x, y: loc_y, z: loc_z)
        node.scale = SCNVector3(x: 0.008, y:0.008, z:0.008)
        node.geometry = HandValue
        //addAnimation(node:node)
        
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
