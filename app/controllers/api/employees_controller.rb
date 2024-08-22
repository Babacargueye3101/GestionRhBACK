class Api::EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy, :upload_document]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy, :upload_document]
  def index
    if params[:role] === 'admin'
      @employees = Employee.page(params[:page]).per(params[:per_page] || 10)
      .where(compagny_id: params[:compagny_id])
      .order(updated_at: :DESC)
    else
      @employees = Employee.page(params[:page]).per(params[:per_page] || 10)
      .where(email: params[:email])
      .order(updated_at: :DESC)
    end

    render json: {
      employees: @employees,
      meta: {
        total_pages: @employees.total_pages,
        current_page: @employees.current_page,
        total_count: @employees.total_count
      }
    }
  end

  def getAll
    @employees = Employee.where(compagny_id: params[:id])
                         .order(gender: :DESC)
    all_conges= Leave.all.group(:status).count

    start_of_month = Date.current.beginning_of_month
    end_of_month = Date.current.end_of_month
    leaves_this_month = Leave.where(created_at: start_of_month..end_of_month).count

    render json: {
      employees: @employees,
      conge_statistique: all_conges,
      leaves_this_month: leaves_this_month,
      statistic_employees: {
        feminins: @employees.where(gender: 'female').count,
        masculins: @employees.where(gender: 'male').count,
        autres: @employees.where.not(gender: ['female', 'male']).count
      },
      total: @employees.count
    }
  end

  def show
    render json: @employee
  end

  def create
    if User.exists?(email: employee_params[:email])
      @employee = Employee.new(employee_params)

      if @employee.save
        render json: @employee, status: :created
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'User with this email does not exist' }, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    head :no_content
  end


  def upload_document
    if params[:contract_document].present?
      @employee.contract_document = params[:contract_document]
      if @employee.save
        document_url = @employee.contract_document.url
        @employee.update(url: document_url)
        render json: { message: 'Document uploaded successfully' }, status: :ok
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'No file provided' }, status: :bad_request
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :phone, :position, :compagny_id, :salary , :contrat_type,
                              :birthdate, :gender, :cniNumber)
  end
end
