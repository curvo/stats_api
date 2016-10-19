Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/top_urls', to: 'reports#top_urls'
  get '/top_referrers', to: 'reports#top_referrers'

end
