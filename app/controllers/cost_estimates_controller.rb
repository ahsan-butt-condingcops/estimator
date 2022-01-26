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
    @terminologies = Terminology.all
    @terminologies_fcs = Terminology.where(coverage_type: 'Fully Covered Service')
    @terminologies_cs = Terminology.where(coverage_type: 'Covered Service')
    @terminologies_ncs = Terminology.where(coverage_type: 'Non-Covered Service')
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
    unless params[:visit_template_id].blank?
      @next_available_fcs = 1
      @next_available_cs = 1
      @next_available_ncs = 1

      @template_terminologies = TemplateTerminology.where(visit_template_id: params[:visit_template_id].to_i)
      @terminologies = Terminology.where(id: @template_terminologies.pluck(:terminology_id))
      @fee_schedule = VisitTemplate.find(params[:visit_template_id].to_i)

      @fcs1 = @terminologies.where(coverage_type: 'Fully Covered Service').first
      @fcs2 = @terminologies.where(coverage_type: 'Fully Covered Service').second
      @fcs3 = @terminologies.where(coverage_type: 'Fully Covered Service').third

      @cs1 = @terminologies.where(coverage_type: 'Covered Service').first
      @cs2 = @terminologies.where(coverage_type: 'Covered Service').second
      @cs3 = @terminologies.where(coverage_type: 'Covered Service').third

      @ncs1 = @terminologies.where(coverage_type: 'Non-Covered Service').first
      @ncs2 = @terminologies.where(coverage_type: 'Non-Covered Service').second
      @ncs3 = @terminologies.where(coverage_type: 'Non-Covered Service').third

      if @terminologies.where(coverage_type: 'Fully Covered Service').count > 0
        @fcs_charge1 = TerminologyFeeSchedule.where(
          terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').first.id,
          fee_schedule_id: @fee_schedule.id).first.value
        @fcs_units1 = TemplateTerminology.where(
          terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').first.id,
          visit_template_id: params[:visit_template_id].to_i
        ).first.units
        @next_available_fcs = 2

        if (@fcs_charge1 > 0 && @terminologies.where(coverage_type: 'Fully Covered Service').count > 1)
          @fcs_charge2 = TerminologyFeeSchedule.where(
            terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').second.id,
            fee_schedule_id: @fee_schedule.id).first.value
          @fcs_units2 = TemplateTerminology.where(
            terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').second.id,
            visit_template_id: params[:visit_template_id].to_i
          ).first.units
          @next_available_fcs = 3

          if (@fcs_charge2 > 0 && @terminologies.where(coverage_type: 'Fully Covered Service').count > 2)
            @fcs_charge3 = TerminologyFeeSchedule.where(
              terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').third.id,
              fee_schedule_id: @fee_schedule.id).first.value
            @fcs_units3 = TemplateTerminology.where(
              terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').third.id,
              visit_template_id: params[:visit_template_id].to_i
            ).first.units
            @next_available_fcs = 4
          end
        end
      end

      if @terminologies.where(coverage_type: 'Covered Service').count > 0
        @cs_charge1 = TerminologyFeeSchedule.where(
          terminology_id: @terminologies.where(coverage_type: 'Covered Service').first.id,
          fee_schedule_id: @fee_schedule.id).first.value
        @cs_units1 = TemplateTerminology.where(
          terminology_id: @terminologies.where(coverage_type: 'Covered Service').first.id,
          visit_template_id: params[:visit_template_id].to_i
        ).first.units
        @next_available_cs = 2

        if (@cs_charge1 > 0 && @terminologies.where(coverage_type: 'Covered Service').count > 1)
          @cs_charge2 = TerminologyFeeSchedule.where(
            terminology_id: @terminologies.where(coverage_type: 'Covered Service').second.id,
            fee_schedule_id: @fee_schedule.id).first.value
          @cs_units2 = TemplateTerminology.where(
            terminology_id: @terminologies.where(coverage_type: 'Covered Service').second.id,
            visit_template_id: params[:visit_template_id].to_i
          ).first.units
          @next_available_cs = 3

          if (@cs_charge2 > 0 && @terminologies.where(coverage_type: 'Covered Service').count > 2)
            @cs_charge3 = TerminologyFeeSchedule.where(
              terminology_id: @terminologies.where(coverage_type: 'Covered Service').third.id,
              fee_schedule_id: @fee_schedule.id).first.value
            @cs_units3 = TemplateTerminology.where(
              terminology_id: @terminologies.where(coverage_type: 'Covered Service').third.id,
              visit_template_id: params[:visit_template_id].to_i
            ).first.units
            @next_available_cs = 4
          end
        end
      end

      if @terminologies.where(coverage_type: 'Non-Covered Service').count > 0
        @ncs_charge1 = TerminologyFeeSchedule.where(
          terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').first.id,
          fee_schedule_id: @fee_schedule.id).first.value
        @ncs_units1 = TemplateTerminology.where(
          terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').first.id,
          visit_template_id: params[:visit_template_id].to_i
        ).first.units
        @next_available_ncs = 2

        if (@ncs_charge1 > 0 && @terminologies.where(coverage_type: 'Non-Covered Service').count > 1)
          @ncs_charge2 = TerminologyFeeSchedule.where(
            terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').second.id,
            fee_schedule_id: @fee_schedule.id).first.value
          @ncs_units = TemplateTerminology.where(
            terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').second.id,
            visit_template_id: params[:visit_template_id].to_i
          ).first.units
          @next_available_ncs = 3

          if (@ncs_charge2 > 0 && @terminologies.where(coverage_type: 'Non-Covered Service').count > 2)
            @ncs_charge3 = TerminologyFeeSchedule.where(
              terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').third.id,
              fee_schedule_id: @fee_schedule.id).first.value
            @ncs_units3 = TemplateTerminology.where(
              terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').third.id,
              visit_template_id: params[:visit_template_id].to_i
            ).first.units
            @next_available_ncs = 4
          end
        end
      end
    end
  end

  def populate_charges
    @template_terminologies = TemplateTerminology.where(visit_template_id: params[:visit_template_id].to_i)
    @terminologies = Terminology.where(id: @template_terminologies.pluck(:terminology_id))
    @fee_schedule = VisitTemplate.find(params[:visit_template_id].to_i)
    # @fee_schedule = FeeSchedule.find(params[:fee_schedule_id].to_i)

    @fcs_charge1 = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').first.id,
      fee_schedule_id: @fee_schedule.id).first.value
    if (@fcs_charge1 > 0 && @terminologies.where(coverage_type: 'Fully Covered Service').count > 1)
      @fcs_charge2 = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').second.id,
      fee_schedule_id: @fee_schedule.id).first.value

      if (@fcs_charge2 > 0 && @terminologies.where(coverage_type: 'Fully Covered Service').count > 2)
        @fcs_charge3 = TerminologyFeeSchedule.where(
          terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').third.id,
          fee_schedule_id: @fee_schedule.id).first.value
      end
    end

    @cs_charge1 = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Covered Service').first.id,
      fee_schedule_id: @fee_schedule.id).first.value
    if (@cs_charge1 > 0 && @terminologies.where(coverage_type: 'Covered Service').count > 1)
      @cs_charge2 = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Covered Service').second.id,
      fee_schedule_id: @fee_schedule.id).first.value

      if (@cs_charge2 > 0 && @terminologies.where(coverage_type: 'Covered Service').count > 2)
        @cs_charge3 = TerminologyFeeSchedule.where(
          terminology_id: @terminologies.where(coverage_type: 'Covered Service').third.id,
          fee_schedule_id: @fee_schedule.id).first.value
      end
    end

    @ncs_charge1 = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').first.id,
      fee_schedule_id: @fee_schedule.id).first.value
    if (@ncs_charge1 > 0 && @terminologies.where(coverage_type: 'Non-Covered Service').count > 1)
      @ncs_charge2 = TerminologyFeeSchedule.where(
      terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').second.id,
      fee_schedule_id: @fee_schedule.id).first.value

      if (@ncs_charge2 > 0 && @terminologies.where(coverage_type: 'Non-Covered Service').count > 2)
        @ncs_charge3 = TerminologyFeeSchedule.where(
          terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').third.id,
          fee_schedule_id: @fee_schedule.id).first.value
      end
    end
  end

  def populate_terminology_fields
    @terminology_type = params[:terminology_type]
    @terminology = Terminology.find(params[:terminology_id])
    if params[:fee_schedule_id].blank?
      @terminology_fee_schedule = TerminologyFeeSchedule.where(terminology_id: @terminology.id).first
    else
      @terminology_fee_schedule = TerminologyFeeSchedule.where(terminology_id: @terminology.id, fee_schedule_id: params[:fee_schedule_id]).first
    end
  end

  def populate_terminology_fields_temp
    @terminology = Terminology.find(params[:terminology_id])
    if params[:fee_schedule_id].blank?
      @terminology_fee_schedule = TerminologyFeeSchedule.where(terminology_id: @terminology.id).first
    else
      @terminology_fee_schedule = TerminologyFeeSchedule.where(terminology_id: @terminology.id, fee_schedule_id: params[:fee_schedule_id]).first
    end
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
