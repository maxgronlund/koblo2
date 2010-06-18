class Follow < ActiveRecord::Base

  scope :for_follower,    lambda { |*args| {:conditions => ["follower_id = ? AND follower_type = ?", args.first.id, args.first.type.name]} }
  scope :for_followable, lambda { |*args| {:conditions => ["followable_id = ? AND followable_type = ?", args.first.id, args.first.type.name]} }
  scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  scope :descending, :order => "created_at DESC"
  scope :unblocked, :conditions => {:blocked => false}
  scope :blocked, :conditions => {:blocked => true}
  scope :inactive, :conditions => {:active => false}
  scope :active, :conditions => {:active => true}

  scope :for_user, lambda { |user| where('follower_id = ? OR followable_id = ? AND followable_type = ?', user.id, user.id, User.to_s).group('follower_id') }

  def relationship_with_user(user)
    if (follower.followed_by?(followable))
      'connected'
    elsif (user == followable)
      'follows you'
    else
      'following'
    end
  end

  def opposite_user_of(user)
    user == follower ? followable : follower
  end

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true

  def block!
    self.update_attribute(:blocked, true)
  end

  def activate!
    self.update_attribute(:active, true)
  end

end

