class DigestMailer < ApplicationMailer
  def email(articles, user)
    @articles = articles
    @user = user
    mail(to: %(#{@user.full_name} <#{@user.email}>), subject: 'Your News Digest')
  end

  def empty_news(user)
    @user = user
    mail(to: %(#{@user.full_name} <#{@user.email}>), subject: 'No Articles Matching Your Interests Are Available')
  end
end
