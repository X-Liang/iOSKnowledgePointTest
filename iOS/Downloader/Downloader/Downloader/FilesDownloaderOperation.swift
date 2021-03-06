//
//  FileDownloaderOperation.swift
//  Downloader
//
//  Created by Liang on 2018/3/11.
//  Copyright © 2018年 Liang. All rights reserved.
//

import UIKit

protocol  FilesDownloaderOperationDelegate{
	
}

class FilesDownloaderOperation: Operation {
	var operationDelegate: FilesDownloaderOperationDelegate?
	
	private var session: URLSession!
	private var task: URLSessionDownloadTask?
	private let downloadableModel: Downloadable
	private var _finished: Bool = false {
		willSet {
			willChangeValue(forKey: "isFinished")
		}
		didSet {
			didChangeValue(forKey: "isFinished")
		}
	}
	private var _executing: Bool = false {
		willSet {
			willChangeValue(forKey: "isExecuting")
		}
		didSet {
			didChangeValue(forKey: "isExecuting")
		}
	}
	
	init(downloadableInfo: Downloadable) {
		downloadableModel = downloadableInfo
		// waiting...
		downloadableModel.downloadStatus = .waiting
		super.init()
		session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
	}
	
	override func start() {
		objc_sync_enter(self)
		if isCancelled {
			_finished = true
			return
		}
		
		// create task
		if task == nil {
			if downloadableModel.resumeData != nil {	// had resumeData
				task = session.downloadTask(withResumeData: downloadableModel.resumeData!)
			} else {	// don't have resume data
				task = session.downloadTask(with: downloadableModel.sourceURL)
			}
			_executing = true
		}
		objc_sync_exit(self)
		// executing
		task!.resume()
		downloadableModel.downloadStatus = .running
	}
	
	override func cancel() {
		//
		objc_sync_enter(self)
		if _finished { return }
		// unfinished，can be canceled
		super.cancel()
		downloadableModel.downloadStatus = .canceled
		if let task = task {
			task.cancel()
			if _executing { _executing = false }
			if _finished != true { _finished = true }
		}
		reset()
		objc_sync_exit(self)
	}
	
	func suspend() {
		if downloadableModel.downloadStatus == .running {
			task?.cancel { [weak self] (resumeData) in
				guard let `self` = self else { return }
				self._executing = false
				self.downloadableModel.resumeData = resumeData
				self.downloadableModel.downloadStatus = .suspended
			}
		} else if downloadableModel.downloadStatus == .waiting {	// waiting, Don't have downloded data
			task?.suspend()
			self.downloadableModel.downloadStatus = .suspended
		}
	}
	
	func resume() {
		// resume from have downloaded data, suspending status
		if let resumeData = downloadableModel.resumeData {
			task = session.downloadTask(withResumeData: resumeData)
		}
		
		// resume from don't have downloaded data, suspending status
		task!.resume()
		downloadableModel.downloadStatus = .running
		_executing = true
	}
	
	
}

extension FilesDownloaderOperation {
	override var isReady: Bool {
		return downloadableModel.downloadStatus == .waiting && super.isReady
	}
	
	override var isCancelled: Bool {
		return downloadableModel.downloadStatus == .canceled
	}
	
	override var isFinished: Bool {
		return _finished == true
	}
	
	override var isExecuting: Bool {
		return _executing == true
	}
	
	override var isAsynchronous: Bool {
		return true
	}
}

extension FilesDownloaderOperation {
	private func reset() {
		// 加锁原因: 可能会有两条线程会调用该方法，cancel() 所在线程，URLSessionDidFinished回调调用operationFinished 的线程
		objc_sync_enter(self)
		if task != nil {
			task = nil
		}
		if session != nil {
			session.invalidateAndCancel()
			session = nil
		}
		objc_sync_exit(self)
		
	}
	
	private func operationFinish() {
		if _finished == false { _finished = true }
		if _executing == true { _executing = false}
		reset()
	}
}

extension FilesDownloaderOperation:URLSessionDownloadDelegate {
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		let destinationPath = downloadableModel.saveFilePath
		// move finised file
		do {
			try FileManager.default.moveItem(at: location, to: destinationPath)
			downloadableModel.downloadStatus = .completed
		} catch _{
			downloadableModel.downloadStatus = .failed
		}
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		if error == nil {
			downloadableModel.downloadStatus = .completed
			operationFinish()
		}
		else {
//			let urlError = error as! URLError
//			if urlError.userInfo["NSURLSessionDownloadTaskResumeData"] != nil {
//				downloadableModel.downloadStatus = .suspended
//			}
			operationFinish()
		}
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
		let fileSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
		downloadableModel.totalExceptedFileSize.map { (option) -> Void in
			option(fileSize)
		}
		downloadableModel.trackProgressOption.map { (progressOption) -> Void in
			progressOption(progress)
		}
	}
	
	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		let progress = Float(fileOffset) / Float(expectedTotalBytes)
		let fileSize = ByteCountFormatter.string(fromByteCount: expectedTotalBytes, countStyle: .file)
		downloadableModel.totalExceptedFileSize.map { (option) -> Void in
			option(fileSize)
		}
		downloadableModel.trackProgressOption.map { (progressOption) -> Void in
			progressOption(progress)
		}
	}
}
