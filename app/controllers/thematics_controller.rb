class ThematicsController < ApplicationController
  def index
    @pagy, @thematics = pagy(authorize(Thematic.order(sort_column + " " + sort_direction)))
  end

  def show
    @thematic = authorize Thematic.find(params[:id])
  end

  def new
    @thematic = authorize Thematic.new
  end

  def create
    @thematic = authorize Thematic.new(thematic_params)

    if @thematic.save
      redirect_to thematics_url
    else
      render :new
    end
  end

  def edit
    @thematic = authorize Thematic.find(params[:id])
  end

  def update
    @thematic = authorize Thematic.find(params[:id])

    if @thematic.update(thematic_params)
      redirect_to thematics_url
    else
      render :edit
    end
  end

  def destroy
    @thematic = authorize Thematic.find(params[:id])
    @thematic.destroy

    redirect_to thematics_url
  end

  def import
    authorize Thematic, :create?

    Spreadsheets::ThematicSpreadsheet.new.import(params[:file])

    redirect_to thematics_url
  end

  private
    def thematic_params
      params.require(:thematic).permit(:code, :name, :description)
    end
end
