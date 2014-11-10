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
import Darwin

class ViewController: UIViewController {
    
    @IBOutlet var textWindow: UITextView!
    @IBOutlet var inputfieldvalue: UITextField!
    
    var inputfieldlength: Int = 0
    var characters = [String]()
    var times = [Double]()
    var curr_text = 0
    var curr_question = 0
    let questions = ["Male or female? Type (m/f)", "What is your age?", "Which phone do you use? Type iPhone4, iPhone5, iPhone6, iPhone6p, Android, or Windows", "If you use an Android or Windows, is it bigger/smaller than iPhone6?", "Do you use one or two thumbs? Type (1 or 2)", "Do you usually use autocorrect on your phone? Type (y/n)", "Do you want to be part of our Beta release "]
    let texts = ["the quick brown fox jumped over the lazy dog", "the Queen's argument was, that if Something wasn't done about it in less than no time she'd have everybody executed, all round.", "short loin strip steak porchetta shankle turducken turkey drumstick venison pork loin ham boudin porchetta rump"]
    
    let phones = ["iPhone5", "iPhone4", "Android"]
    
    var answers = [String]()
    
    //NEW Variables
    var sensorArrayAccelerometer = Array<Array<Double>>()
    var sensorArrayGyro = Array<Array<Double>>()
    let gyroRate = 40.0;
    let accRate = 40.0;
    var keyPressIndices = Array<Array<Int>>()
    var allKeysPressedArrayCombinedApp = Array<Array<Array<Array<Double>>>>()
    var sensorCounter = 0;
    var indexAppendCounter = 0;
    
    var isLastDone = false
    
    lazy var motionManager = CMMotionManager()
    
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
                    prev_z_a = z_a
                }
            )
            
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
                    prev_z_g = z_g
                    
            })
            
        }
        
    }
    
    
    @IBAction func getinput2(sender: UITextField) {
        var time = NSDate.timeIntervalSinceReferenceDate()
        
        var inputfieldlength2 = countElements(inputfieldvalue.text)
        var character = ""
        
        if inputfieldlength2<inputfieldlength {
            character = "BACKSPACE"
        }else{
            character = inputfieldvalue.text.substringFromIndex(inputfieldvalue.text.endIndex.predecessor())
        }
        inputfieldlength = inputfieldlength2
        
        if curr_text <= countElements(texts) && curr_question == 0{
            characters.append(character)
            times.append(time)
            
            //BARIS EDITS
            
            var keyPressedIndex = [Int]();
            
            //Function to get the index of the array for gyro and accelerometer instance at the click
            var accelerometerIndex = sensorArrayAccelerometer.count
            var gyroIndex = sensorArrayGyro.count
            
            keyPressedIndex.append(accelerometerIndex)
            keyPressedIndex.append(gyroIndex)
            sensorCounter++;
            keyPressIndices.append(keyPressedIndex)
        }
        
        
    }
    
