//
//  ViewController.swift
//  Mukidi Style
//
//  Created by ibrahim on 9/9/16.
//  Copyright © 2016 Indosytem. All rights reserved.
//

import UIKit

var data = [Joke]()

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        data = Model.getJokes()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        data = Model.getJokes()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "jokeDetail"){
            let destinationViewController = segue.destinationViewController as! JokeDetailController
            
            let cell = sender as! CustomCell
                
            
            destinationViewController.jokeID = cell.jokeID
            
        }
    }


}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomCell
        
        cell.judul.text = data[indexPath.row].title
        cell.jokeID = data[indexPath.row].id
        cell.photo.image = getImage(indexPath.row)
        
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.clearColor()
        }else{
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        }
    
        return cell
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete){
            
            tableView.beginUpdates()
            Model.deleteJokes(data[indexPath.row].id)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            data = Model.getJokes()
            tableView.endUpdates()
            
            
        }
    }
    
}

func getImage(index:Int)->UIImage{
    switch index%5 {
    case 1:
        return UIImage(named: "mukidi-1")!
    case 2:
        return UIImage(named: "mukidi-2")!
    case 3:
        return UIImage(named: "mukidi-3")!
    case 4:
        return UIImage(named: "mukidi-4")!
    default:
        return UIImage(named: "mukidi-5")!
    }
}


