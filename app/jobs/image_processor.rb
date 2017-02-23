class ImageProcessor
  
  @queue = :image_processing
  
  def self.perform(id)
    @photo = Photo.find(id)
    @photo.image.recreate_versions!
  end
  
end
