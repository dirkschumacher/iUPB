atom_feed(root_url: ads_url(locale: nil), language: "de") do |feed|
    feed.title("iUPB Kleinanzeigen Feed")
    feed.updated(@ads[0].created_at) if @ads.length > 0

    @ads.each do |post|
      feed.entry(post) do |entry|
        entry.title(post.title)
        entry.content(post.text)

        entry.author do |author|
          author.name(post.name)
        end
      end
    end
end