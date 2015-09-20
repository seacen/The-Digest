require 'date'
require_relative '../models/tgjson_importer'
require_relative '../models/tarss_importer'
require_relative '../models/hsrss_importer'
require_relative '../models/bbrss_importer'
require_relative '../models/terss_importer'
require_relative '../models/bbcrss_importer'
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authenticate_user, only: [:create, :index, :show, :scrape, :interests]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  def interests
    @articles = Article.tagged_with(curr_user.interest_list, any: true)
  end
  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  def scrape
    start_date = Date.today - 7
    end_date = Date.today
    importers = []
    importers << TgJsonImporter.new(start_date, end_date)
    importers << TaRssImporter.new(start_date, end_date)
    importers << HsRssImporter.new(start_date, end_date)
    importers << BbRssImporter.new(start_date, end_date)
    importers << TeRssImporter.new(start_date, end_date)
    importers << BbcRssImporter.new(start_date, end_date)

    importers.each(&:scrape)
    redirect_to articles_path, notice: 'refresh complete!'
  end

  # # GET /articles/1/edit
  # def edit
  # end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /articles/1
  # # PATCH/PUT /articles/1.json
  # def update
  #   respond_to do |format|
  #     if @article.update(article_params)
  #       format.html { redirect_to @article, notice: 'Article was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @article }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @article.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /articles/1
  # # DELETE /articles/1.json
  # def destroy
  #   @article.destroy
  #   respond_to do |format|
  #     format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:source_id, :title, :date_of_publication, :summary, :author_id, :image, :link)
    end
end
