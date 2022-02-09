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
      @fee_schedule = VisitTemplate.find(params[:visit_template_id].to_i).fee_schedule_id
      # @fee_schedule = VisitTemplate.find(params[:visit_template_id].to_i)

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
          fee_schedule_id: @fee_schedule).first.value
        @fcs_units1 = TemplateTerminology.where(
          terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').first.id,
          visit_template_id: params[:visit_template_id].to_i
        ).first.units
        @next_available_fcs = 2

        if (@fcs_charge1 > 0 && @terminologies.where(coverage_type: 'Fully Covered Service').count > 1)
          @fcs_charge2 = TerminologyFeeSchedule.where(
            terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').second.id,
            fee_schedule_id: @fee_schedule).first.value
          @fcs_units2 = TemplateTerminology.where(
            terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').second.id,
            visit_template_id: params[:visit_template_id].to_i
          ).first.units
          @next_available_fcs = 3

          if (@fcs_charge2 > 0 && @terminologies.where(coverage_type: 'Fully Covered Service').count > 2)
            @fcs_charge3 = TerminologyFeeSchedule.where(
              terminology_id: @terminologies.where(coverage_type: 'Fully Covered Service').third.id,
              fee_schedule_id: @fee_schedule).first.value
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
          fee_schedule_id: @fee_schedule).first.value
        @cs_units1 = TemplateTerminology.where(
          terminology_id: @terminologies.where(coverage_type: 'Covered Service').first.id,
          visit_template_id: params[:visit_template_id].to_i
        ).first.units
        @next_available_cs = 2

        if (@cs_charge1 > 0 && @terminologies.where(coverage_type: 'Covered Service').count > 1)
          @cs_charge2 = TerminologyFeeSchedule.where(
            terminology_id: @terminologies.where(coverage_type: 'Covered Service').second.id,
            fee_schedule_id: @fee_schedule).first.value
          @cs_units2 = TemplateTerminology.where(
            terminology_id: @terminologies.where(coverage_type: 'Covered Service').second.id,
            visit_template_id: params[:visit_template_id].to_i
          ).first.units
          @next_available_cs = 3

          if (@cs_charge2 > 0 && @terminologies.where(coverage_type: 'Covered Service').count > 2)
            @cs_charge3 = TerminologyFeeSchedule.where(
              terminology_id: @terminologies.where(coverage_type: 'Covered Service').third.id,
              fee_schedule_id: @fee_schedule).first.value
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
          fee_schedule_id: @fee_schedule).first.value
        @ncs_units1 = TemplateTerminology.where(
          terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').first.id,
          visit_template_id: params[:visit_template_id].to_i
        ).first.units
        @next_available_ncs = 2

        if (@ncs_charge1 > 0 && @terminologies.where(coverage_type: 'Non-Covered Service').count > 1)
          @ncs_charge2 = TerminologyFeeSchedule.where(
            terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').second.id,
            fee_schedule_id: @fee_schedule).first.value
          @ncs_units = TemplateTerminology.where(
            terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').second.id,
            visit_template_id: params[:visit_template_id].to_i
          ).first.units
          @next_available_ncs = 3

          if (@ncs_charge2 > 0 && @terminologies.where(coverage_type: 'Non-Covered Service').count > 2)
            @ncs_charge3 = TerminologyFeeSchedule.where(
              terminology_id: @terminologies.where(coverage_type: 'Non-Covered Service').third.id,
              fee_schedule_id: @fee_schedule).first.value
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
    @fee_schedule = params[:fee_schedule_id].to_i

    if params[:terminology_fcs1].present?
      @fcs_charge1 = TerminologyFeeSchedule.where(
        terminology_id: params[:terminology_fcs1], fee_schedule_id: @fee_schedule).first.value
      if (@fcs_charge1 > 0 && params[:terminology_fcs2].present?)
        @fcs_charge2 = TerminologyFeeSchedule.where(
          terminology_id: params[:terminology_fcs2], fee_schedule_id: @fee_schedule).first.value

        if (@fcs_charge2 > 0 && params[:terminology_fcs3].present?)
          @fcs_charge3 = TerminologyFeeSchedule.where(
            terminology_id: params[:terminology_fcs3],
            fee_schedule_id: @fee_schedule).first.value
        end
      end
    end

    if params[:terminology_cs1].present?
      @cs_charge1 = TerminologyFeeSchedule.where(
        terminology_id: params[:terminology_cs1],fee_schedule_id: @fee_schedule).first.value
      if (@cs_charge1 > 0 && params[:terminology_cs2].present?)
        @cs_charge2 = TerminologyFeeSchedule.where(
          terminology_id: params[:terminology_cs2],fee_schedule_id: @fee_schedule).first.value

        if (@cs_charge2 > 0 && params[:terminology_cs3].present?)
          @cs_charge3 = TerminologyFeeSchedule.where(
            terminology_id: params[:terminology_cs3],fee_schedule_id: @fee_schedule).first.value
        end
      end
    end

    if params[:terminology_ncs1].present?
      @ncs_charge1 = TerminologyFeeSchedule.where(
        terminology_id: params[:terminology_ncs1], fee_schedule_id: @fee_schedule).first.value
      if (@ncs_charge1 > 0 && params[:terminology_ncs2].present?)
        @ncs_charge2 = TerminologyFeeSchedule.where(
          terminology_id: params[:terminology_ncs2], fee_schedule_id: @fee_schedule).first.value

        if (@ncs_charge2 > 0 && params[:terminology_ncs2].present?)
          @ncs_charge3 = TerminologyFeeSchedule.where(
            terminology_id: params[:terminology_ncs3], fee_schedule_id: @fee_schedule).first.value
        end
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

  def populate_terminology_fields_for_selected
    @terminology = Terminology.find(params[:terminology_id])
    if params[:fee_schedule_id].blank?
      @terminology_fee_schedule = TerminologyFeeSchedule.where(terminology_id: @terminology.id).first
    else
      @terminology_fee_schedule = TerminologyFeeSchedule.where(terminology_id: @terminology.id, fee_schedule_id: params[:fee_schedule_id]).first
    end
  end

  def create_template
    @visit_template = VisitTemplate.create(name: params[:new_template_name], fee_schedule_id: params[:fee_schedule_id])
    unless params[:terminology_fcs1].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_fcs1],
                                  units: params[:units_fcs1])
    end
    unless params[:terminology_fcs2].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_fcs2],
                                  units: params[:units_fcs2])
    end
    unless params[:terminology_fcs3].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_fcs3],
                                  units: params[:units_fcs3])
    end
    unless params[:terminology_fcs4].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_fcs4],
                                  units: params[:units_fcs4])
    end

    unless params[:terminology_cs1].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_cs1],
                                  units: params[:units_cs1])
    end
    unless params[:terminology_cs2].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_cs2],
                                  units: params[:units_cs2])
    end
    unless params[:terminology_cs3].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_cs3],
                                  units: params[:units_cs3])
    end
    unless params[:terminology_cs4].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_cs4],
                                  units: params[:units_cs4])
    end

    unless params[:terminology_ncs1].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_ncs1],
                                  units: params[:units_ncs1])
    end
    unless params[:terminology_ncs2].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_ncs2],
                                  units: params[:units_ncs2])
    end
    unless params[:terminology_ncs3].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_ncs3],
                                  units: params[:units_ncs3])
    end
    unless params[:terminology_ncs4].blank?
      TemplateTerminology.create!(visit_template_id: @visit_template.id,
                                  terminology_id: params[:terminology_ncs4],
                                  units: params[:units_ncs4])
    end


  end

  def update_template
    @visit_template = VisitTemplate.find(params[:visit_template_id])
    @visit_template.update_columns(fee_schedule_id: params[:fee_schedule_id]) if @visit_template.fee_schedule_id != params[:fee_schedule_id].to_i

    unless params[:terminology_fcs1].blank?
      fcs1 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs1])
      if fcs1.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs1],
                                    units: params[:units_fcs1])
      else
        fcs1.first.update_columns(units: params[:units_fcs1])
      end
    end

    unless params[:terminology_fcs2].blank?
      fcs2 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs2])
      if fcs2.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs2],
                                    units: params[:units_fcs2])
      else
        fcs2.first.update_columns(units: params[:units_fcs2])
      end
    end

    unless params[:terminology_fcs3].blank?
      fcs3 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs3])
      if fcs3.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs3],
                                    units: params[:units_fcs3])
      else
        fcs3.first.update_columns(units: params[:units_fcs3])
      end
    end

    unless params[:terminology_fcs4].blank?
      fcs4 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs4])
      if fcs4.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_fcs4],
                                    units: params[:units_fcs4])
      else
        fcs4.first.update_columns(units: params[:units_fcs4])
      end
    end

    unless params[:terminology_cs1].blank?
      cs1 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs1])
      if cs1.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs1],
                                    units: params[:units_cs1])
      else
        cs1.first.update_columns(units: params[:units_cs1])
      end
    end

    unless params[:terminology_cs2].blank?
      cs2 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs2])
      if cs2.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs2],
                                    units: params[:units_cs2])
      else
        cs2.first.update_columns(units: params[:units_cs2])
      end
    end

    unless params[:terminology_cs3].blank?
      cs3 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs3])
      if cs3.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs3],
                                    units: params[:units_cs3])
      else
        cs3.first.update_columns(units: params[:units_cs3])
      end
    end

    unless params[:terminology_cs4].blank?
      cs4 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs4])
      if cs4.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_cs4],
                                    units: params[:units_cs4])
      else
        cs4.first.update_columns(units: params[:units_cs4])
      end
    end

    unless params[:terminology_ncs1].blank?
      ncs1 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs1])
      if ncs1.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs1],
                                    units: params[:units_ncs1])
      else
        ncs1.first.update_columns(units: params[:units_ncs1])
      end
    end

    unless params[:terminology_ncs2].blank?
      ncs2 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs2])
      if ncs2.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs2],
                                    units: params[:units_ncs2])
      else
        ncs2.first.update_columns(units: params[:units_ncs2])
      end
    end

    unless params[:terminology_ncs3].blank?
      ncs3 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs3])
      if ncs3.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs3],
                                    units: params[:units_ncs3])
      else
        ncs3.first.update_columns(units: params[:units_ncs3])
      end
    end

    unless params[:terminology_ncs4].blank?
      ncs4 = TemplateTerminology.where(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs4])
      if ncs4.blank?
        TemplateTerminology.create!(visit_template_id: @visit_template.id, terminology_id: params[:terminology_ncs4],
                                    units: params[:units_ncs4])
      else
        ncs4.first.update_columns(units: params[:units_ncs4])
      end
    end
  end

  def remove_terminology
    TemplateTerminology.where(visit_template_id: params[:visit_template_id].to_i, terminology_id: params[:terminology_id].to_i).last.destroy
  end

  def print_pdf
    @patient_name = params[:patient_name]

    @terminology_fcs1 = params[:terminology_fcs1]
    @terminology_fcs2 = params[:terminology_fcs2]
    @terminology_fcs3 = params[:terminology_fcs3]
    @terminology_fcs4 = params[:terminology_fcs4]
    @description_fcs1 = params[:description_fcs1]
    @description_fcs2 = params[:description_fcs2]
    @description_fcs3 = params[:description_fcs3]
    @description_fcs4 = params[:description_fcs4]
    @total_fcs1 = params[:total_fcs1]
    @total_fcs2 = params[:total_fcs2]
    @total_fcs3 = params[:total_fcs3]
    @total_fcs4 = params[:total_fcs4]
    @subtotal_fcs = params[:subtotal_fcs]

    @terminology_cs1 = params[:terminology_cs1]
    @terminology_cs2 = params[:terminology_cs2]
    @terminology_cs3 = params[:terminology_cs3]
    @terminology_cs4 = params[:terminology_cs4]
    @description_cs1 = params[:description_cs1]
    @description_cs2 = params[:description_cs2]
    @description_cs3 = params[:description_cs3]
    @description_cs4 = params[:description_cs4]
    @total_cs1 = params[:total_cs1]
    @total_cs2 = params[:total_cs2]
    @total_cs3 = params[:total_cs3]
    @total_cs4 = params[:total_cs4]
    @subtotal_cs = params[:subtotal_cs]

    @terminology_ncs1 = params[:terminology_ncs1]
    @terminology_ncs2 = params[:terminology_ncs2]
    @terminology_ncs3 = params[:terminology_ncs3]
    @terminology_ncs4 = params[:terminology_ncs4]
    @description_ncs1 = params[:description_ncs1]
    @description_ncs2 = params[:description_ncs2]
    @description_ncs3 = params[:description_ncs3]
    @description_ncs4 = params[:description_ncs4]
    @total_ncs1 = params[:total_ncs1]
    @total_ncs2 = params[:total_ncs2]
    @total_ncs3 = params[:total_ncs3]
    @total_ncs4 = params[:total_ncs4]
    @subtotal_ncs = params[:subtotal_ncs]

    @total_cost = params[:total_cost]
    @insurance_pays = params[:insurance_pays]
    @patient_copay = params[:patient_copay]
    @patient_deductible = params[:patient_deductible]
    @patient_coins = params[:patient_coins]
    @patient_total_out_of_pocket_estimate = params[:patient_total_out_of_pocket_estimate]

    @visit_templates = VisitTemplate.all
    respond_to do |format|
      format.pdf do
        render template: "cost_estimates/print_pdf.html.erb",
               :save_to_file => Rails.root.join('public', "test.pdf"),
               :save_only    => true
      end
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
