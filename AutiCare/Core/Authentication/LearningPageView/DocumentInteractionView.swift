//
//  DocumentInteractionView.swift
//  Auticare
//
//  Created by sourav_singh on 21/03/25.
//

import SwiftUI
import UIKit

struct DocumentInteractionView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> DocumentInteractionViewController {
        let viewController = DocumentInteractionViewController()
        viewController.documentInteractionController = UIDocumentInteractionController(url: url)
        return viewController
    }

    func updateUIViewController(_ uiViewController: DocumentInteractionViewController, context: Context) {
        // No updates needed
    }
}

class DocumentInteractionViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    var documentInteractionController: UIDocumentInteractionController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let documentInteractionController = documentInteractionController {
            documentInteractionController.delegate = self
            documentInteractionController.presentPreview(animated: true)
        }
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
