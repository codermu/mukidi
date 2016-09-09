//
//  JokeDetailController.swift
//  Mukidi Style
//
//  Created by ibrahim on 9/9/16.
//  Copyright © 2016 Indosytem. All rights reserved.
//

import UIKit

class JokeDetailController: UIViewController {

    @IBOutlet weak var judul: UITextField!
    @IBOutlet weak var konten: UITextView!

    var jokeID : Int?
    
    override func viewDidLoad() {
        if(jokeID != nil){
            let joke = Model.getJokesByID(jokeID!)
            
            judul.text = joke?.title
            konten.text = joke?.content
        }
    }
    
    @IBAction func saveBtn_tap(sender: AnyObject) {
        
        if(jokeID != nil){
            Model.updateJokes(jokeID!, jokeTitle: judul.text!, jokeContent: konten.text)
        }else{
            Model.addJokes(judul.text!, jokeContent: konten.text)
        }
        
    }
    
    
}
