Rails.application.routes.draw do
  # Home action
  get '/', to: 'graphs#index'
  get '/fetch', to: 'graphs#fetch_currencies'
end
