//
//  SelectDocumentView.swift
//  IOSMyloqlogin
//

import SwiftUI
import PhotosUI
import UIKit
import UniformTypeIdentifiers

struct SelectDocumentView: View {
    @Environment(\.dismiss) private var dismiss
    var initialFileName: String? = nil
    var initialImage: UIImage? = nil
    var onDocumentUploaded: ((String, UIImage?) -> Void)? = nil
    
    @State private var uploadedFileName: String? = nil
    @State private var uploadedImage: UIImage? = nil
    @State private var showDocumentPicker: Bool = false
    @State private var showPhotoPicker: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showCameraUnavailableAlert: Bool = false
    @State private var showEditSheet: Bool = false
    @State private var pendingSource: UploadSource? = nil
    
    enum UploadSource {
        case camera
        case gallery
        case document
    }
    
    init(
        initialFileName: String? = nil,
        initialImage: UIImage? = nil,
        onDocumentUploaded: ((String, UIImage?) -> Void)? = nil
    ) {
        self.initialFileName = initialFileName
        self.initialImage = initialImage
        self.onDocumentUploaded = onDocumentUploaded
        
        // Only initialize with valid file, ignoring any old placeholder
        if let initial = initialFileName, !initial.isEmpty, initial != "fdkjhdkjshk.pdf" {
            self._uploadedFileName = State(initialValue: initial)
            self._uploadedImage = State(initialValue: initialImage)
            self._showEditSheet = State(initialValue: false)
        } else {
            self._uploadedFileName = State(initialValue: nil)
            self._uploadedImage = State(initialValue: nil)
            self._showEditSheet = State(initialValue: false)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Purple Header Bar with Back Button
            headerBar
            
            if let fileName = uploadedFileName {
                // Uploaded document review screen (showing the actual selected file name & image preview)
                uploadedDocumentView(fileName: fileName)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                // Initial upload options screen (tray symbol + 3 source cards)
                initialUploadView
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .background(Color.white)
        // Edit Source Bottom Sheet (Presents Camera, Gallery & Document in bottom sheet presentation)
        .sheet(isPresented: $showEditSheet, onDismiss: {
            guard let source = pendingSource else { return }
            pendingSource = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                switch source {
                case .camera:
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        showCameraPicker = true
                    } else {
                        showCameraUnavailableAlert = true
                    }
                case .gallery:
                    showPhotoPicker = true
                case .document:
                    showDocumentPicker = true
                }
            }
        }) {
            editSourceSheetView
                .presentationDetents([.height(220)])
                .presentationDragIndicator(.visible)
        }
        // Native Document Picker (Files, iCloud Drive, Downloads, PDFs, Images)
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPickerView { _, fileName, image in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    uploadedFileName = fileName
                    uploadedImage = image
                }
            }
        }
        // Native Photo Gallery Picker
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPickerView { fileName, image in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    uploadedFileName = fileName
                    uploadedImage = image
                }
            }
        }
        // Camera Picker
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPickerView { fileName, image in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    uploadedFileName = fileName
                    uploadedImage = image
                }
            }
            .ignoresSafeArea()
        }
        .alert("Camera Not Available", isPresented: $showCameraUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Camera hardware is not available on this iOS Simulator. Please choose Gallery or Documents to select an image or document.")
        }
    }
    
    // MARK: - Initial Upload View
    
    private var initialUploadView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Center Content: Upload Tray Button & Title / Subtitle
            VStack(spacing: 16) {
                // Upload Tray Icon Button - tapping opens the Document Picker to select a file
                Button(action: {
                    showDocumentPicker = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(hex: "EFF1F5"))
                            .frame(width: 60, height: 60)
                        
                        UploadTraySymbol()
                            .frame(width: 24, height: 26)
                            .foregroundColor(Color(hex: "222222"))
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
                VStack(spacing: 6) {
                    Text("Upload work experience letter")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "1A1A1A"))
                        .multilineTextAlignment(.center)
                    
                    Text("Uploading document will be in pdf, jpg or png")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            Spacer()
            
            // Bottom Section: "Upload it from" & 3 Source Cards
            VStack(spacing: 16) {
                Text("Upload it from")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "1A1A1A"))
                
                HStack(spacing: 12) {
                    // Option 1: Camera
                    uploadSourceCard(
                        title: "Camera",
                        iconName: "camera"
                    ) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showCameraPicker = true
                        } else {
                            showCameraUnavailableAlert = true
                        }
                    }
                    
                    // Option 2: Gallery
                    uploadSourceCard(
                        title: "Gallery",
                        iconName: "photo"
                    ) {
                        showPhotoPicker = true
                    }
                    
                    // Option 3: Documents
                    uploadSourceCard(title: "Documents") {
                        DocumentBoxSymbol()
                    } action: {
                        showDocumentPicker = true
                    }
                }
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 36)
        }
    }
    
    // MARK: - Uploaded Document View (Showing Actual Selected File Name & Image)
    
    private func uploadedDocumentView(fileName: String) -> some View {
        let isPdf = fileName.lowercased().hasSuffix(".pdf")
        let isImage = fileName.lowercased().hasSuffix(".jpg") ||
                      fileName.lowercased().hasSuffix(".jpeg") ||
                      fileName.lowercased().hasSuffix(".png") ||
                      fileName.lowercased().hasSuffix(".heic") ||
                      uploadedImage != nil
        
        let typeSubtitle: String = isPdf ? "PDF Document" : (isImage ? "Image Document" : "Document File")
        
        return VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // 1. Document preview card
                    HStack(spacing: 14) {
                        // Icon based on file type or actual image thumbnail
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(hex: "EFF1F5"))
                                .frame(width: 48, height: 48)
                            
                            if isPdf {
                                AcrobatLogoSymbol()
                                    .frame(width: 24, height: 26)
                            } else if let image = uploadedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 48, height: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                    )
                            } else if isImage {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(MyLooQTheme.primaryPurple)
                            } else {
                                Image(systemName: "doc.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(MyLooQTheme.primaryPurple)
                            }
                        }
                        
                        // File name & type subtitle
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fileName)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(hex: "1A1A1A"))
                                .lineLimit(1)
                            
                            Text(typeSubtitle)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(Color(hex: "8E8E93"))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 10) {
                            // Edit pencil icon button on the card
                            Button(action: {
                                showEditSheet = true
                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(hex: "374151"))
                                    .frame(width: 32, height: 32)
                                    .background(
                                        Circle()
                                            .fill(Color(hex: "F3F4F6"))
                                    )
                            }
                            .buttonStyle(.plain)
                            
                            // Black circular close button to remove document
                            Button(action: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    uploadedFileName = nil
                                    uploadedImage = nil
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color.black)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    )
                    .padding(.horizontal, 18)
                    
                    // 2. Centered Black "Edit" Button
                    Button(action: {
                        showEditSheet = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .bold))
                            Text("Edit")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 172, height: 46)
                        .background(
                            Capsule()
                                .fill(Color.black)
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.top, 16)
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
            }
            
            // 4. Bottom Purple "Submit" Button
            Button(action: {
                onDocumentUploaded?(fileName, uploadedImage)
                dismiss()
            }) {
                Text("Submit")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        Capsule()
                            .fill(MyLooQTheme.primaryPurple)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
    }
    
    // MARK: - Header Bar
    
    private var headerBar: some View {
        HStack {
            // White Back Arrow
            Button(action: {
                if uploadedFileName != nil {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        uploadedFileName = nil
                        uploadedImage = nil
                    }
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Text("Select Document")
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Empty balance frame
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 12)
        .frame(height: 52)
        .background(
            MyLooQTheme.primaryPurple
                .ignoresSafeArea(edges: .top)
        )
    }
    
    // MARK: - Edit Source Bottom Sheet View
    
    private var editSourceSheetView: some View {
        VStack(spacing: 20) {
            Text("Upload it from")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "1A1A1A"))
                .padding(.top, 20)
            
            HStack(spacing: 12) {
                // Option 1: Camera
                uploadSourceCard(
                    title: "Camera",
                    iconName: "camera"
                ) {
                    pendingSource = .camera
                    showEditSheet = false
                }
                
                // Option 2: Gallery
                uploadSourceCard(
                    title: "Gallery",
                    iconName: "photo"
                ) {
                    pendingSource = .gallery
                    showEditSheet = false
                }
                
                // Option 3: Documents
                uploadSourceCard(title: "Documents") {
                    DocumentBoxSymbol()
                } action: {
                    pendingSource = .document
                    showEditSheet = false
                }
            }
            .padding(.horizontal, 18)
            
            Spacer()
        }
        .background(Color.white)
    }
    
    // MARK: - Upload Source Card Builders
    
    private func uploadSourceCard<Icon: View>(title: String, @ViewBuilder icon: () -> Icon, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                icon()
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(MyLooQTheme.primaryPurple)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 102)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: "EDE8F5"))
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private func uploadSourceCard(title: String, iconName: String, action: @escaping () -> Void) -> some View {
        uploadSourceCard(
            title: title,
            icon: {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(MyLooQTheme.primaryPurple)
            },
            action: action
        )
    }
}

