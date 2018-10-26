//
//  Reader.swift
//  bells
//
//  Created by Thomas Varano on 10/26/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation

func read(from urlString: String) -> String? {
    guard let url = URL(string: urlString) else {
        print("Error: \(urlString) doesn't seem to be a valid URL")
        return nil
    }
    do {
        return try String(contentsOf: url, encoding: .utf8)
    } catch let error {
        print("Error: \(error)")
        return nil
    }
    
}
