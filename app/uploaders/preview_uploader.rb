# encoding: utf-8

class PreviewUploader < CarrierWave::Uploader::Base

    include CarrierWave::Meta



  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick #must yum install ImageMagick-devel
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  #process :resize_to_fit => [180, 180]

  #version :thumb do
  #  process :scale => [48, 48]
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  

  version :large do
      process :resize_to_fit => [300, 300]
  end

  version :thumb do
      process :manualcrop
      process :resize_to_fill => [180, 180]
  end

  version :small do
      process :manualcrop
      process :resize_to_fill => [48, 48]
  end

  def manualcrop
      return unless model.cropping?
      manipulate! do |img| 
          img = img.crop(model.crop_x.to_i,model.crop_y.to_i,model.crop_h.to_i,model.crop_w.to_i) 
      end 
  end
end