//    @IBAction func getinput(sender: AnyObject) {
//        var time = NSDate.timeIntervalSinceReferenceDate()
//        
//        var inputfieldlength2 = countElements(inputfieldvalue.text)
//        var character = ""
//        
//        if inputfieldlength2<inputfieldlength {
//            character = "BACKSPACE"
//        }else{
//            character = inputfieldvalue.text.substringFromIndex(inputfieldvalue.text.endIndex.predecessor())
//        }
//        inputfieldlength = inputfieldlength2
//        
//        if curr_text <= countElements(texts) && curr_question == 0{
//            characters.append(character)
//            times.append(time)
//        }
//        
//        
//        //characters.append(character)
//        //times.append(time)
//        //println(characters)
//        //println(times)
//        
//        //BARIS EDITS
//        var keyPressedIndex = [Int]();
//        //Function to get the index of the array for gyro and accelerometer instance at the click
//        var accelerometerIndex = sensorArrayAccelerometer.count
//        var gyroIndex = sensorArrayGyro.count
//        keyPressedIndex.append(accelerometerIndex)
//        keyPressedIndex.append(gyroIndex)
//        keyPressIndices.append(keyPressedIndex)
//    }
    
    @IBAction func click_next(sender: UIButton) {
        var inputfieldlength3 = countElements(inputfieldvalue.text)
        if inputfieldlength3 > 0 && curr_text <= countElements(texts) && !isLastDone{
            if (curr_text == countElements(texts)){
                isLastDone = true
            }
            
            //BARIS EDITS
            println("INDEXING STARTING!!!!!!!!!!!!!!!!!!!!")
            if (!isLastDone){
                //Function to get the index of the array for gyro and accelerometer instance at the click
                var nextPressedIndex = [Int]();
                var accelerometerIndex = sensorArrayAccelerometer.count
                var gyroIndex = sensorArrayGyro.count
                nextPressedIndex.append(accelerometerIndex)
                nextPressedIndex.append(gyroIndex)
                keyPressIndices.append(nextPressedIndex)
                sensorCounter++;
            }


            
            sleep(1)
            
            var allKeysPressedArrayCombinedPage = Array<Array<Array<Array<Double>>>>() //Main array with all perpage includes Next
            
            for indexPair in keyPressIndices{
                //Aray for each key with both Accelerometer[0] and Gyro[1] arrays with instances
                var keyPressedArrayCombined = Array<Array<Array<Double>>>()
                
                var keyPressedArrayAccelerometer = Array<Array<Double>>()
                var keyPressedArrayGyro = Array<Array<Double>>()
                
                var acc_index = indexPair[0]
                var gyro_index = indexPair[1]
                
                if (indexPair[0] < 10){
                    acc_index = 10
                }
                if (indexPair[1] < 10){
                    gyro_index = 10
                }
                for var a_index = acc_index-10; a_index < acc_index+10; ++a_index {
                    keyPressedArrayAccelerometer.append(sensorArrayAccelerometer[a_index])
                }
                keyPressedArrayCombined.append(keyPressedArrayAccelerometer)
                
                for var g_index = gyro_index-10; g_index < gyro_index+10; ++g_index {
                    keyPressedArrayGyro.append(sensorArrayGyro[g_index])
                }
                keyPressedArrayCombined.append(keyPressedArrayGyro)
                
                allKeysPressedArrayCombinedPage.append(keyPressedArrayCombined)
                allKeysPressedArrayCombinedApp.append(keyPressedArrayCombined)
                indexAppendCounter++;
                println("key added")
            }
            
            //CLEAR the sensor arrays
            sensorArrayAccelerometer = Array<Array<Double>>()
            sensorArrayGyro = Array<Array<Double>>()
            keyPressIndices = Array<Array<Int>>()
        
        }
        
        
        
        if inputfieldlength3 > 0 && curr_text < countElements(texts){
            
            
//            //BARIS EDITS
//            
//            var nextPressedIndex = [Int]();
//            //Function to get the index of the array for gyro and accelerometer instance at the click
//            var accelerometerIndex = sensorArrayAccelerometer.count
//            var gyroIndex = sensorArrayGyro.count
//            nextPressedIndex.append(accelerometerIndex)
//            nextPressedIndex.append(gyroIndex)
//            keyPressIndices.append(nextPressedIndex)
//            sensorCounter++;
//            
//            sleep(1)
//            
//            var allKeysPressedArrayCombinedPage = Array<Array<Array<Array<Double>>>>() //Main array with all perpage includes Next
//            
//            for indexPair in keyPressIndices{
//                //Aray for each key with both Accelerometer[0] and Gyro[1] arrays with instances
//                var keyPressedArrayCombined = Array<Array<Array<Double>>>()
//                
//                var keyPressedArrayAccelerometer = Array<Array<Double>>()
//                var keyPressedArrayGyro = Array<Array<Double>>()
//                
//                var acc_index = indexPair[0]
//                var gyro_index = indexPair[1]
//                
//                if (indexPair[0] < 10){
//                    acc_index = 10
//                }
//                if (indexPair[1] < 10){
//                    gyro_index = 10
//                }
//                for var a_index = acc_index-10; a_index < acc_index+10; ++a_index {
//                    keyPressedArrayAccelerometer.append(sensorArrayAccelerometer[a_index])
//                }
//                keyPressedArrayCombined.append(keyPressedArrayAccelerometer)
//                
//                for var g_index = gyro_index-10; g_index < gyro_index+10; ++g_index {
//                    keyPressedArrayGyro.append(sensorArrayGyro[g_index])
//                }
//                keyPressedArrayCombined.append(keyPressedArrayGyro)
//                
//                allKeysPressedArrayCombinedPage.append(keyPressedArrayCombined)
//                allKeysPressedArrayCombinedApp.append(keyPressedArrayCombined)
//                indexAppendCounter++;
//                println("key added")
//            }
//            
//            //CLEAR the sensor arrays
//            sensorArrayAccelerometer = Array<Array<Double>>()
//            sensorArrayGyro = Array<Array<Double>>()
//            keyPressIndices = Array<Array<Int>>()
//            
            
            textWindow.text = texts[curr_text]
            characters.append("NEXT")
            times.append(-1.0)
            curr_text += 1
        }
        else if curr_text >= countElements(texts)
            && curr_question < countElements(questions){
                textWindow.text = questions[curr_question]
                if curr_question >= 1 {
                    answers.append(inputfieldvalue.text)
                }
                
                curr_question += 1
                println("questions place")
        }
        else if curr_text == countElements(texts)
            && curr_question >= countElements(questions){
                
                answers.append(inputfieldvalue.text)
                
                println("ACC KEY COUNT: " + String(allKeysPressedArrayCombinedApp.count))
                println("SensorCounter:\(sensorCounter)")
                println("index appends:\(indexAppendCounter)")
                println("TIMES KEY COUNT: " + String(times.count))
                println("KEY COUNT: " + String(characters.count))
                
                
                
                
                var acc_all_keys_results = "["
                for i1 in 0...allKeysPressedArrayCombinedApp.count - 1{
                    var k = allKeysPressedArrayCombinedApp[i1]
                    var k_accs = k[0]
                    var key_accs = "["
                    for i2 in 0...k_accs.count - 1{
                        var time_point = k_accs[i2]
                        var acc_str_at_point = "["+NSString(format: "%.5f", time_point[0])
                        for i3 in 1...time_point.count - 1{
                            var acc_at_point = time_point[i3]
                            acc_str_at_point += ","+NSString(format: "%.5f", time_point[i3])
                        }
                        acc_str_at_point += "]"
                        key_accs += acc_str_at_point
                        
                    }
                    key_accs += "]"
                    acc_all_keys_results += key_accs
                }
                acc_all_keys_results += "]"
               // println("ALL KEYS RESULTS: " + acc_all_keys_results)
                
                
                var gyro_all_keys_results = "["
                for i1 in 0...allKeysPressedArrayCombinedApp.count - 1{
                    var k = allKeysPressedArrayCombinedApp[i1]
                    var k_gyro = k[1]
                    var key_gyros = "["
                    for i2 in 0...k_gyro.count - 1{
                        var time_point = k_gyro[i2]
                        var gyro_str_at_point = "["+NSString(format: "%.5f", time_point[0])
                        for i3 in 1...time_point.count - 1{
                            var gy_at_point = time_point[i3]
                            gyro_str_at_point += ","+NSString(format: "%.5f", time_point[i3])
                        }
                        gyro_str_at_point += "]"
                        key_gyros += gyro_str_at_point
                        
                    }
                    key_gyros += "]"
                    gyro_all_keys_results += key_gyros
                }
                gyro_all_keys_results += "]"
                //println("ALL GYRO RESULTS: " + gyro_all_keys_results)
                
                // create some JSON data and configure the request
                var keys_pressed = "[[" + NSString(format: "%.5f", times[0]) + ",\"" + characters[0] + "\"]"
                //println("Starting to print elements")
                
                //println("Finished to print elements")
                
                for i in 1...times.count - 1 {
                    keys_pressed += ",[" + NSString(format: "%.5f", times[i]) + ",\"" + characters[i] + "\"]"
                }
                keys_pressed += "]"
                
                var json_str = "{"
                json_str += "\"keys\": " + keys_pressed + ",\n"
                json_str += "\"gender\": \"" + answers[0] + "\","
                json_str += "\"age\": \"" + answers[1] + "\","
                json_str += "\"phone\": \"" + answers[2] + "\","
                json_str += "\"size_if_android\": \"" + answers[3] + "\","
                json_str += "\"num_thumbs\": \"" + answers[4] + "\","
                json_str += "\"autocorrect\": \"" + answers[5] + "\","
                json_str += "\"accelerations\": \"" + acc_all_keys_results + "\","
                json_str += "\"gyros\": \"" + gyro_all_keys_results + "\","
                json_str += "\"email\": \"" + answers[6] + "\"}"
                
                
                println("JSON: " + json_str)
                
                //create the request & response
                var request = NSMutableURLRequest(URL: NSURL(string: "http://fractos.stanford.edu/submit")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
                var response: NSURLResponse?
                var error: NSError?
                
                request.HTTPBody = json_str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                request.HTTPMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                // send the request
                NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                println("REQUEST SENT!!!!!!!!!!!!!!!!!")
                //exit(0)
                
                
                
        }
        
        inputfieldlength = 0
        inputfieldvalue.text = ""
        
    }
    
}
