class ImageTexter

  def init(image)
    @image = image
    set_font_size(72.0)
    self
  end

  def add_message(text)
    set_font_size(72.0)
    text = breaktext(text)
    @image.lockFocus
    text.drawAtPoint(NSPoint.new(0, 0), withAttributes:@attributes)
    @image.unlockFocus
  end

  def add_title(text)
    set_font_size(36.0)
    text = breaktext(text)
    size = text.sizeWithAttributes(@attributes)
    p = NSPoint.new(@image.size.width - size.width - 5, @image.size.height - size.height - 5)
    @image.lockFocus
    text.drawAtPoint(p, withAttributes:@attributes)
    @image.unlockFocus
  end

  private

  def breaktext(text, max_width = @image.size.width, max_height = @image.size.height)
    words = text.split
    lines = [words[0]]
    words[1..-1].each do |word|
      spaced_word = " #{word}"
      w1 = lines.last.sizeWithAttributes(@attributes).width
      w2 = spaced_word.sizeWithAttributes(@attributes).width
      if w1 + w2 > max_width
        lines << word
      else
        lines[lines.size-1] += spaced_word
      end
    end
    new_text = lines.join("\n")
    if new_text.sizeWithAttributes(@attributes).height > max_height
      set_font_size(@font_size * 0.8)
      return breaktext(text)
    end
    return new_text
  end

  def set_font_size(font_size)
    @font_size = font_size
    paragraph = NSMutableParagraphStyle.alloc.init
    paragraph.setMaximumLineHeight(@font_size)
    @attributes = {
      NSFontAttributeName => NSFont.fontWithName('Impact', size:@font_size),
      NSForegroundColorAttributeName => NSColor.whiteColor,
      NSStrokeColorAttributeName => NSColor.blackColor,
      NSStrokeWidthAttributeName => NSNumber.numberWithInteger(-4),
      NSParagraphStyleAttributeName => paragraph
    }
  end

end