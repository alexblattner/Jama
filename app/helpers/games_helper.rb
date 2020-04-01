module GamesHelper

    def gravatar_for(game, options = { size: 80 })
    size         = options[:size]
    gravatar_id  = Digest::MD5::hexdigest(game.name.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: game.name, class: "gravatar")
    end
end
