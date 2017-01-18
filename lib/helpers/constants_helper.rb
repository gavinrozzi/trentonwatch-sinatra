module ConstantsHelper
  def content_dir
    settings.content_dir
  end

  def events_dir
    "#{content_dir}/events"
  end

  def info_dir
    "#{content_dir}/info"
  end

  def posts_dir
    "#{content_dir}/posts"
  end

  def events_pattern
    "#{events_dir}/#{date_glob}-*.md"
  end

  def event_pattern(slug)
    "#{events_dir}/#{date_glob}-#{slug}.md"
  end

  def info_pattern(slug)
    "#{info_dir}/#{slug}.md"
  end

  def posts_pattern
    "#{posts_dir}/#{date_glob}-*.md"
  end

  def post_pattern(slug)
    "#{posts_dir}/#{date_glob}-#{slug}.md"
  end

  private

  def date_glob
    '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
  end
end

helpers ConstantsHelper
