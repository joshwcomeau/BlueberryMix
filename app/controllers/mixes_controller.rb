class MixesController < ApplicationController
  before_action :get_bucket
  before_action :get_mix, only: [:show, :destroy]

  # Right now, we're fetching objects direct from S3. We want to tie these objects with our own database,
  # So that we can include attached metadata.

  # Initial strategy: Create a 'Mix' object in postgres, storing the user-specified title as well as the sanitized
  # filename as the 's3_key'. Use that key to store in S3, and do the reverse when fetching.

  def index
    @mixes = Mix.all
  end

  def new

  end

  def show
    @mix_obj = AWS::S3::S3Object.find(@mix.s3_path, @bucket)
  end

  def create
    filename = sanitize_filename(params[:mix].original_filename)
    
    @mix = current_user.mixes.new(
      name:     params[:name],
      s3_path:  filename
    )
    

    begin 
      AWS::S3::S3Object.store(filename, params[:mix].read, @bucket, :access => :public_read) && @mix.save!
      redirect_to root_path
    rescue
      render :new, alert: "Upload failed"
    end


  end

  def destroy
    begin
      AWS::S3::S3Object.find(@mix.s3_path, @bucket).delete && @mix.destroy
      redirect_to root_path, notice: "File deleted!"
    rescue
      render :index, alert: 'Song could not be deleted'
    end
  end

  private

  def get_bucket
    @bucket = ENV["S3_BUCKET"]
  end

  def get_mix
    @mix = Mix.find(params[:id])
  end 

  def sanitize_filename(filename)
    returning filename.strip do |name|
     # NOTE: File.basename doesn't work right with Windows paths on Unix
     # get only the filename, not the whole path
     name.gsub!(/^.*(\\|\/)/, '')

     # Strip out the non-ascii character
     name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end
end
