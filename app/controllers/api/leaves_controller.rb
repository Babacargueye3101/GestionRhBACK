class Api::LeavesController < ApplicationController

  before_action :set_leave, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]

    # GET /api/leaves
    def index
      @leaves = Leave.page(params[:page]).per(params[:per_page] || 10)

      render json: {
        conges: @leaves,
        meta: {
          total_pages: @leaves.total_pages,
          current_page: @leaves.current_page,
          total_count: @leaves.total_count
        }
      }
    end

    # GET /api/leaves/:id
    def show
      render json: @leave
    end

    # POST /api/leaves
    def create
      @leave = Leave.new(leave_params)

      if @leave.save
        render json: @leave, status: :created
      else
        render json: @leave.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/leaves/:id
    def update
      if @leave.update(leave_params)
        render json: @leave
      else
        render json: @leave.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/leaves/:id
    def destroy
      @leave.destroy
      head :no_content
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_leave
      @leave = Leave.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def leave_params
      params.require(:leave).permit(:employee_id, :leave_type, :start_date, :end_date, :reason, :status, :days_taken, :comments)
    end
end
