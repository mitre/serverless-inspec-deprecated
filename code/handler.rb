require 'json'
require 'inspec'
require 'aws-sdk'

def generate_json_file(service_type)
  filename = 'inspec-' + service_type + '-' + Time.now.strftime("%Y-%m-%d_%H-%M-%S") + '.json'
  file_path = '/tmp/' + filename
  return filename, file_path
end

def inspec_scan(event:, context:)
    { event: JSON.generate(event), context: JSON.generate(context.inspect) }

    # Set filename
    filename,file_path = generate_json_file('aws')
    json_reporter = "json:" + file_path
    
    # Set Runner Options
    opts = {
      "backend" => "aws",
      "reporter" => ["cli",json_reporter]
    }

    # Define InSpec Runner
    client = Inspec::Runner.new(opts)

    # Set InSpec Target
    profiles = event['inspec_profiles']
    if ENV['INSPEC_PROFILE'].nil?
      profiles.each do |profile|
        client.add_target(profile,opts)
      end
    end

    # Trigger InSpec Scan
    client.run

    s3 = Aws::S3::Resource.new(region: 'us-east-1')
    bucket = event['s3_bucket'] or ENV['S3_DATA_BUCKET']
    # Create the object to upload
    obj = s3.bucket(bucket).object(filename)

    # Upload it      
    obj.upload_file(file_path)
end

