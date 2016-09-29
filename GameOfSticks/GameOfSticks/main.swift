//
//  part2.swift
//  GameOfSticks
//
//  Created by Jacob Zengerling on 9/26/16.
//  Copyright © 2016 Jacob Zengerling. All rights reserved.
//

import Foundation

//Game class that will create a new game when called
class PickUpSticksGame{
    let minInitialSticks : Int = 10;
    let maxInitialSticks : Int = 100;
    let stickArray1 : [Int] = [1]
    let stickArray2 : [Int] = [1,2]
    let stickArray3 : [Int] = [1,2,3]
    
    var stickAmt: Int?
    var player = 1 //player variable: 1 = player 1; 2 = player 2
    var continueGame = true
    var maxOptions = 3
    var userSelect: Int?
    var cpuSelect: Int
    var validInput = false
    
    //dictionaries to keep track of the AI sticks
    var cpuSticks :[Int : [Int]]
    var cpuSelectedSticks : [Int : Int]
    
    init (){
        validInput = false
        userSelect = nil
        cpuSelect = 0
        maxOptions = 3
        continueGame = true
        player = 1
        stickAmt = nil
        cpuSticks = [1:stickArray1,2:stickArray2]
        cpuSelectedSticks = [1:0,2:0]
        
    }
    
    //start a game
    func startGame(){
        print("Welcome to the game of sticks!")
        getInitialSticks()
        makeCPUChoices()
        validInput = false
        
        //check to see if the game is still going
        while continueGame {
            print("\nThere are \(stickAmt!) sticks on the board")
            
            //check to see whose turn it is
            if player == 1 {
                getUserSticks() //get the number of sticks the user picks
                stickAmt = stickAmt! - userSelect!
                player = 2 //switch playsers
            }else {
                cpuSelect = getCPUSticks() //get the number of sticks the computer picks
                print("CPU picked \(cpuSelect) sticks")
                stickAmt = stickAmt! - cpuSelect
                player = 1 //switch players
            }
            
            //check to see what the maximum number of sticks allowed is based on how many sticks are remaining
            if stickAmt < 2 {
                maxOptions = 1
            }else if stickAmt < 3 {
                maxOptions = 2
            }else {
                maxOptions = 3
            }
            
            if maxOptions == 1 {
                continueGame = false
                break
            }
            
            //reset valid the valid input to false to prepare for the next turn
            validInput = false
            
        }
        displayLoser()
    }
    
    //restart the game
    func restartGame(){
        validInput = false
        userSelect = nil
        cpuSelect = 0
        maxOptions = 3
        continueGame = true
        player = 1
        stickAmt = nil
        cpuSelectedSticks = [1:0,2:0]
        startGame()
    }
    
    //prompt the user to enter the starting number of sticks
    func getInitialSticks(){
        while !validInput{
            print("How many sticks are there on the table initially (10-100)? ")
            stickAmt = Int(readLine(stripNewline: true)!) //set the intial amount to the user input
            if stickAmt != nil{
                if stickAmt >= 10 && stickAmt <= 100 {
                    validInput = true
                }else{
                    print("Please enter a number between 10 and 100")
                }
            }else{
                print("Please enter a number between 10 and 100")
            }
            
        }
    }
    
    //initialize the cpu stick options
    func makeCPUChoices(){
        for i in 3...stickAmt!{
            cpuSticks[i] = stickArray3
        }
    }
    
    //prompt the user to enter the number of sticks the want to pick up
    func getUserSticks(){
        while !validInput {
            print("Player 1: How many sticks do you take (1-\(maxOptions))? ")
            userSelect = Int(readLine(stripNewline: true)!) //get the users input
            
            //if the users input is not an integer then it is invalid
            if userSelect != nil{
                //if the users input is not between 1 and the maximum number of allowed sticks then it is an invalid input
                if userSelect >= 1 && userSelect <= maxOptions {
                    validInput = true
                }else{
                    print("Please enter a number between 1 and \(maxOptions)")
                }
            }else{
                print("Please enter a number between 1 and \(maxOptions)")
            }
        }
        
    }
    
    //get the number of sticks 
    func getCPUSticks() -> Int {
        var cpuStickSelect : Int
        var cpuStickOptions : [Int] = cpuSticks[stickAmt!]!
        let index = arc4random_uniform(UInt32(cpuStickOptions.count))
        
        cpuStickSelect = cpuStickOptions[Int(index)]
        cpuSelectedSticks[stickAmt!] = cpuStickSelect
        
        var valueCount = 0
        var newValue : [Int]
        newValue = cpuStickOptions
        for i in 0...newValue.count - 1{
            if newValue[i] == cpuStickSelect{
                valueCount += 1
            }
        }
        if valueCount != 1{
            newValue.removeAtIndex(Int(index))
            cpuSticks.updateValue(newValue, forKey: stickAmt!)
        }
        
        return cpuStickSelect
    }
    
    //add the winning stick choices back into the main directory
    func addCPUWinningChoices(){
        var newValue : [Int]
        for (key, value) in cpuSelectedSticks {
            newValue = cpuSticks[key]!
            newValue.append(value)
            newValue.append(value)
            cpuSticks.updateValue(newValue, forKey: key)
        }
    }
    
    //display the loser
    func displayLoser(){
        print("\nThere are \(stickAmt!) stick on the board")
        if player == 1{
            print("Player 1, you lose.")
            addCPUWinningChoices()
        }else{
            print("CPU loses.")
        }
    }
    
    
}

var game1 = PickUpSticksGame()
var input : String?
var restart = true

game1.startGame()

while restart{
    print("\nWould you like to play again (Y/N)?")
    input = readLine(stripNewline: true)!//get the users input
    if input! == "Y" || input! == "y" {
        game1.restartGame()
    }else{
        restart = false
    }
    
}
