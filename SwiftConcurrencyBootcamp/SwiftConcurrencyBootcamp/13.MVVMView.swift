//
//  13.MVVMView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 02/09/23.
//

import SwiftUI

final class MyManagerClass {
    func getData() async throws -> String {
        return "Some Data!"
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        return "Some Data!"
    }
}

@MainActor
final class MVVMViewModel: ObservableObject {
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @MainActor @Published private(set) var myData: String = "Starting Text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task = Task { @MainActor in
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        
        tasks.append(task)
    }
    
    
}

struct MVVMView: View {
    @StateObject private var viewModel = MVVMViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
        }
        .onDisappear {
            
        }
    }
}

struct MVVMView_Previews: PreviewProvider {
    static var previews: some View {
        MVVMView()
    }
}
