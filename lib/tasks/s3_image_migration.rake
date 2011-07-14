namespace :attachments do
  task :migrate_to_s3 => :environment do
    require 'aws/s3'
    
    # Load credentials
    s3_options = YAML.load_file(File.join(Rails.root, 'config/s3.yml'))[Rails.env].symbolize_keys
    bucket = s3_options[:bucket]
    
    # Establish S3 connection
    s3_options.delete(:bucket)
    AWS::S3::Base.establish_connection!(s3_options)
    
    styles = []
    
    # Collect all the styles, all are uploaded because `rake paperclip:refresh CLASS=Image` is broken for mongoid
    Image.last.image.styles.each do |style|
      styles.push(style[0])
    end
    
    # also the :original "style"
    styles.push(:original)
    
    # Process each attachment
    Image.all.each_with_index do |attachment, n|
      styles.each do |style|
        #path = attachment.image.path(style).sub(/^.*system/,'')
        path = attachment.image.send(:interpolate, "/:attachment/:id/:style.:extension")
        file = attachment.image.to_file(style)
        
        begin
          AWS::S3::S3Object.store(path, file, bucket, :access => :public_read)
          
        rescue AWS::S3::NoSuchBucket => e
          AWS::S3::Bucket.create(bucket)
          retry
        rescue AWS::S3::ResponseError => e
          raise
        end
        
        puts "Saved #{path} to S3 (#{n}/#{Image.count})"
      end
    end
  end
end