// MARK: - Document Picker (PDF & Files)

struct DocumentPickerView: UIViewControllerRepresentable {
    var allowedContentTypes: [UTType] = [.pdf, .image, .data, .content, .item]
    var onDocumentPicked: (URL, String, UIImage?) -> Void
    var onCancel: () -> Void = {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let fileName = url.lastPathComponent
            
            let isImage = fileName.lowercased().hasSuffix(".jpg") ||
                          fileName.lowercased().hasSuffix(".jpeg") ||
                          fileName.lowercased().hasSuffix(".png") ||
                          fileName.lowercased().hasSuffix(".heic")
            
            var pickedImage: UIImage? = nil
            if isImage {
                let accessing = url.startAccessingSecurityScopedResource()
                defer {
                    if accessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                if let data = try? Data(contentsOf: url) {
                    pickedImage = UIImage(data: data)
                }
            }
            
            parent.onDocumentPicked(url, fileName, pickedImage)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onCancel()
        }
    }
}

// MARK: - Photo Gallery Picker

struct PhotoPickerView: UIViewControllerRepresentable {
    var onPhotoPicked: (String, UIImage?) -> Void
    var onCancel: () -> Void = {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerView
        
        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let result = results.first else {
                parent.onCancel()
                return
            }
            
            let provider = result.itemProvider
            let suggested = provider.suggestedName
            
            // Determine file extension
            let ext: String
            if provider.hasItemConformingToTypeIdentifier(UTType.png.identifier) {
                ext = "png"
            } else if provider.hasItemConformingToTypeIdentifier(UTType.heic.identifier) {
                ext = "heic"
            } else {
                ext = "jpg"
            }
            
            let fileName: String
            if let suggested = suggested, !suggested.isEmpty {
                fileName = suggested.contains(".") ? suggested : "\(suggested).\(ext)"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd_HHmmss"
                fileName = "Photo_\(formatter.string(from: Date())).\(ext)"
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    DispatchQueue.main.async {
                        let uiImage = image as? UIImage
                        self?.parent.onPhotoPicked(fileName, uiImage)
                    }
                }
            } else {
                parent.onPhotoPicked(fileName, nil)
            }
        }
    }
}

