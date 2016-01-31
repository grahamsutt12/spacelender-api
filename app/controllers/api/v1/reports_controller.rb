class Api::V1::ReportsController < ApplicationController
  before_filter :authenticate
  before_filter :require_admin, :only => [:show]

  api :POST, "/v1/users/:user_slug/reports", "File a new report, which is created by the current user."
  example Report.example_request
  param :report, Hash do
    param :ref_token, String, "Must be a reference token from Listing, Reservation, or a Payment.", :required => true
    param :explanation, String, "An explanation from the user regarding an incident that he or she is reporting.", :required => true
  end

  def create
    @report = @current_user.reports.build(report_params)

    if @report.save
      render :json => @report, :status => :ok
    else
      render :json => {:errors => @report.errors}, :status => :unprocessable_entity
    end
  end


  api :GET, "/v1/users/:user_slug/reports/:reference_token"
  description "User must have at least an \"employee\" or \"admin\" status (status: 1 or 2) to view a report. Below is an example of an expected repsonse."
  example Report.example_response
  def show
    render :json => @current_user.reports.find_by_ref_token(params[:id]), :status => :ok
  end
  

  private
  def report_params
    params.require(:report).permit(:ref_token, :explanation)
  end
end
