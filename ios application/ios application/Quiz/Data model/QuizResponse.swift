//
//  QuizResponse.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//

import Foundation

struct QuizResponse: Codable {
    let results: [Question]
}


struct Question: Codable {
    let question : String
    let correct_answer : String
    let incorrect_answers : [String]  //These is series of answers it has more than one that is why covered in square brackets
}
