module IconRenderer
  # output file in public/ => [SVG source in public/, pixel size]
  PNGS = {
    "apple-touch-icon.png" => ["icon.svg", 180],
    "android-chrome-192x192.png" => ["icon.svg", 192],
    "android-chrome-512x512.png" => ["icon.svg", 512],
    "android-chrome-maskable-512x512.png" => ["icon-maskable.svg", 512]
  }.freeze
  ICO_SOURCE = "favicon.svg"
  ICO_SIZES = [16, 32, 48].freeze
  # The icon background (#0A1F44); the icons are opaque, so antialiased edges are flattened onto it.
  BACKGROUND = [10, 31, 68].freeze

  module_function

  def render(source, size)
    svg = Rails.public_path.join(source).read
    scale = size.to_f / Vips::Image.svgload_buffer(svg).width
    image = Vips::Image.svgload_buffer(svg, scale:)
    image = image.flatten(background: BACKGROUND) if image.has_alpha?
    image.pngsave_buffer(compression: 9, strip: true)
  end

  # An ICO holding PNG images (supported everywhere since Windows Vista): a
  # 6-byte header, a 16-byte directory entry per image, then the PNG data.
  def ico(pngs)
    offset = 6 + (16 * pngs.size)
    entries = pngs.map do |size, data|
      entry = [size, size, 0, 0, 1, 32, data.bytesize, offset].pack("CCCCvvVV")
      offset += data.bytesize
      entry
    end
    [0, 1, pngs.size].pack("vvv") + entries.join + pngs.map(&:last).join
  end

  def write(output, data)
    Rails.public_path.join(output).binwrite(data)
    puts "Wrote public/#{output}"
  end
end

namespace :icons do
  desc "Render the favicon and app icon PNGs/ICO in public/ from their SVG sources"
  task generate: :environment do
    require "vips"
    # Active Storage blocks libvips' SVG loader at boot because it's unsafe for
    # user uploads. These are our own checked-in files, so unblock it here.
    Vips.block("VipsForeignLoadSvg", false)

    IconRenderer::PNGS.each do |output, (source, size)|
      IconRenderer.write(output, IconRenderer.render(source, size))
    end

    pngs = IconRenderer::ICO_SIZES.map { |size| [size, IconRenderer.render(IconRenderer::ICO_SOURCE, size)] }
    IconRenderer.write("favicon.ico", IconRenderer.ico(pngs))
  end
end
