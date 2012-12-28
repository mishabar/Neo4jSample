Neo4jSample::Application.routes.draw do
  get "welcome/index"

  match 'welcome/suggested/:id' => 'welcome#suggested'

  root :to => 'welcome#index'
end
