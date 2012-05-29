framework 'cocoa'
framework 'qtkit'

class Snappy

  def snap
    @device = QTCaptureDevice.defaultInputDeviceWithMediaType(QTMediaTypeVideo)
    unless @device
      $stderr.puts 'No device found.'
      return
    end
    if @device.isInUseByAnotherApplication
      $stderr.puts 'Device is in use by another application.'
      return
    end
    if (open_camera)
      until @captured_frame
        NSRunLoop.currentRunLoop.runUntilDate(NSDate.dateWithTimeIntervalSinceNow(0.01))
      end
      close_camera
      image = frame_to_image (@captured_frame)
      save_image (image, "/Users/pioz/Desktop/snap.jpg")
    end
  end

  def self.devices_list
    hash = {}
    devices = QTCaptureDevice.inputDevicesWithMediaType(QTMediaTypeVideo)
    devices.each_with_index do |device, i|
      hash[i+1] = device.localizedDisplayName
    end
    hash
  end

  def self.print_devices_list
    devices_list.each do |k, v|
      puts "#{k}. #{v}"
    end
  end

  private

  def open_camera
    error = Pointer.new(:object)
    @session = QTCaptureSession.alloc.init
    unless @device.open(error)
      $stderr.puts "Can't open device: #{error[0].description}"
      return false
    end
    input = QTCaptureDeviceInput.alloc.initWithDevice(@device)
    unless @session.addInput(input, error:error)
      $stderr.puts "Can't add input: #{error[0].description}" if (!success)
      return false
    end
    output = QTCaptureDecompressedVideoOutput.alloc.init
    output.setDelegate(self)
    unless @session.addOutput(output, error:error)
      $stderr.puts "Can't add output: #{error[0].description}" if (!success)
      return false
    end
    @session.startRunning
    return true
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