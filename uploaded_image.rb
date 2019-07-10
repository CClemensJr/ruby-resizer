require "aws-sdk-s3"
require "mini_magick"

class UploadedImage
# This method takes a bucket identifier and an object identifier to get an image
  def self.s3_image(bucket_name, object_name)
    s3 = Aws::S3::Resource.new()
    object = s3.bucket(bucket_name).object(object_name)
    tmp_image_name = "/tmp/#{ object_name }"

    object.get(response_target: tmp_image_name)

    UploadedImage.new(tmp_image_name)
  end

# This method creates an instance variable containing the image
  def initialize(tmp_image)
    @tmp_image = tmp_image
  end

# This method takes the image using Minimagick and resizes it
  def resize_image(params)
    image = MiniMagick::Image.open(@tmp_image)

    image.resize_image params

    @resized_tmp_image = "/tmp/resized.jpg"

    image.write @resized_tmp_image
  end

# This method takes the resized image and saves it into a different bucket for resized images
  def upload_image(target_bucket, target_object)
    s3 = Aws::S3::Resource.new()

    object = s3.bucket(target_bucket).object(target_object).upload_image(@resized_tmp_image)
  end
end