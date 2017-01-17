# frozen_string_literal: true
module Page
  class Posts
    def initialize(posts:)
      @posts = posts
    end

    def sorted_posts
      posts.sort_by { |d| d.date }.reverse
    end

    def format_date(date)
      date.strftime("%B %-d, %Y")
    end

    private

    attr_reader :posts
  end
end
