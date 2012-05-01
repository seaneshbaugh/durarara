require "digest/sha2"
require "ridenticon"

class Post < ActiveRecord::Base
  attr_accessible :body, :ip_address, :name, :subject

  validates :body,
    :presence => true

  validates :ip_address,
    :presence => true

  validates :name,
    :presence => true

  validates :subject,
    :presence => true

  before_validation :set_name, :sanitize

  def set_name
    self.name = Digest::SHA2.hexdigest(self.ip_address)
  end

  def sanitize
    self.subject = Sanitize.clean(self.subject).strip
    self.body = Sanitize.clean(self.body, :elements => %w[br]).strip
  end

  def identicon
    identicon_path = File.join(Rails.root, "public", "images", "identicon", "#{self.name}.png")

    unless File.exist?(identicon_path)
      image = RIdenticon::Identicon.new(self.name, :size => 100)

      image.write(identicon_path)
    end

    File.join("/", "images", "identicon", "#{self.name}.png")
  end
end
