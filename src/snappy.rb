framework 'cocoa'
framework 'qtkit'

require 'image_texter'

class Snappy

  def init(options = {})
    @device   = Snappy.get_device_by_name(options[:d])
    @device ||= QTCaptureDevice.defaultInputDeviceWithMediaType(QTMediaTypeVideo)
    @wait = options[:w].to_i
    @filename = options[:filename] || 'snapshot.jpg'
    @title = options[:t]
    @message = options[:m]
    self
  end

  def snap
    unless @device
      $stderr.puts 'No device found.'
      return
    end
    if @device.isInUseByAnotherApplication
      $stderr.puts 'Device is in use by another application.'
      return
    end
    sleep @wait
    if (open_camera)
      until @captured_frame
        NSRunLoop.currentRunLoop.runUntilDate(NSDate.dateWithTimeIntervalSinceNow(0.01))
      end
      close_camera
      image = frame_to_image (@captured_frame)
      if @title || @message
        texter = ImageTexter.alloc.init(image)
        texter.add_title(@title) if @title
        texter.add_message(@message) if @message
      end
      save_image (image, @filename)
    end
  end

  def self.devices_list
    QTCaptureDevice.inputDevicesWithMediaType(QTMediaTypeVideo).map(&:localizedDisplayName)
  end

  def self.get_device_by_name(name)
    devices = QTCaptureDevice.inputDevicesWithMediaType(QTMediaTypeVideo)
    devices.each do |device|
      return device if device.localizedDisplayName == name
    end
    return nil
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