//
//  QuizService.swift
//  ios application
//
//  Created by Student 3 on 2026-06-30.
//

import Foundation

struct QuizService {
    
    func getQuestions() async throws -> [Question] {
        
        let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")! //here exclaimation mark means i'm 100% certain that this is the url there is no other url. Or else you could use else statement to show optional url or else the app could crash.
        
        let (data, _) = try await URLSession.shared.data(from: url) //downloads the data from the fetched URL
        
        
        let response = try JSONDecoder().decode(QuizResponse.self, from: data) //sends the data that had been fetched to decode it.
        
        return response.results
    }
}
