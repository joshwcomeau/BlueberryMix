class MixesController < ApplicationController
  before_action :get_bucket

  def index
    @mixes = AWS::S3::Bucket.find(@bucket).objects

  end

  def new

  end

  def show
    filename = params[:id] + ".mp3"
    @mix = AWS::S3::S3Object.find(filename, @bucket)
  end

  def create
    filename = sanitize_filename(params[:mix].original_filename)
    begin 
      AWS::S3::S3Object.store(filename, params[:mix].read, @bucket, :access => :public_read)
      redirect_to root_path
    rescue
      render :new, alert: "Upload failed"
    end


  end

  def destroy
    if params[:id]
      filename = params[:id] + "." + params[:format]
      begin
        AWS::S3::S3Object.find(filename, @bucket).delete
        redirect_to root_path, notice: "File deleted!"
      rescue
        render :index, alert: 'Song could not be deleted'
      end
    else
      redirect_to root_path, alert: 'Song not found.'
    end
  end

  private

  def get_bucket
    @bucket = ENV["S3_BUCKET"]
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
