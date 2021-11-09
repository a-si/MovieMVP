// PhotoCacheService.swift
// Copyright © Артём Сыряный. All rights reserved.

import Alamofire
import UIKit

protocol DataReloadable {
    func reloadRow(at indexPath: IndexPath)
}

final class PhotoCacheService {
    // MARK: - Private Constants

    private let container: DataReloadable

    // MARK: - Private Variables

    private var images: [String: UIImage] = [:]
    private lazy var fileManager = FileManager.default

    // MARK: - Initializers

    init(container: UITableView) {
        self.container = Table(table: container)
    }

    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }

    // MARK: - API

    var placeholderImage: UIImage? = UIImage(named: "blackImage")

    func photo(at indexPath: IndexPath, url: String) -> UIImage? {
        if let image = images[url] {
            return image
        } else if let image = getImageFromDisk(url: url) {
            return image
        } else {
            loadImageFromNet(url: url, indexPath: indexPath)
            return placeholderImage
        }
    }

    // MARK: - Private Variables

    private var baseImageURLString = "https://image.tmdb.org/t/p/original"

    // MARK: - Private Methods

    private func getImagePath(url: String) -> String? {
        guard let folderURL = getCacheFolderPath() else { return nil }
        return folderURL.appendingPathComponent(url).path
    }

    private func getCacheFolderPath() -> URL? {
        let fileManager = FileManager.default
        guard let docsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let url = docsDirectory.appendingPathComponent("images", isDirectory: true)
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        return url
    }

    private func getImageFromDisk(url: String) -> UIImage? {
        guard let filePath = getImagePath(url: url),
              let image = UIImage(contentsOfFile: filePath) else { return nil }
        images[url] = image
        return image
    }

    private func saveImageToDisk(url: String, image: UIImage) {
        guard
            let filePath = getImagePath(url: url),
            let data = image.pngData()
        else { return }
        fileManager.createFile(
            atPath: filePath,
            contents: data,
            attributes: nil
        )
    }

    private func loadImageFromNet(url: String, indexPath: IndexPath) {
        let fullImageURLString = baseImageURLString + url
        AF.request(fullImageURLString).responseData { [weak self] response in
            guard let data = response.data,
                  let image = UIImage(data: data)
            else { return }
            self?.images[url] = image
            self?.saveImageToDisk(url: url, image: image)
            self?.container.reloadRow(at: indexPath)
        }
    }
}

// MARK: - Extension PhotoCacheService

extension PhotoCacheService {
    private class Table: DataReloadable {
        let table: UITableView

        init(table: UITableView) {
            self.table = table
        }

        func reloadRow(at indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }

    private class Collection: DataReloadable {
        let collection: UICollectionView

        init(collection: UICollectionView) {
            self.collection = collection
        }

        func reloadRow(at indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}
