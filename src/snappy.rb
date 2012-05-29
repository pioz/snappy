framework 'cocoa'
framework 'qtkit'

class Snappy

  def snap
    @device = QTCaptureDevice.defaultInputDeviceWithMediaType(QTMediaTypeVideo)
    open_camera
    until @captured_frame
      NSRunLoop.currentRunLoop.runUntilDate(NSDate.dateWithTimeIntervalSinceNow(0.01))
    end
    close_camera
    image = frame_to_image (@captured_frame)
    save_image (image, "/Users/pioz/Desktop/snap.jpg")
  end

  private

  def open_camera
    @session = QTCaptureSession.alloc.init
    success = @device.open(nil)
    puts 'Error' if (!success)
    input = QTCaptureDeviceInput.alloc.initWithDevice(@device)
    success = @session.addInput(input, error:nil)
    puts 'Error' if (!success)
    output = QTCaptureDecompressedVideoOutput.alloc.init
    output.setDelegate(self)
    success = @session.addOutput(output, error:nil)
    puts 'Error' if (!success)
    @session.startRunning
  end

  def close_camera
    @session.stopRunning
    @device.close
  end

  def frame_to_image(frame)
    imageRep = NSCIImageRep.imageRepWithCIImage(CIImage.imageWithCVImageBuffer(frame))
    image = NSImage.alloc.initWithSize(imageRep.size).addRepresentation(imageRep)
    return image
  end

  def save_image(image, filename)
    image.TIFFRepresentation.writeToFile(filename, atomically:false)
  end

  def captureOutput(captureOutput, didOutputVideoFrame:videoFrame, withSampleBuffer:sampleBuffer, fromConnection:connection)
    CVBufferRetain(videoFrame)
    tmp = @captured_frame
    @captured_frame = videoFrame
    CVBufferRelease(tmp)
  end

end