//
//  Untitled.swift
//  List
//
//  Created by Irakli Chachava on 05.12.2024.
//

import SwiftUI
import SwiftData

struct RefactorCell: View {
    @ObservedObject var photo: PhotoResponseModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) var editMode
    @State private var isEditing = false


    init(photo: PhotoResponseModel) {
        self.photo = photo
    }
    
    var body: some View {
        Form {
            Section(header: Text("detail")) {
                if editMode?.wrappedValue == .active {
                    TextField("todo", text: $photo.title)
                        .font(.title)
                        .onChange(of: photo.title) { newValue in
                            isEditing = true
                        }
                        .onSubmit {
                            if isEditing {
                                isEditing = false
                            }
                        }
                } else {
                    Text(photo.title)
                        .font(.title)
                }
            }
        }
        .toolbar {
            EditButton()
        }
    }
}




