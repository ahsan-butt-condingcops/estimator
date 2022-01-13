class TerminologiesController < ApplicationController
  before_action :set_terminology, only: %i[ show edit update destroy ]

  # GET /terminologies or /terminologies.json
  def index
    @terminologies = Terminology.all
  end

  # GET /terminologies/1 or /terminologies/1.json
  def show
  end

  # GET /terminologies/new
  def new
    @terminology = Terminology.new
  end

  # GET /terminologies/1/edit
  def edit
  end

  # POST /terminologies or /terminologies.json
  def create
    @terminology = Terminology.new(terminology_params)

    respond_to do |format|
      if @terminology.save
        format.html { redirect_to terminology_url(@terminology), notice: "Terminology was successfully created." }
        format.json { render :show, status: :created, location: @terminology }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @terminology.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /terminologies/1 or /terminologies/1.json
  def update
    respond_to do |format|
      if @terminology.update(terminology_params)
        format.html { redirect_to terminology_url(@terminology), notice: "Terminology was successfully updated." }
        format.json { render :show, status: :ok, location: @terminology }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @terminology.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /terminologies/1 or /terminologies/1.json
  def destroy
    @terminology.destroy

    respond_to do |format|
      format.html { redirect_to terminologies_url, notice: "Terminology was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terminology
      @terminology = Terminology.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def terminology_params
      params.require(:terminology).permit(:code, :description, :modifier, :coverage_type, :charge)
    end
end
