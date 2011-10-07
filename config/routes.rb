TwitterStalker::Application.routes.draw do
  root :to=> 'stalk#index' 
  get '/top' ,:controller=>'stalk',:action=>'top'
end

