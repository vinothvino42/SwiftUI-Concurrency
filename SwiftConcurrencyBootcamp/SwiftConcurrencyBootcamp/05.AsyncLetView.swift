//
//  05.AsyncLetView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 31/08/23.
//

import SwiftUI

struct AsyncLetView: View {
    @State private var images: [UIImage?] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        if image != nil {
                            Image(uiImage: image!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        }
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp")
            .onAppear {
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        // If one is failed, every fetchImage will be failed
//                        let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
                        
                        let (image1, image2, image3, image4) = await (try? fetchImage1, try? fetchImage2, try fetchImage3, try fetchImage4)
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        
                        
//                        let image1 = try await fetchImage()
//                        images.append(image1)
//
//                        let image2 = try await fetchImage()
//                        images.append(image2)
//
//                        let image3 = try await fetchImage()
//                        images.append(image3)
//
//                        let image4 = try await fetchImage()
//                        images.append(image4)
                    } catch {
                        print("Error fetching image")
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

struct AsyncLetView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetView()
    }
}
