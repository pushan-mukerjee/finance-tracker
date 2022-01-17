class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
      return "#{first_name} #{lastname}" if first_name || lastname
      "Anonymous"
  end

  def self.search(searchParameter)
    searchParameter.strip!
    to_send_back = (firstNameMatches(searchParameter) + lastNameMatches(searchParameter) + emailMatches(searchParameter)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.firstNameMatches(searchParameter)
     matches('first_name', searchParameter)
  end

  def self.lastNameMatches(searchParameter)
     matches('lastname', searchParameter)
  end

  def self.emailMatches(searchParameter)
     matches('email', searchParameter)
  end

  def self.matches(fieldName, searchParameter)
     where("#{fieldName} like ?", "%#{searchParameter}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(friendId)
    !self.friends.where(id: friendId).exists?
  end
end
