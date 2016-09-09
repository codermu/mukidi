//
//  Model.swift
//  mukidi-gr
//
//  Created by ibrahim on 9/8/16.
//  Copyright © 2016 Indosytem. All rights reserved.
//

import Foundation
import SQLite

struct Joke {
    let id:Int
    let title:String
    let content:String
    
    init(id:Int,title:String,content:String){
        self.id = id
        self.title = title
        self.content = content
    }
}

class Model{
    
    // database initiation
    // check if database exist in App Documents
    // if database not exist copy seeded sqlite database in app bundle to App Documents
    class func dbInit(){
        
        // set storepath variable to app documents
        let  storePath = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!+"/mukidi.sqlite3"
        
        let fileManager : NSFileManager = NSFileManager.defaultManager()
        
        // check if database already exist
        if !fileManager.fileExistsAtPath(storePath as String) {
            
            // set defaultStorePath variable to app bundle
            let defaultStorePath : NSString! = NSBundle.mainBundle().pathForResource("mukidi", ofType: "sqlite3")
            
            // check if sqlite database file exist in app bundle
            if((defaultStorePath) != nil) {
                // copy database file to app documents
                try! fileManager.copyItemAtPath(defaultStorePath as String, toPath: storePath)
            }
        }
    }
    
    class func dbPath()->String{
        
        let dbPath = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!+"/mukidi.sqlite3"
        
        return dbPath
    }
    
    class func getJokes()->[Joke]{
        
        let db = try! Connection(Model.dbPath())
        
        var jokes = [Joke]()
        
        let jokesTbl = Table("jokes")
        let id = Expression<Int>("id")
        let title = Expression<String>("title")
        let content = Expression<String>("content")
        
        for joke in try! db.prepare(jokesTbl){
            jokes.append(Joke(id: joke[id], title: joke[title], content: joke[content]))
        }
        
        return jokes
        
    }
    
    class func getJokesByID(jokeID:Int)->Joke?{
        
        let db = try! Connection(Model.dbPath())
        
        let jokesTbl = Table("jokes")
        let id = Expression<Int>("id")
        let title = Expression<String>("title")
        let content = Expression<String>("content")
        
        let query = jokesTbl.filter(jokesTbl[id] == jokeID)
        
        if let joke = db.pluck(query){
            return Joke(id: joke[id], title: joke[title], content: joke[content])
        }else{
            return nil
        }
        
    }
    
    class func addJokes(jokeTitle:String,jokeContent:String)->Bool{
        
        
        let db = try! Connection(Model.dbPath())
        
        let jokesTbl = Table("jokes")
        let title = Expression<String>("title")
        let content = Expression<String>("content")
        
        do {
            let rowid = try db.run(jokesTbl.insert(title <- jokeTitle, content <- jokeContent))
            print("inserted id: \(rowid)")
            return true
        } catch {
            print("insertion failed: \(error)")
        }
        return false
    }
    
    
    class func updateJokes(jokeID:Int,jokeTitle:String,jokeContent:String)->Bool{
        
        let db = try! Connection(Model.dbPath())
        
        let jokesTbl = Table("jokes")
        let id = Expression<Int>("id")
        let title = Expression<String>("title")
        let content = Expression<String>("content")
        
        let query = jokesTbl.filter(jokesTbl[id] == jokeID)
        
        do {
            if try db.run(query.update(title <- jokeTitle, content <- jokeContent)) > 0 {
                print("joke updated")
                return true
            } else {
                print("id not found")
            }
        } catch {
            print("update failed: \(error)")
        }
        
        return false
    }
    
    class func deleteJokes(jokeID:Int)->Bool{
        
        let db = try! Connection(Model.dbPath())
        
        let jokesTbl = Table("jokes")
        let id = Expression<Int>("id")
        
        let query = jokesTbl.filter(jokesTbl[id] == jokeID)
        
        do {
            if try db.run(query.delete()) > 0 {
                print("joke deleted")
                return true
            } else {
                print("alice not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
        
        return false
    }
    
    
}
