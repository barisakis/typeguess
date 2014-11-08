//
//  ViewController.swift
//  ageClassifier
//
//  Created by Abraham Starosta on 10/27/14.
//  Copyright (c) 2014 cs229. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation

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
    
    //NEW Variables
    var sensorArrayAccelerometer = Array<Array<Double>>()
    var sensorArrayGyro = Array<Array<Double>>()
    let gyroRate = 10.0;
    let accRate = 10.0;
    var keyPressIndices = Array<Array<Int>>()
    
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
        
        var sensorInstanceAccelerometer = [Double]()
        var sensorInstanceGyro = [Double]()
        
        if (motionManager.accelerometerAvailable){
            println("accelerometer available")
            
            motionManager.accelerometerUpdateInterval = 1.0/accRate
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    var prev_z_a = 0.0;
                    
                    var x_a = data.acceleration.x
                    var y_a = data.acceleration.y
                    var z_a = data.acceleration.z
                    sensorInstanceAccelerometer = []
                    sensorInstanceAccelerometer.insert(x_a, atIndex: 0)
                    sensorInstanceAccelerometer.insert(y_a, atIndex: 1)
                    sensorInstanceAccelerometer.insert(z_a, atIndex: 2)
                    self.sensorArrayAccelerometer.append(sensorInstanceAccelerometer)
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
                    
//                    println("Accelerometer X = \(x_a)")
//                    println("Accelerometer Y = \(y_a)")
//                    println("Accelerometer Z = \(z_a)")
                    
                    prev_z_a = z_a
                }
            )
            
            println(motionManager.accelerometerActive)
        }
        
        if (motionManager.gyroAvailable){
            println("gyro available")
            motionManager.gyroUpdateInterval = 1.0 / gyroRate
            
            motionManager.startGyroUpdatesToQueue(queue,
                withHandler: {(data: CMGyroData!, error: NSError!) in
                    var prev_z_g = 0.0;
                    
                    var x_g = data.rotationRate.x
                    var y_g = data.rotationRate.y
                    var z_g = data.rotationRate.z
                    sensorInstanceGyro = []
                    sensorInstanceGyro.insert(x_g, atIndex: 0)
                    sensorInstanceGyro.insert(y_g, atIndex: 1)
                    sensorInstanceGyro.insert(z_g, atIndex: 2)
                    self.sensorArrayGyro.append(sensorInstanceGyro)
                    
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
                    
//                    println("Gyro X = \(x_g)")
//                    println("Gyro Y = \(y_g)")
//                    println("Gyro Z = \(z_g)")
                    
                    prev_z_g = z_g
                    
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
        
        //BARIS EDITS
        
        var keyPressedIndex = [Int]();
        
        //Function to get the index of the array for gyro and accelerometer instance at the click
        var accelerometerIndex = sensorArrayAccelerometer.count
        var gyroIndex = sensorArrayGyro.count
        
        keyPressedIndex.append(accelerometerIndex)
        keyPressedIndex.append(gyroIndex)
        
        keyPressIndices.append(keyPressedIndex)
    }
    @IBAction func changetext3(sender: AnyObject) {

        //BARIS EDITS
    
        var nextPressedIndex = [Int]();
        //Function to get the index of the array for gyro and accelerometer instance at the click
        var accelerometerIndex = sensorArrayAccelerometer.count
        var gyroIndex = sensorArrayGyro.count
        nextPressedIndex.append(accelerometerIndex)
        nextPressedIndex.append(gyroIndex)
        keyPressIndices.append(nextPressedIndex)
        
        sleep(1)
       
        var allKeysPressedArrayCombinedPage = Array<Array<Array<Array<Double>>>>() //Main array with all perpage includes Next
    
        
        for indexPair in keyPressIndices{
            //Aray for each key with both Accelerometer[0] and Gyro[1] arrays with instances
            var keyPressedArrayCombined = Array<Array<Array<Double>>>()
            
            var keyPressedArrayAccelerometer = Array<Array<Double>>()
            var keyPressedArrayGyro = Array<Array<Double>>()
            
            for var a_index = indexPair[0]-10; a_index < indexPair[0]+10; ++a_index {
                keyPressedArrayAccelerometer.append(sensorArrayAccelerometer[a_index])
            }
            keyPressedArrayCombined.append(keyPressedArrayAccelerometer)
            
            for var g_index = indexPair[1]-10; g_index < indexPair[1]+10; ++g_index {
                keyPressedArrayGyro.append(sensorArrayGyro[g_index])
            }
            keyPressedArrayCombined.append(keyPressedArrayGyro)
            
            allKeysPressedArrayCombinedPage.append(keyPressedArrayCombined)
        }
        
        //CLEAR the sensor arrays
        sensorArrayAccelerometer = Array<Array<Double>>()
        sensorArrayGyro = Array<Array<Double>>()
        
        
        ///////
        
        
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