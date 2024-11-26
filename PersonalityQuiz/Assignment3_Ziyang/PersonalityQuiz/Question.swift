//
//  Question.swift
//  PersonalityQuiz
//
//  Created by Ziyang Wang on 2024-11-10.
//

import Foundation

struct Question{
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

enum ResponseType{
    case single,multiple,ranged
}

struct Answer{
    var text: String
    var type: AnimalType
}

enum AnimalType: Character{
    case lion = "🦁",cat = "🐱",rabbit = "🐰",turtle = "🐢"
    
    var definition: String{
        switch self{
        case .lion: return "You are incredibly outgoing."
        case .cat: return "Mischevious and playful, cats are known for their affectionate nature."
        case .rabbit: return "You love everything that's soft. Rabbits are known for their love of cuddles and toys."
        case .turtle: return "You are wise beyond your years. Turtles are known for their intelligence and wisdom."
        }
    }
}

