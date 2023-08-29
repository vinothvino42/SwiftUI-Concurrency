//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 29/08/23.
//

import SwiftUI

// do-catch
// try
// throws

class DoCatchTryThrowsBootcampDataManager {
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text!", nil)
        }
        return (nil, URLError(.badURL))
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        }
        return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "NEW TEXT!"
//        }
        throw URLError(.badServerResponse)
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        }
        throw URLError(.badServerResponse)
    }
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        // Method 1
//        let returnedValue = manager.getTitle()
//        if let newTitle = returnedValue.title {
//            self.text = newTitle
//        } else if let error = returnedValue.error {
//            self.text = error.localizedDescription
//        }
        
        // Method 2
//        let result = manager.getTitle2()
//
//        switch result {
//        case .success(let newTitle):
//            self.text = newTitle
//        case .failure(let error):
//            self.text = error.localizedDescription
//        }
        
        // Method 3
        let newTitle = try? manager.getTitle3()
        if let newTitle = newTitle {
            self.text = newTitle
        }
        
        do {
            let newTitle = try? manager.getTitle3()
            self.text = newTitle ?? "Not Found"
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
