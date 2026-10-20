Desktop::Window = Data.define(:name, :title, :icon, :src, :frame, :width, :height, :kind) do
  def self.configured
    Rails.application.config_for(:desktop).map { |name, attributes| new(name: name.to_s, **attributes) }
  end

  def initialize(frame: nil, kind: nil, **)
    super
  end

  def id
    "#{name}-window"
  end

  def to_params
    { id:, title:, src:, frame:, width:, height:, kind: }.compact
  end
end
