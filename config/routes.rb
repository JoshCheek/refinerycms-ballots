::Refinery::Application.routes.draw do
  
  resources :ballots, :only => :index do
    resources :votes, :only => [] do
      collection do
        get  :login
        post :proceed
        get  :proceed, :action => :login
      end
    end
  end
  

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :ballots do
      collection do
        post :update_positions
      end
    end
  end
end
