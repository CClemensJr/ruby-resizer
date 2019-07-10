require 'uploaded_file'

class Resizer
  def self.image_resizer(event:, context:)
    event = event["Records"].first
    bucket = event["s3"]["bucket"]["name"]
    object = event["s3"]["object"]["key"]

    image = s3_image(bucket, object)
    image.resize_image "50x50"
    image.upload_image("resized-images", "resized_" + event["s3"]["object"]["key"])
  end
end
