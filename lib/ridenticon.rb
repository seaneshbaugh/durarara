require "digest/sha1"

module RIdenticon
  class ImageRmagick
    def initialize(width, height)
      require "rmagick"

      @image = Magick::Image.new(width, height)

      @image.format = "png"
    end

    def color(red, green, blue)
      sprintf("#%02x%02x%02x", red, green, blue)
    end

    def transparent(color)
      @image.transparent(color)
    end

    def fill_rect(x1, y1, x2, y2, color)
      dr = Magick::Draw.new

      dr.fill(color)

      dr.rectangle(x1, y1, x2, y2)

      dr.draw(@image)
    end

    def polygon(points, color)
      unless points.empty?
        dr = Magick::Draw.new

        dr.fill(color)

        dr.polygon *(points.flatten)

        dr.draw(@image)
      end
    end

    def write(path)
      @image.write(path)
    end

    def to_blob
      @image.to_blob
    end

    def resize(newsize)
      @image.resize!(newsize, newsize)
    end
  end

  class Identicon
    PATCHES = [
      [0, 4, 24, 20, 0],
      [0, 4, 20, 0],
      [2, 24, 20, 2],
      [0, 2, 22, 20, 0],
      [2, 14, 22, 10, 2],
      [0, 14, 24, 22, 0],
      [2, 24, 22, 13, 11, 22, 20, 2],
      [0, 14, 22, 0],
      [6, 8, 18, 16, 6],
      [4, 20, 10, 12, 2, 4],
      [0, 2, 12, 10, 0],
      [10, 14, 22, 10],
      [20, 12, 24, 20],
      [10, 2, 12, 10],
      [0, 2, 10, 0],
      [],
    ]

    CENTER_PATCHES = [0, 4, 8, 15]

    PATCH_SIZE = 5

    @@image_lib = ImageRmagick

    @@salt = ""

    attr_reader :code

    def initialize(str = "", options = {})
      case options[:type]
        when :code
          @code = str.to_i
        when :ip
          @code = Identicon.ip2code(str)
        else
          puts ":code = nil"
          @code = Identicon.calc_code(str.to_s)
          puts @code
      end

      @decode = decode(@code)

      puts @decode

      if options[:size]
        @scale = (options[:size].to_f / (PATCH_SIZE * 3)).ceil

        @resize_to = options[:size]
      else
        @scale = options[:scale] || 1
      end

      @patch_width = PATCH_SIZE * @scale

      @image = @@image_lib.new(@patch_width * 3, @patch_width * 3)

      @back_color = @image.color(255, 255, 255)

      @fore_color = @image.color(@decode[:red], @decode[:green], @decode[:blue])

      @image.transparent(@back_color)

      render

      if @resize_to
        @image.resize(@resize_to)
      end
    end

    def decode(code)
      {
        :center_type   => (code & 0x3),
        :center_invert => (((code >> 2) & 0x01) != 0),
        :corner_type   => ((code >> 3) & 0x0f),
        :corner_invert => (((code >> 7) & 0x01) != 0),
        :corner_turn   => ((code >> 8) & 0x03),
        :side_type     => ((code >> 10) & 0x0f),
        :side_invert   => (((code >> 14) & 0x01) !=0),
        :side_turn     => ((code >> 15) & 0x03),
        :red           => (((code >> 16) & 0x01f) << 3),
        :green         => (((code >> 21) & 0x01f) << 3),
        :blue          => (((code >> 27) & 0x01f) << 3),
      }
    end

    def render
      center = [[1, 1]]
      side = [[1, 0], [2, 1], [1, 2], [0, 1]]
      corner = [[0, 0], [2, 0], [2, 2], [0, 2]]

      draw_patches(center, CENTER_PATCHES[@decode[:center_type]], 0, @decode[:center_invert])

      draw_patches(side, @decode[:side_type], @decode[:side_turn], @decode[:side_invert])

      draw_patches(corner, @decode[:corner_type], @decode[:corner_turn], @decode[:corner_invert])
    end

    def draw_patches(list, patch, turn, invert)
      list.each do |i|
        draw(:x => i[0], :y => i[1], :patch => patch, :turn => turn, :invert => invert)

        turn += 1
      end
    end

    def draw(options = {})
      x = options[:x] * @patch_width

      y = options[:y] * @patch_width

      patch = options[:patch] % PATCHES.size

      turn = options[:turn] % 4

      if options[:invert]
        fore, back = @back_color, @fore_color
      else
        fore, back = @fore_color, @back_color
      end

      @image.fill_rect(x, y, x + @patch_width - 1, y + @patch_width - 1, back)

      points = []

      PATCHES[patch].each do |point|
        dx = point % PATCH_SIZE

        dy = point / PATCH_SIZE

        length = @patch_width - 1

        px = dx.to_f / (PATCH_SIZE - 1) * length

        py = dy.to_f / (PATCH_SIZE - 1) * length

        case turn
          when 1
            px, py = length - py, px
          when 2
            px, py = length - px, length - py
          when 3
            px, py = py, length - px
        end

        points << [x + px, y + py]
      end

      @image.polygon(points, fore)
    end

    def write(path = "#{@code}.png")
      @image.write(path)
    end

    def to_blob
      @image.to_blob
    end

    def self.calc_code(str)
      puts "str = #{str}"
      extract_code(Identicon.digest(str))
    end

    def self.ip2code(ip)
      code_ip = extract_code(ip.split("."))

      extract_code(Identicon.digest(code_ip.to_s))
    end

    def self.digest(str)
      Digest::SHA1.digest(str + @@salt)
    end

    def self.extract_code(list)
      puts "list: #{list}"
      tmp = [list[0].ord << 24, list[1].ord << 16, list[2].ord << 8, list[3].ord]
      puts "tmp: #{tmp}"

      tmp.inject(0) do |r, i|
        r | ((i[31] == 1) ? -(i & 0x7fffffff) : i)
      end
    end
  end
end
