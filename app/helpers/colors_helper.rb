module ColorsHelper
  def contrast_color(hex_code)
    # Assuming hex_code is a string like "#ffffff" or "#000000"
    r, g, b = hex_code.delete('#').scan(/../).map(&:hex)
    # Calculate the perceptive luminance
    luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255

    luminance > 0.5 ? 'black' : 'white'
  end
end
