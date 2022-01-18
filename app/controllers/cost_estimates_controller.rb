class CostEstimatesController < ApplicationController
  before_action :set_cost_estimate, only: %i[ show edit update destroy ]

  # GET /cost_estimates or /cost_estimates.json
  def index
    @cost_estimates = CostEstimate.all
  end

  # GET /cost_estimates/1 or /cost_estimates/1.json
  def show
  end

  # GET /cost_estimates/new
  def new
    @visit_templates = VisitTemplate.all
    @fee_schedules = FeeSchedule.all
    @cost_estimate = CostEstimate.new
  end

  # GET /cost_estimates/1/edit
  def edit
  end

  # POST /cost_estimates or /cost_estimates.json
  def create
    @cost_estimate = CostEstimate.new(cost_estimate_params)

    respond_to do |format|
      if @cost_estimate.save
        format.html { redirect_to cost_estimate_url(@cost_estimate), notice: "Cost estimate was successfully created." }
        format.json { render :show, status: :created, location: @cost_estimate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cost_estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cost_estimates/1 or /cost_estimates/1.json
  def update
    respond_to do |format|
      if @cost_estimate.update(cost_estimate_params)
        format.html { redirect_to cost_estimate_url(@cost_estimate), notice: "Cost estimate was successfully updated." }
        format.json { render :show, status: :ok, location: @cost_estimate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cost_estimate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_estimates/1 or /cost_estimates/1.json
  def destroy
    @cost_estimate.destroy

    respond_to do |format|
      format.html { redirect_to cost_estimates_url, notice: "Cost estimate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def populate_terminologies
    @template_terminologies = TemplateTerminology.where(visit_template_id: params[:visit_template_id].to_i)
    @terminologies = Terminology.where(id: @template_terminologies.pluck(:terminology_id))

    @fcs = @terminologies.where(coverage_type: 'Fully Covered Service').first
    @cs = @terminologies.where(coverage_type: 'Covered Service').first
    @ncs = @terminologies.where(coverage_type: 'Non-Covered Service').first
    # debugger
  end

  def populate_charges
    @template_terminologies = TemplateTerminology.where(visit_template_id: params[:visit_template_id].to_i)
    @terminologies = Terminology.where(id: @template_terminologies.pluck(:terminology_id))
    @fee_schedule = FeeSchedule.find(params[:fee_schedule_id].to_i)

    @fcs_charge = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').first.id,
      fee_schedule_id: @fee_schedule.id).first.value
    @cs_charge = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Covered Service').first.id,
      fee_schedule_id: @fee_schedule.id).first.value
    @ncs_charge = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').first.id,
      fee_schedule_id: @fee_schedule.id).first.value
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_estimate
      @cost_estimate = CostEstimate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cost_estimate_params
      params.require(:cost_estimate).permit(:patient_name, :date_of_appointment, :plan_name, :plan_type, :co_pay, :co_ins, :deductable_balance, :out_of_pocket_max_balance, :visit_template_id, :fee_schedule_id)
    end
end
