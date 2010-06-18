class Follow < ActiveRecord::Base

  named_scope :for_follower,    lambda { |*args| {:conditions => ["follower_id = ? AND follower_type = ?", args.first.id, args.first.type.name]} }
  named_scope :for_followable, lambda { |*args| {:conditions => ["followable_id = ? AND followable_type = ?", args.first.id, args.first.type.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "created_at DESC"
  named_scope :unblocked, :conditions => {:blocked => false}
  named_scope :blocked, :conditions => {:blocked => true}
  named_scope :inactive, :conditions => {:active => false}
  named_scope :active, :conditions => {:active => true}

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

