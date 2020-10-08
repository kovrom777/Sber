//
//  Parser.swift
//  SberTestTask
//
//  Created by Роман Ковайкин on 08.10.2020.
//

import Foundation

class ParseFeed: NSObject {
    private var rssItems: [RSSItem] = []
    private var currentElement = ""

    private var title: String = "" {
        didSet {
            title = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var publicationDate: String = "" {
        didSet {
            publicationDate = publicationDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: (([RSSItem]) -> Void)?

    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler

        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }

                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }

        task.resume()
    }
}

extension ParseFeed: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            title = ""
            currentDescription = ""
            publicationDate = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            title += string
        case "description" :
            currentDescription += string
        case "pubDate" :
            publicationDate += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: title, description: currentDescription, publicationDate: publicationDate)
            self.rssItems.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
