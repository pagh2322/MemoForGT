//
//  JSONLoader.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import Foundation

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func save(data: [Memo]) {
    let jsonEncoder = JSONEncoder()
    
    
    guard let file = Bundle.main.url(forResource: "memoData.json", withExtension: nil)
    else {
        fatalError("Couldn't find memoData.json in main bundle.")
    }
    
    do {
        let encodedData = try jsonEncoder.encode(data)
        
        do {
            try encodedData.write(to: file.standardizedFileURL)
        }
        catch let error as NSError {
            print(error)
        }
        
        
    } catch {
        print(error)
    }
    
}
