//
//  BookController.swift
//  Reading List
//
//  Created by Sameera Roussi on 4/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class BookController {
    
    init() {
        loadFromPersistentStore()
    }
    
    private(set) var books: [Book] = []
    
    // Save and load book data from persistent store
    private var readingListURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            else {
                return nil
        }
        return documents.appendingPathComponent("ReadingList.plist")
    }
    
    // Add a new book to the book list
    func addbook(bookTitle title: String, whyReading reasonToRead: String, beenRead hasBeenRead: Bool) {
        let newBook = Book(title: title, reasonToRead: reasonToRead, hasBeenRead: hasBeenRead)
        books.append(newBook)
        //Refresh the book list
        saveToPersistentStore()
    }
    
    //Delete a book in the list
    func deleteBook(for book: Book) {
        //Make sure we have a book
        guard let bookAtIndex = books.index(of: book) else { return }
        books.remove(at: bookAtIndex)
        
        //Refresh the book list
        saveToPersistentStore()
    }
    
    //Update the book's has been read status
    func updateHasBeenRead(for book: Book) {
        // Make sure there is a book there
        guard let bookAtIndex = books.index(of: book) else { return }
        
        //Get the book and delete it.  Save the deleted book to a new book instance
        
    }
    
    
    func saveToPersistentStore() {
        // Set up the URL for the save and make sure we are able to access it
        guard let url = readingListURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let booksData = try encoder.encode(books)
            try booksData.write(to: url)
        } catch {
            print("Error saving book list: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        // Point to the FileManager and make sure the file is there
        let fileManager = FileManager.default
        guard let url = readingListURL, fileManager.fileExists(atPath: url.path) else {
            print("Load failed to find file")
            return
        }
        //Decode then get the data
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedBooks: [Book] = try decoder.decode([Book].self, from: data)
            books = decodedBooks
        } catch {
            print("Error loading data from disk: \(error)")
        }
    }

    
}
