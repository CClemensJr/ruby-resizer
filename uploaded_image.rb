require "aws-sdk-s3"
require "mini_magick"

class UploadedImage
  def self.s3_image(bucket_name, object_name)
    s3 = Aws::S3::Resource.new()
    object = s3.bucket(bucket_name).object(object_name)
    tmp_image_name = "/tmp/#{ object_name }"

    object.get(response_target: tmp_image_name)

    UploadedImage.new(tmp_image_name)
  end


  def initialize(tmp_image)
    @tmp_image = tmp_image
  end


  def resize_image(params)
    image = MiniMagick::Image.open(@tmp_file)

    image.resize_image params

    @resized_tmp_image = "/tmp/resized.jpg"

    image.write @resized_tmp_image
  end


  def upload_image(target_bucket, target_object)
    s3 = Aws::S3::Resource.new()

    object = s3.bucket(target_bucket).object(target_object).upload_image(@resized_tmp_image)
  end
end