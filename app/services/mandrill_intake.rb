class MandrillIntake
  attr_accessor :data
  
  def initialize(data)
    @data = data.with_indifferent_access
  end
  
  def user
    @user ||= User.find_by("LOWER(email) = ?", @data['msg']['from_email'].downcase)
  end
  
  def photo
    @photo ||= Photo.new(photo_data)
  end
  
  def photo_data
    { image:   image, 
      user:    user,
      caption: data['msg']['subject'] }
  end
  
  def image
    ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: attachment['name'], type: attachment['type'])
  end
  
  def attachment
    data["msg"]["attachments"].values[0]
  end
  
  def content
    attachment[:base64] ? Base64.decode64(attachment["content"]) : attachment["content"]
  end
  
  def tempfile
    if !@tempfile
      @tempfile ||= Tempfile.open(["file", ".png"])
      @tempfile.binmode
      @tempfile << content
    end
    @tempfile
  end
end