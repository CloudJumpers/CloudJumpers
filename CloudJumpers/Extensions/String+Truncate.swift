//
//  String+Truncate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

extension String {
    func truncate(by maxLength: Int, with trailing: String = "...") -> String {
        var text = self
        if text.count > maxLength {
            let index = text.index(text.startIndex, offsetBy: maxLength)
            let trimmedText = text[..<index].trimmingCharacters(in: .whitespacesAndNewlines)
            text = trimmedText + trailing
        }

        return text
    }
}
