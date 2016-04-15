require "s3"

class UploadS3
  PATH = '/home/grade'
  BUCKET = 'espn-api-importer'

  def initilize
    @service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key =>ENV['AWS_SECRET_ACCESS_KEY'])
    @bucket = @service.buckets.find(BUCKET)
    @counter = 0
  end

  def upload(file_name)
    local_file_path = File.join(PATH, file_name)
    
    new_object = @bucket.objects.build("grade/#{file_name}")
    new_object.content = open( local_file_path )
    
    if new_object.save
      @counter += 1
      File.delete(local_file_path)
    end

    puts "Success finished: #{@counter} files upload to #{BUCKET} bucket"
  end

  def run!
    Dir::glob(File.join(PATH, '*.xml')).each do |file|
      upload(file)
    end
  end
end
 
up = UploadS3.new
up.run!