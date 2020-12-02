class StatusController < ::ApplicationController
  def health
    head :ok
  end
end
