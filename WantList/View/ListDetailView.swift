//
//  ListDetailView.swift
//  WantList
//
//  Created by 芥川浩平 on 2024/02/11.
//

import SwiftUI
import UIKit

enum ImageType {
    case selectedImage          //ImagePickerで選択した画像
    case handedImage            //ListViewから渡されてきた「自分で選んだ」画像
    case uiImageByShop(UIImage) //ショッピングサイトから渡されてきた商品画像
    case imageUrlByShop(URL)    //ショッピングサイトから渡されてきた商品画像
    case noImage                //画像なし
}

struct ListDetailView: View {
    var listDetail: WantItem
    
    @State private var selectedItemTitle: String = ""
    @State private var selectedItemCaption: String = ""
    @State private var selectedItemPrice: String = ""
    @State private var selectedItemUrl: String?
    @State private var selectedItemImage: UIImage?
    @State private var showingAlert: Bool = false
    @State private var isSafariView: Bool = false

    @EnvironmentObject var items: ItemList
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button {
                showingAlert = true
            } label: {
                switch getImageType() {
                case .selectedImage:
                    if let selectedImage = selectedItemImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 10)
                    }
                case .handedImage:
                    if let image = listDetail.itemImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .padding(.top, 10)
                    }
                case .uiImageByShop(let uiImage):
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.top, 10)
                case .imageUrlByShop(let url):
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                    } placeholder: {
                        ProgressView()
                    }
                case .noImage:
                    Text("No Image")
                        .font(Font.system(size: 24).bold())
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 200)
                        .background(Color(UIColor.lightGray))
                        .padding(.top, 10)
                }
            }
            Form {
                Section(header: Text("タイトル")){
                    TextField("", text: $selectedItemTitle)
                        .onAppear() {
                            self.selectedItemTitle = listDetail.itemTitle ?? ""
                        }
                }
                Section(header: Text("メモ")){
                    TextEditor(text: $selectedItemCaption)
                        .onAppear() {
                            self.selectedItemCaption = listDetail.itemCaption ?? ""
                        }
                }
                Section(header: Text("値段")){
                    TextField("", text: $selectedItemPrice)
                        .keyboardType(.numberPad)
                        .onAppear() {
                            self.selectedItemPrice = listDetail.itemPrice ?? ""
                        }
                }
                Section(header: Text("URL")){
                    HStack {
                        TextField("", text: Binding(
                            get: { self.selectedItemUrl ?? "" },
                            set: { self.selectedItemUrl = $0 }
                        ))
                            .onAppear() {
                                self.selectedItemUrl = listDetail.itemUrl?.absoluteString
                            }
                        Divider()
                        Button {
                            if selectedItemUrl != nil {
                                isSafariView = true
                            }
                        } label: {
                            Image(systemName: "safari.fill")
                        }
                    }
                }
                Button {
                    saveChange()
                } label: {
                    Text("保存")
                }
            }
            .sheet(isPresented: $showingAlert) {

            } content: {
                ImagePicker(image: $selectedItemImage)
            }
        }
        .fullScreenCover(isPresented: $isSafariView) {
            if let safariUrlString = selectedItemUrl,
               let safariUrl = URL(string: safariUrlString) {
                SafariView(url: safariUrl) { configuration in
                    configuration.dismissButtonStyle = .close
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func getImageType() -> ImageType {
        if let _ = selectedItemImage {
            return .selectedImage
        } else if let _ = listDetail.itemImage {
            return .handedImage
        } else if let uiImage = selectedItemImage {
            return .uiImageByShop(uiImage)
        } else if let imageUrl = listDetail.itemImageUrl {
            return .imageUrlByShop(imageUrl)
        } else {
            return .noImage
        }
    }

    private func saveChange() {
        let changedItem = WantItem(id: listDetail.id, itemTitle: selectedItemTitle, itemCaption: selectedItemCaption, itemPrice: selectedItemPrice, itemUrl: URL(string: selectedItemUrl ?? ""), itemImage: selectedItemImage ?? listDetail.itemImage, source: .rakuten)
        let savedItem = items.itemList.map { item in
            var item = item
            if item.id == changedItem.id {
                item = changedItem
            }
            return item
        }
        items.itemList = savedItem
        presentationMode.wrappedValue.dismiss()
    }
}


//#Preview {
//    ListDetailView()
//}
