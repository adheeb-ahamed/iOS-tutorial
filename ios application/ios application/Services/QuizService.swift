//
//  QuizService.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//

import Foundation

struct QuizService {
    
    func getQuestions(settings: QuizSettings) async throws -> [Question] {
        
        var components = URLComponents(string: "https://opentdb.com/api.php?amount=10&type=multiple")! //here exclaimation mark means i'm 100% certain that this is the url there is no other url. Or else you could use else statement to show optional url or else the app could crash.
        
        components.queryItems = [
            URLQueryItem(name: "amount", value: "\(settings.amount)"),
            URLQueryItem(name: "category", value: "\(settings.category.rawValue)"),
            URLQueryItem(name: "difficulty", value: settings.difficulty.rawValue),
            URLQueryItem(name: "type", value: "multiple")
        ]
        
        let url = components.url!
        
        let (data, _) = try await URLSession.shared.data(from: url) //downloads the data from the fetched URL
        
        
        let response = try JSONDecoder().decode(QuizResponse.self, from: data) //sends the data that had been fetched to decode it.
        
        return response.results
    }
}
