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
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var detectedCardLabel: UILabel!
    @IBAction func addToHand()
    {
        pokerHand.addCard(currentCard)
        print(currentCard.getLabel())
        placeLabel(loc_x: posX, loc_y: posY, loc_z: 0, label: currentCard.getLabel())
        print("Added")
    }
    
    var pokerHand: Hand = Hand()
    var currentCard: Card = Card(1, "H")
    var posX:Float = 0
    var posY:Float = 0
    
    private let serialQueue = DispatchQueue(label: "com.hb.dispatchqueueml")
    private var visionRequests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAR()
        setupML()
        loopCoreMLUpdate()
    }
    
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
        let size:Float = 0.05
        node.scale = SCNVector3(x: size, y:size, z:size)
        node.geometry = Qhtext
        
        //adds node with text object to scene view
        sceneView.scene.rootNode.addChildNode(node)
        
        //adds default lighting for shadows
        sceneView.autoenablesDefaultLighting = true
    }
   
    private func setupML() {
        guard let selectedModel = try? VNCoreMLModel(for: CardDetector4().model) else {
            fatalError("Could not load model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: selectedModel,
                                                    completionHandler: classificationCompleteHandler)
        visionRequests = [classificationRequest]
    }
    
    private func setupAR() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    private func loopCoreMLUpdate() {
        serialQueue.async {
            self.updateCoreML()
            self.loopCoreMLUpdate()
        }
    }
    
    private func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    private func classificationCompleteHandler(request: VNRequest, error: Error?) {
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            return
        }
        
        if(observations.count == 0)
        {
            return
        }
        
        let classification = (observations[0] as! VNRecognizedObjectObservation)
        let indentifier = classification.labels[0].identifier
        let index = indentifier.index(indentifier.startIndex, offsetBy: 1)
        let suit:String = String(indentifier[index...])
        let unicodeSuit:String
        var capitalSuit:String
        let rankString = String(indentifier[..<index])
        
        if suit == "h" {
            unicodeSuit = "♥"
            capitalSuit = "H"
        }
        else if suit == "c"{
            unicodeSuit = "♣"
            capitalSuit = "C"
        }
        else if suit == "s"{
            unicodeSuit = "♠"
            capitalSuit = "S"
        }
        else if suit == "d"{
            unicodeSuit = "♦"
            capitalSuit = "D"
        }
        else
        {
            unicodeSuit = ""
            capitalSuit = ""
        }
        
        var rankValue:Int
        switch rankString {
        case "J":
            rankValue = 11;
        case "Q":
            rankValue = 12;
        case "K":
            rankValue = 13;
        case "A":
            rankValue = 14;
        default:
            rankValue = Int(rankString) ?? 0
        }
        
        let label = rankString + unicodeSuit
        currentCard = Card(rankValue, capitalSuit)
        
        posX = Float(classification.boundingBox.midX)
        posY = Float(classification.boundingBox.midY)
        DispatchQueue.main.async(execute:{self.detectedCardLabel.text = label})
    }
}
