class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  process :fix_exif_rotation

  def store_dir
    "uploads/photos/users/#{model.user.id}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def thumbnail(width, height)
    manipulate! do |img|
      img = img.resize_to_fill(width, height)
    end
  end

  version :favicon do
    process thumbnail: [16, 16]
  end

  version :tiny do
    process thumbnail: [40, 40]
  end

  version :avatar do
    process thumbnail: [130, 130]
  end

  version :square do
    process thumbnail: [300, 300]
  end

  version :medium do
    process resize_to_limit: [500, 500]
  end

  version :large do
    process resize_to_limit: [1140, nil]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
     if original_filename
       extension = original_filename.split(".").last
       "photo.#{extension}"
     end
  end

  def rotate(options)
    manipulate! do |img|
      if options.has_key? :rotate
        img.rotate!(options[:rotate].to_i)
      end
      if options.has_key? :flip
        img.flip!
      end
      if options.has_key? :flop
        img.flop!
      end
      img
    end
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient!
      yield(img) if block_given?
      img
    end
  end

end
