class Api::V1::ReportsController < ApplicationController
  before_filter :authenticate
  before_filter :require_admin

  def create
    @report = @current_user.reports.build(report_params)

    if @report.save
      render :json => @report, :status => :ok
    else
      render :json => {:errors => @report.errors}, :status => :unprocessable_entity
    end
  end

  def show
    render :json => @current_user.reports.find_by_ref_token(params[:id]), :status => :ok
  end

  private
  def report_params
    params.require(:report).permit(:ref_token, :explanation)
  end
end
