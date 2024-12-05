//
//  ContentView.swift
//  List
//
//  Created by Irakli Chachava on 05.12.2024.
//

import SwiftUI
import SwiftData

struct ListOfPhoto: View {
    @State private var photo: [PhotoResponseModel] = []
    @State private var isLoading = false
    @State private var currentPage = 1
    @State private var hasMorePages = true
    @Environment(\.modelContext) private var modelContext
    
    let itemsPerPage = 200 // Количество элементов на странице

    var body: some View {
        NavigationSplitView {
            List {
                if isLoading {
                    ProgressView()
                } else if photo.isEmpty {
                    Text("Фотографии не найдены")
                } else {
                    ForEach(photo) { photo in
                        NavigationLink {
                            RefactorCell(photo: photo)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(photo.title)
                                    .font(.headline)
                                AsyncImage(url: URL(string: photo.url)) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Фотографии")
            .onAppear {
                Task {
                    await fetchPhotos()
                }
            }
            .task {
                await fetchMorePhotos()
            }
        } detail: {
            Text("Выберите элемент")
        }
    }

    
    func fetchPhotos() async {
            
        await fetchPage(page: currentPage)
        }
    

    func fetchMorePhotos() async {
        if hasMorePages {
            await fetchPage(page: currentPage + 1)
        }
    }
    
    func fetchPage(page: Int) async {
        isLoading = true
        do {
            let url = URL(string: "https://jsonplaceholder.typicode.com/photos?_start=\(itemsPerPage * (page - 1))&_limit=\(itemsPerPage)")!
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedPhotos = try? JSONDecoder().decode([PhotoResponseModel].self, from: data) {
                if decodedPhotos.isEmpty {
                    hasMorePages = false
                } else {
                    photo.append(contentsOf: decodedPhotos)
                    currentPage += 1
                }
            }

            
        } catch {
            print("Ошибка загрузки фотографий: \(error)")
        }
        isLoading = false
    }


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(photo[index])
            }
        }
    }
}

#Preview {
    ListOfPhoto()
}

