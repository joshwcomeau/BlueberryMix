class MixesController < ApplicationController
  def index
    @mixes = AWS::S3::Bucket.find(ENV["S3_BUCKET"]).objects
  end

  def new

  end

  def create

  end

  def destroy

  end
end
