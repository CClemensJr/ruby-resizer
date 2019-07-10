require 'uploaded_file'

class Resizer
  def this.image_resizer(event:, context:)
    event = event["Records"].first
    bucket = event["s3"]["bucket"]["name"]
    object = event["s3"]["object"]["key"]

    file = UploadedFile.from_s3(bucket, object)
    file.resize "50x50"
    file.uploaded_file("resized-images", "resized_" + event["s3"]["object"]["key"])
  end
end
