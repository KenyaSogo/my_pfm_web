class ScrapeMyPfmJob < ApplicationJob
  queue_as :default

  def perform(*args)
    p 'scrape_my_pfm job kicked!!'
  end
end
