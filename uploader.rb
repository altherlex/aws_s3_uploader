require "s3"
PATH = '/home/grade'

service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key =>ENV['AWS_SECRET_ACCESS_KEY'])

bucket = service.buckets.find("espn-api-importer")

def upload(file_name)
  new_object = bucket.objects.build("grade/#{file_name}")
  new_object.content = open(File.join(PATH, file_name))
  new_object.save
end

Dir::glob(File.join(PATH, '*.xml')).each do |file|
  upload(file)
end

 