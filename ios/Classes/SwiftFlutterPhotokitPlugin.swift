import Flutter
import MobileCoreServices
import Photos
import UIKit

public class SwiftFlutterPhotokitPlugin: NSObject, FlutterPlugin {
  private var _result: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_photokit", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPhotokitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    _result = result
    var args = call.arguments as! Dictionary<String, String>
    let fileUrl = NSURL(fileURLWithPath: args["filePath"]!) as URL

    switch (call.method) {
    case "saveToCameraRoll":
      saveToCameraRoll(fileUrl)
    case "saveToAlbum":
      saveToAlbum(fileUrl, args["albumName"]!)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func saveToCameraRoll(_ fileUrl: URL) {
    PHPhotoLibrary.shared().performChanges({
      let fileType = self.getFileType(fileUrl)
      switch (fileType) {
      case "image":
        _ = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl)
      case "video":
        _ = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)
      default:
        self._result!(FlutterError(code: "invalid_file", message: "File is not an image or video", details: nil))
        return
      }
    }, completionHandler: { (success, error) in
      if (success) {
        self._result!(true);
      } else {
        self._result!(FlutterError(code: "save_asset_error", message: "Could not save the asset", details: nil))
      }
    })
  }

  private func saveToAlbum(_ fileUrl: URL, _ albumName: String) {
    let assetCollection = createAlbum(albumName)
    if (assetCollection == nil) { return }

    PHPhotoLibrary.shared().performChanges({
      var assetRequest: PHAssetChangeRequest
      let fileType = self.getFileType(fileUrl)
      switch (fileType) {
      case "image":
        assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl)!
      case "video":
        assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)!
      default:
        self._result!(FlutterError(code: "invalid_file", message: "File is not an image or video", details: nil))
        return
      }

      let assetPlaceholder = assetRequest.placeholderForCreatedAsset
      let photosAsset = PHAsset.fetchAssets(in: assetCollection!, options: nil)
      let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection!, assets: photosAsset)
      albumChangeRequest!.addAssets([assetPlaceholder!] as NSArray)
    }, completionHandler: { (success, error) in
      if (success) {
        self._result!(true)
      } else {
        self._result!(FlutterError(code: "save_asset_error", message: "Could not save the asset", details: nil))
      }
    })
  }

  private func createAlbum(_ albumName: String, _ retries: Int = 1) -> PHAssetCollection? {
    if (retries == 0) { return nil }

    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title  = %@", albumName);
    let collection : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    
    if let _: AnyObject = collection.firstObject {
//      Album already exists
      return collection.firstObject;
    } else {
//      Album doesn't exist, create it here and then try to get it again
      do {
        try PHPhotoLibrary.shared().performChangesAndWait {
          PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }
        return createAlbum(albumName, retries - 1)
      } catch {
        _result!(FlutterError(code: "create_album_error", message: "Could not create the album", details: nil))
        return nil
      }
    }
  }
  
  private func getFileType(_ fileUrl: URL) -> String {
    let fileExtension = fileUrl.pathExtension
    let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeRetainedValue()

    if (UTTypeConformsTo(uti!, kUTTypeImage)) {
      return "image"
    } else if (UTTypeConformsTo(uti!, kUTTypeVideo) || UTTypeConformsTo(uti!, kUTTypeMovie)) {
      return "video"
    } else {
      return ""
    }
  }
}
