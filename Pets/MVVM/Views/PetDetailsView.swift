//
//  PetDetailsView.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import Foundation
import SwiftUI
import WebKit

struct PetDetailsView: View {
    private var pet: Pet
    
    init(withPet pet: Pet) {
        self.pet = pet
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
                .navigationTitle(pet.name)
            
            ScrollView {
                VStack(spacing: .zero) {
                    if !pet.photos.isEmpty {
                        CarouselView(media: pet.media)
                    }
                    
                    VStack(alignment: .leading, spacing: GlobalConstants.Layout.marginOffset / 2) {
                        HeaderSection(name: pet.name, published: pet.formattedPublished)
                        
                        if let description = pet.description {
                            DescriptionSection(description: description)
                        }
                        
                        if let fullAddress = pet.contact.address?.fullAddress {
                            AddressSection(fullAddress: fullAddress,
                                           email: pet.contact.email,
                                           phone: pet.contact.phone,
                                           distance: pet.formattedDistance)
                        }
                        
                        if pet.tags.count > .zero {
                            TagsSection(tags: pet.tags)
                        }
                        
                        DetailsSection(attributes: pet.attributes)
                    }
                    .padding(GlobalConstants.Layout.marginOffset)
                }
            }
        }
    }
}

struct CarouselView: View {
    var media: [Media]
    
    var body: some View {
        TabView {
            ForEach(media, id: \.self) { media in
                MediaView(media: media)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .tabViewStyle(PageTabViewStyle())
    }
}

struct MediaView: View {
    var media: Media
    
    var body: some View {
        if let photo = media.photo {
            AsyncImage(url: photo.fullURL, content: { image in
                image
                    .resizable()
                    .scaledToFill()
            }, placeholder: {
                ProgressView()
            })
        } else if let video = media.video {
            WebView(url: video.url)
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct HeaderSection: View {
    let name: String
    let published: String?
    
    var body: some View {
        HStack(alignment: .top) {
            Text(name)
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
            
            if let published = published {
                Text(published)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color(.systemGray))
            }
        }
    }
}

struct DescriptionSection: View {
    let description: String
    
    var body: some View {
        Text(LocalizableConstants.descriptionLabelTitle)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top, GlobalConstants.Layout.marginOffset / 2)
        Text(description)
            .foregroundStyle(Color(.systemGray))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AddressSection: View {
    let fullAddress: String
    let email: String?
    let phone: String?
    let distance: String?
    
    @State private var isAnimating = false
    
    var body: some View {
        HStack(alignment: .center) {
            Text(LocalizableConstants.contactLabelTitle)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, GlobalConstants.Layout.marginOffset / 2)
            
            Spacer()
            
            if let email = email {
                Button(action: {
                    isAnimating.toggle()
                    
                    if let error = email.sendEmail() {
                        UIApplication.shared.topViewController?.showAlertController(error: error)
                    }
                }, label: {
                    Image(systemName: ImageConstants.SystemName.email)
                        .padding(.leading, GlobalConstants.Layout.marginOffset)
                        .symbolEffect(.bounce, value: isAnimating)
                })
            }
            
            if let phone = phone {
                Button(action: {
                    isAnimating.toggle()
                    
                    if let error = phone.makeCall() {
                        UIApplication.shared.topViewController?.showAlertController(error: error)
                    }
                }, label: {
                    Image(systemName: ImageConstants.SystemName.phone)
                        .padding(.leading, GlobalConstants.Layout.marginOffset)
                        .symbolEffect(.bounce, value: isAnimating)
                })
            }
        }
        
        Text(fullAddress)
            .foregroundStyle(Color(.systemGray))
            .frame(maxWidth: .infinity, alignment: .leading)
        
        if let distance = distance {
            Text(distance)
                .foregroundStyle(Color(.systemGray))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct TagsSection: View {
    let tags: [String]
    
    var body: some View {
        Text(LocalizableConstants.tagsLabelTitle)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top, GlobalConstants.Layout.marginOffset / 2)
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 10)
                        .padding(.vertical, GlobalConstants.Layout.marginOffset / 2)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(GlobalConstants.Layout.cornerRadius)
                }
            }
        }
    }
}

struct DetailsSection: View {
    var attributes: [Attribute]
    
    var body: some View {
        Text(LocalizableConstants.detailsLabelTitle)
            .font(.headline)
            .fontWeight(.semibold)
            .padding(.top, GlobalConstants.Layout.marginOffset / 2)
        LazyVStack {
            ForEach(attributes.indices, id: \.self) { index in
                let attribute = attributes[index]
                
                HStack {
                    Text(attribute.title)
                    
                    Spacer()
                    
                    if let value = attribute.value {
                        Text(value.capitalized)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .italic()
                    }
                }
                .padding(.vertical, GlobalConstants.Layout.marginOffset / 2)
                
                if index < attributes.count - 1 {
                    Divider()
                        .background(Color(.systemGray3))
                }
            }
        }
        .padding(.horizontal, GlobalConstants.Layout.marginOffset)
        .padding(.vertical, GlobalConstants.Layout.marginOffset / 2)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: GlobalConstants.Layout.cornerRadius))
    }
}

struct PetDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        PetDetailsView(withPet: MockConstants.PetMock.pet)
    }
}
