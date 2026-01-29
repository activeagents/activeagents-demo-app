class DashboardController < ApplicationController
  def index
    render inertia: 'Dashboard', props: {
      user: current_user_props
    }
  end

  private

  def current_user_props
    # Placeholder for user data
    { name: 'Developer' }
  end
end
