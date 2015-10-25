require 'date'
require_relative '../models/tgjson_importer'
require_relative '../models/tarss_importer'
require_relative '../models/hsrss_importer'
require_relative '../models/bbrss_importer'
require_relative '../models/terss_importer'
require_relative '../models/bbcrss_importer'
require_relative '../models/search/search_engine'
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authenticate_user, only: [:create, :index, :show, :scrape, :interests]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  def search
    engine = SearchEngine.new
    @articles = engine.do_search(params[:q])
    render 'index'
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
        format.html do
          redirect_to @article, notice: 'Article was successfully created.'
        end
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:source_id, :title, :date_of_publication,
                                    :summary, :author_id, :image, :link)
  end
end
