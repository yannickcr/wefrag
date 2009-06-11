require 'digest/sha1'
class Image < ActiveRecord::Base
  has_many :users
  has_attachment :storage      => :file_system,
                 :path_prefix  => 'public/medias/images',
                 :processor    => :Rmagick,
                 :max_size     => 256.kilobytes,
                 :content_type => :image,
                 :thumbnails   => { :medium => '320x240' }

  validates_attachment :content_type => 'Le fichier que vous avez envoyée n\'est pas une image supportée.',
                       :size         => 'L\'image que vous avez envoyée dépasse la limite de 256 ko.'


  attr_accessible :uploaded_data

  def uploaded_data=(file_data)
    return nil unless super(file_data)
    self.filename = Digest::SHA1.hexdigest("--!rd4d0b--#{Time.now.to_i}--#{file_data.original_filename}--") + file_data.original_filename.match(/\.\w+$/)[0]
  end
end
