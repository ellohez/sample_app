Rails.application.routes.draw do
  root "static_pages#home"

  get 'static_pages/home'
  get 'static_pages/help'
  # get "/help/process" => "static_pages#process", as: "help_process"

  get 'static_pages/about'
  get 'static_pages/contact'
end