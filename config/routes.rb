::Refinery::Application.routes.draw do
  resources :ballots, :only => :show

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :ballots, :except => :show do
      collection do
        post :update_positions
      end
    end
  end
end
