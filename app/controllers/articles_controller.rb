require 'date'
require_relative '../models/tgjson_importer'
require_relative '../models/tarss_importer'
require_relative '../models/hsrss_importer'
require_relative '../models/bbrss_importer'
require_relative '../models/tnjson_importer'
require_relative '../models/search/search_engine'
# ArticlesController
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :authenticate_user, except: [:admin_email, :scrape]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  def search
    return redirect_to articles_path if params[:q].nil?

    @articles = SearchEngine.do_search(params[:q])
    render 'index'
  end

  def user_email
    unless curr_user.subscribed
      return redirect_to(edit_user_path(curr_user.id),
                         alert: 'please subscribe to digest first')
    end

    articles = Article.tagged_with(curr_user.interest_list, any: true)
    if articles.empty?
      DigestMailer.empty_news(curr_user).deliver
    else
      DigestMailer.email(articles, curr_user).deliver
    end
    redirect_to interests_path,
                notice: 'The digest has been sent to your email address'
  end

  def admin_email
    pairs = []
    subscribers = User.where(subscribed: true)
    subscribers.each do |sb|
      pairs << [Article.tagged_with(sb.interest_list, any: true), sb]
    end
    pairs.each do |articles, user|
      if articles.empty?
        DigestMailer.empty_news(user).deliver
      else
        DigestMailer.email(articles, user).deliver
      end
    end

    redirect_to articles_path,
                notice: 'The digest has been sent to all subscribers'
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
    importers << TnJsonImporter.new(start_date, end_date)
    # importers << TeRssImporter.new(start_date, end_date)
    # importers << BbcRssImporter.new(start_date, end_date)

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
