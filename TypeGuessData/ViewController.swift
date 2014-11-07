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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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