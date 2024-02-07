# frozen_string_literal: true

module ColorsHelper
  def contrast_color(hex_code)
    r, g, b = hex_code.delete('#').scan(/../).map(&:hex)
    luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    luminance > 0.5 ? 'black' : 'white'
  end
end
