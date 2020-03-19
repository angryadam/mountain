class ProvidersController < ApplicationController
  before_action :set_provider, only: [:show, :edit, :update, :destroy]

  # GET /providers
  def index
    @providers = Provider.all
  end

  # GET /providers/1
  def show
  end

  # GET /providers/new
  def new
    @provider = Provider.new
    @provider.loans.build
  end

  # GET /providers/1/edit
  def edit
  end

  # POST /providers
  def create
    @provider = Provider.new(provider_params)
    @provider.user_id = current_user.id
    respond_to do |format|
      if @provider.save
        format.json { render json: { message: "#{@provider.name} was created" } }
      else
        format.json { render json: { message: @provider.errors.full_messages.join(', ') }, status: 400 }
      end
    end
  end

  # PATCH/PUT /providers/1
  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.json { render json: { message: "#{@provider.name} was updated" } }
      else
        format.json { render json: { message: @provider.errors.full_messages.join(', ') }, status: 400 }
      end
    end
  end

  # DELETE /providers/1
  def destroy
    respond_to do |format|
      if @provider.destroy
        format.json { render json: {} }
      else
        format.json { render json: { message: @provider.errors.full_messages.join(', ') }, status: 400 }
      end
    end
  end

  private
    def set_provider
      @provider = Provider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit(:name,
                                       loans_attributes: [:id, :name, :principle, :interest,
                                                          :months_remaining, :payment, :_destroy])
    end
end
