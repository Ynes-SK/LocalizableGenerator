//
//  Generator.swift
//  LocalizableGenerator
//
//  Created by Ines SK on 26/2/2024.
//

import Foundation
import CoreXLSX
class Generator {
    
    static let shared = Generator()
    /// read xlsx file and parse content
    /// - Parameter filepath: filepath
    func readXLSX(filepath: String){
                guard let file = XLSXFile(filepath: filepath) else {
                  fatalError("XLSX file at \(filepath) is corrupted or does not exist")
                }
                if let parse = try? file.parseWorkbooks() {
                    for wbk in parse {
                        // choose witch worksheet: file.parseWorksheetPathsAndNames(workbook: wbk)[i]
                        //the xlsx file can contain more than one sheet
                        if let fileparse = try? file.parseWorksheetPathsAndNames(workbook: wbk)[1] {
                                if let worksheet = try? file.parseWorksheet(at: fileparse.path){
                                    for row in worksheet.data?.rows ?? [] {
                                        for _ in row.cells {
                                            if let sharedStrings = try? file.parseSharedStrings() {
                                                //column A represent keys
                                              let keysStrings = worksheet.cells(atColumns: [ColumnReference("A")!])
                                                .compactMap { $0.stringValue(sharedStrings) }
                                                //column B represent values
                                                let columnStrings = worksheet.cells(atColumns: [ColumnReference("B")!])
                                                  .compactMap { $0.stringValue(sharedStrings) }
                                                var mergedArray = zip(keysStrings, columnStrings).map { "\"\($0)\" = \"\($1)\";\n" }
                                                //Drop the first row that contain (key, value EN, Value FR)
                                                writeStringsToFile(strings: Array(mergedArray.dropFirst()), filename: "Localizable.strings")
                                            }
                                        }
                                    }
                                }
                            
                        }
                      
                    }
                }
    }
    /// writeStringsToFile document
    /// - Parameters:
    ///   - strings: strings array
    ///   - filename: file name
    func writeStringsToFile(strings: [String], filename: String) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(filename)
            let combinedString = strings.joined(separator: "\n")
            
            do {
                try combinedString.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Localizable file successfully written to file: \(fileURL)")
            } catch {
                print("Error writing Localizable file to file: \(error)")
            }
        }
    }
}
