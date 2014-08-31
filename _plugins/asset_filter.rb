module Jekyll
  module AssetFilter
    def asset_url(input)
      "http://data.brooksgarrett.com/#{input}?#{Time.now.to_i}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
