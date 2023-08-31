//
//  04.Task.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 31/08/23.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image Returned Successfully")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click Me!") {
                    TaskView()
                }
            }
        }
    }
}

struct TaskView: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
        .onDisappear {
//            self.fetchImageTask?.cancel()
        }
        .onAppear {
//            self.fetchImageTask = Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }
//
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
            
            
            // TASK PRIORITY
            
//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("high: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .medium) {
//                print("medium: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .low) {
//                print("low: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .utility) {
//                print("utility: \(Thread.current) : \(Task.currentPriority)")
//            }
//
//            Task(priority: .background) {
//                print("background: \(Thread.current) : \(Task.currentPriority)")
//            }
            
            
            
            // CHILD Tasks
            Task(priority: .low) {
                print("low: \(Thread.current) : \(Task.currentPriority)")
                
                // Child task inherit priorities from Parent Task
                Task {
                    print("low: \(Thread.current) : \(Task.currentPriority)")
                }
                
                // If you don't want use Task.detached. (NOT Recommended by Apple. See docs of Task.detached)
                Task.detached {
                    print("Detached: \(Thread.current) : \(Task.currentPriority)")
                }
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
