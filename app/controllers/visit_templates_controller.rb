class VisitTemplatesController < ApplicationController
  before_action :set_visit_template, only: %i[ show edit update destroy add_units ]

  # GET /visit_templates or /visit_templates.json
  def index
    @visit_templates = VisitTemplate.all
  end

  # GET /visit_templates/1 or /visit_templates/1.json
  def show
  end

  # GET /visit_templates/new
  def new
    @terminologies = Terminology.all
    @fee_schedules = FeeSchedule.all
    @visit_template = VisitTemplate.new
  end

  # GET /visit_templates/1/edit
  def edit
    @terminologies = Terminology.all
    @fee_schedules = FeeSchedule.all
  end

  # POST /visit_templates or /visit_templates.json
  def create
    @visit_template = VisitTemplate.new(visit_template_params)
    respond_to do |format|
      if @visit_template.save
        params[:terminologies].each do |tt|
          TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: tt.to_i).first_or_create
        end
        format.html { redirect_to visit_template_url(@visit_template), notice: "Visit template was successfully created." }
        format.json { render :show, status: :created, location: @visit_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @visit_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visit_templates/1 or /visit_templates/1.json
  def update
    respond_to do |format|
      if @visit_template.update(visit_template_params)

        unless params[:terminologies].nil?
          # TemplateTerminology.where(visit_template_id: @visit_template.id).destroy_all
          params[:terminologies].each do |tt|
            unless TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: tt.to_i).exists?
              TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: tt.to_i).first_or_create
            end
          end
        end

        if params[:visit_template][:template_terminologies_attributes].present?
          format.html { redirect_to visit_template_url(@visit_template), notice: "Visit template was successfully updated." }
        else
          format.html { redirect_to visit_template_add_units_path(id: @visit_template.id, visit_template_id: @visit_template.id), notice: "Visit template was successfully updated." }
        end

        format.json { render :show, status: :ok, location: @visit_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @visit_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visit_templates/1 or /visit_templates/1.json
  def destroy
    @visit_template.destroy

    respond_to do |format|
      format.html { redirect_to visit_templates_url, notice: "Visit template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_units
    # debugger
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit_template
      @visit_template = VisitTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def visit_template_params
      params.require(:visit_template).permit(:name, :fee_schedule_id, template_terminologies_attributes: [:terminology_id, :units, :id])
    end
end
