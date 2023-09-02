//
//  12.StrongSelfView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 02/09/23.
//

import SwiftUI

final class StrongSelfDataService {
    func getData() async -> String {
        return "Updated Data!"
    }
}

final class StrongSelfViewModel: ObservableObject {
    @Published var data: String = "Some Title!"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach { $0.cancel() }
        myTasks = []
    }
    
    // This implies a strong reference...
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // Same - This implies a strong reference...
    func updateData2() {
        Task {
            self.data = await self.dataService.getData()
        }
    }
    
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong
    // We can manage the Task by cancelling it.
    func updateData5() {
        someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    
    func updateData6() {
        let task1 = Task {
            self.data = await self.dataService.getData()
        }
        myTasks.append(task1)
        
        let task2 = Task {
            self.data = await self.dataService.getData()
        }
        
        myTasks.append(task2)
    }
}

struct StrongSelfView: View {
    @StateObject private var viewModel = StrongSelfViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
    }
}

struct StrongSelfView_Previews: PreviewProvider {
    static var previews: some View {
        StrongSelfView()
    }
}