// MARK: - Upload Tray Symbol

struct UploadTraySymbol: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // Upward Arrow in center
                Path { path in
                    // Vertical line
                    path.move(to: CGPoint(x: w * 0.5, y: h * 0.64))
                    path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.16))
                    
                    // Left arrow wing
                    path.move(to: CGPoint(x: w * 0.32, y: h * 0.34))
                    path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.16))
                    
                    // Right arrow wing
                    path.move(to: CGPoint(x: w * 0.68, y: h * 0.34))
                    path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.16))
                }
                .stroke(Color(hex: "222222"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                
                // Tray underneath
                Path { path in
                    path.move(to: CGPoint(x: w * 0.18, y: h * 0.62))
                    path.addLine(to: CGPoint(x: w * 0.18, y: h * 0.86))
                    path.addLine(to: CGPoint(x: w * 0.82, y: h * 0.86))
                    path.addLine(to: CGPoint(x: w * 0.82, y: h * 0.62))
                }
                .stroke(Color(hex: "222222"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

// MARK: - Document Box Symbol

struct DocumentBoxSymbol: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(MyLooQTheme.primaryPurple, lineWidth: 2)
                .frame(width: 22, height: 26)
            
            VStack(alignment: .leading, spacing: 3.5) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(MyLooQTheme.primaryPurple)
                    .frame(width: 11, height: 2)
                
                RoundedRectangle(cornerRadius: 1)
                    .fill(MyLooQTheme.primaryPurple)
                    .frame(width: 6, height: 2)
            }
            .offset(x: -1)
        }
        .frame(width: 26, height: 26)
    }
}

// MARK: - Acrobat Logo Symbol

struct AcrobatLogoSymbol: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                Path { path in
                    // Left loop curving up to top arch
                    path.move(to: CGPoint(x: w * 0.28, y: h * 0.72))
                    path.addCurve(
                        to: CGPoint(x: w * 0.50, y: h * 0.16),
                        control1: CGPoint(x: w * 0.22, y: h * 0.44),
                        control2: CGPoint(x: w * 0.38, y: h * 0.16)
                    )
                    // Top curve down to right loop
                    path.addCurve(
                        to: CGPoint(x: w * 0.72, y: h * 0.72),
                        control1: CGPoint(x: w * 0.62, y: h * 0.16),
                        control2: CGPoint(x: w * 0.78, y: h * 0.44)
                    )
                    // Right loop curving inward
                    path.addCurve(
                        to: CGPoint(x: w * 0.50, y: h * 0.70),
                        control1: CGPoint(x: w * 0.76, y: h * 0.86),
                        control2: CGPoint(x: w * 0.58, y: h * 0.82)
                    )
                    // Inward curve through center to left loop
                    path.addCurve(
                        to: CGPoint(x: w * 0.28, y: h * 0.72),
                        control1: CGPoint(x: w * 0.42, y: h * 0.82),
                        control2: CGPoint(x: w * 0.24, y: h * 0.86)
                    )
                }
                .stroke(Color.black, style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
                
                // Center inner ribbon bridge
                Path { path in
                    path.move(to: CGPoint(x: w * 0.40, y: h * 0.44))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.60, y: h * 0.44),
                        control: CGPoint(x: w * 0.50, y: h * 0.60)
                    )
                }
                .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

// MARK: - Camera Picker View

struct CameraPickerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    var onImageCaptured: (String, UIImage?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        
        init(_ parent: CameraPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let capturedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            let fileName = "Captured_Doc_\(formatter.string(from: Date())).jpg"
            parent.onImageCaptured(fileName, capturedImage)
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    SelectDocumentView()
}
