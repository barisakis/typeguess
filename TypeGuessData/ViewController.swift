//
//  ViewController.swift
//  ageClassifier
//
//  Created by Abraham Starosta on 10/27/14.
//  Copyright (c) 2014 cs229. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    @IBOutlet var textWindow: UITextView!
    
    
    @IBOutlet var inputfieldvalue: UITextField!
    
    var inputfieldlength: Int = 0
    var characters = [String]()
    var times = [Double]()
    var curr_text = 0
    var curr_question = 0
    let questions = ["Which phone do you use? Type iPhone4, iPhone5, or Android", "What is your age?", "Do you use 1 or 2 thumbs? Type 1/2", "Do you usually use autocorrect? Type 'y' if yes, or 'n' if no"]
    let texts = ["xxxbxhgsjhgcsjdakgfasjdgfkjahsdgfkjashgdfkasdhjgfksadjhgfkasjdhgfkajshdfgasdkjh", "If you're a hacker that wants to feel like royalty for playing with an API, go check out Keen IO. This is the most elaborate package i've received in years. S/O to Song Zheng for discovery"]
    
    let phones = ["iPhone5", "iPhone4", "Android"]
    
//    var sensorData = [][]
    
    
    lazy var motionManager = CMMotionManager()
    
    
    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent) {
            
            if motion == .MotionShake{
                let controller = UIAlertController(title: "Shake",
                    message: "The device is shaken",
                    preferredStyle: .Alert)
                
                controller.addAction(UIAlertAction(title: "OK",
                    style: .Default,
                    handler: nil))
                
                presentViewController(controller, animated: true, completion: nil)
                
            }
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let queue = NSOperationQueue()
        
        var sensorInstance = [Double]()
        
        if (motionManager.accelerometerAvailable){
            println("accelerometer available")
            
            motionManager.accelerometerUpdateInterval = 1.0 / 10.0
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    var prev_z_a = 0.0;
                    
                    var x_a = data.acceleration.x
                    var y_a = data.acceleration.y
                    var z_a = data.acceleration.z
                    sensorInstance = []
                    sensorInstance.insert(x_a, atIndex: 0)
                    sensorInstance.insert(y_a, atIndex: 1)
                    sensorInstance.insert(z_a, atIndex: 2)
                    
                    if(prev_z_a < z_a){
                        println("Z A +++")
                    }else{
                        println("z A ---")
                    }
                    
                    if (z_a>0){
                        println("UP")
                    }else{
                        println("DOWN")
                    }
                    
                    println("Accelerometer X = \(x_a)")
                    println("Accelerometer Y = \(y_a)")
                    println("Accelerometer Z = \(z_a)")
                    
                    prev_z_a = z_a
                }
            )
            
            println(motionManager.accelerometerActive)
        }
        
        if (motionManager.gyroAvailable){
            println("gyro available")
            motionManager.gyroUpdateInterval = 1.0 / 10.0
            
            motionManager.startGyroUpdatesToQueue(queue,
                withHandler: {(data: CMGyroData!, error: NSError!) in
                    var prev_z_g = 0.0;
                    
                    var x_g = data.rotationRate.x
                    var y_g = data.rotationRate.y
                    var z_g = data.rotationRate.z
                    
                    sensorInstance.insert(x_g, atIndex: 3)
                    sensorInstance.insert(y_g, atIndex: 4)
                    sensorInstance.insert(z_g, atIndex: 5)
                    
                    if(prev_z_g < z_g){
                        println("Z R +++")
                    }else{
                        println("z R ---")
                    }
                    
                    if (z_g>0){
                        println("Rotate UP")
                    }else{
                        println("Rotate Down")
                    }
                    
                    println("Gyro X = \(x_g)")
                    println("Gyro Y = \(y_g)")
                    println("Gyro Z = \(z_g)")
                    
                    prev_z_g = z_g
                    
                    println(sensorInstance)
            })

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func getinput(sender: AnyObject) {
        var time = NSDate.timeIntervalSinceReferenceDate()
        
        var inputfieldlength2 = countElements(inputfieldvalue.text)
        var character = ""
        if inputfieldlength2<inputfieldlength{
            //println("BACKSPACE")
            character = "BACKSPACE"
        }else{
            character = inputfieldvalue.text.substringFromIndex(inputfieldvalue.text.endIndex.predecessor())
            //println(inputfieldvalue.text.substringFromIndex(inputfieldvalue.text.endIndex.predecessor()))
        }
        inputfieldlength = inputfieldlength2
        
        characters.append(character)
        times.append(time)
        println(characters)
        println(times)

    }
    @IBAction func changetext3(sender: AnyObject) {
        var inputfieldlength = countElements(inputfieldvalue.text)
        if inputfieldlength > 0 && curr_text < countElements(texts){
            textWindow.text = texts[curr_text]
            curr_text += 1
        }
        else if curr_text == countElements(texts)
            && curr_question < countElements(questions){
                textWindow.text = questions[curr_question]
                curr_question += 1
        }
        inputfieldvalue.text = ""
    }

    
}