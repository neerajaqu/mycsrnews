namespace :attachments do
  task :migrate_to_s3 => :environment do
    require 'aws/s3'
    
    # Load credentials
    s3_options = YAML.load_file(File.join(Rails.root, 'config/s3.yml')).symbolize_keys
    bucket = s3_options[:bucket_name]
    
    # Establish S3 connection
    s3_options.delete(:bucket_name)
    AWS::S3::Base.establish_connection!(s3_options)
    
    styles = []
    
    # Collect all the styles, all are uploaded because `rake paperclip:refresh CLASS=Attachment` is broken for mongoid
    Attachment.first.data.styles.each do |style|
      styles.push(style[0])
    end
    
    # also the :original "style"
    styles.push(:original)
    
    # Process each attachment
    Attachment.all.each_with_index do |attachment, n|
      styles.each do |style|
        path = attachment.data.path(style)
        file = attachment.data.to_file(style)
        
        begin
          AWS::S3::S3Object.store(path, file, bucket, :access => :public_read)
          
        rescue AWS::S3::NoSuchBucket => e
          AWS::S3::Bucket.create(bucket)
          retry
        rescue AWS::S3::ResponseError => e
          raise
        end
        
        puts "Saved #{path} to S3 (#{n}/#{Attachment.count})"
      end
    end
  end
end
